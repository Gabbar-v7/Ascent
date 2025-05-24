import 'dart:convert';
import 'dart:io';

import 'package:ascent/database/app_database.dart';
import 'package:ascent/services/drift_service.dart';
import 'package:ascent/utils/general_utils.dart';
import 'package:ascent/visuals/components/app_styles.dart';
import 'package:ascent/visuals/screens/notes/edit_note.dart';
import 'package:ascent/visuals/screens/notes/view_note.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> with TickerProviderStateMixin {
  final database = DriftService.instance.driftDB;
  List<Note> _notes = [];
  Map<String, List<Note>>? _categorizedNotesCache;
  final TextEditingController _noteTitleController = TextEditingController();
  final TextEditingController _noteBodyController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Note> _filteredNotes = [];
  late AnimationController _fabAnimationController;
  bool _isGridView = false; // Toggle between grid and list view

  @override
  void initState() {
    super.initState();
    _fetchNotes();
    _searchController.addListener(_filterNotes);
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _noteTitleController.dispose();
    _noteBodyController.dispose();
    _searchController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _filterNotes() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredNotes = _notes;
        _isSearching = false;
      });
    } else {
      setState(() {
        _filteredNotes =
            _notes.where((note) {
              return note.noteTitle.toLowerCase().contains(query) ||
                  (note.noteBody?.toLowerCase().contains(query) ?? false);
            }).toList();
        _isSearching = true;
      });
    }
  }

  Future<void> _fetchNotes() async {
    final notes =
        await (database.select(database.notes)
              ..where((tbl) => tbl.isTrashed.isNull())
              ..orderBy([
                (t) => drift.OrderingTerm(
                  expression: t.isPinned,
                  mode: drift.OrderingMode.desc,
                ),
                (t) => drift.OrderingTerm(
                  expression: t.updatedAt,
                  mode: drift.OrderingMode.desc,
                ),
              ]))
            .get();
    if (mounted) {
      setState(() {
        _notes = notes;
        _filteredNotes = notes;
        _categorizedNotesCache = null;
      });
    }
  }

  Future<void> _deleteNote(Note note) async {
    await (database.delete(database.notes)
      ..where((tbl) => tbl.id.equals(note.id))).go();
    await _fetchNotes();
  }

  Future<void> _togglePinNote(Note note) async {
    final isPinned = !(note.isPinned ?? false);

    setState(() {
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = note.copyWith(
          isPinned: drift.Value(isPinned),
          updatedAt: DateTime.now(),
        );
      }
      _categorizedNotesCache = null;
    });

    await (database.update(database.notes)
      ..where((tbl) => tbl.id.equals(note.id))).write(
      NotesCompanion(
        isPinned: drift.Value(isPinned),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
  }

  // Note sharing utilities
  Future<void> _shareNoteAsFile(Note note) async {
    final fileName = generateRandomString(7);

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName.asn');
    await file.writeAsString(
      jsonEncode({
        "secret": "tL4dYFV",
        "noteTitle": note.noteTitle,
        "noteBody": note.noteBody,
      }),
    );

    final params = ShareParams(
      files: [
        XFile(
          file.path,
          mimeType: 'application/octet-stream',
          name: '$fileName.asn',
        ),
      ],
      title: note.noteTitle,
      text: "${note.noteTitle}\n\n${note.noteBody ?? ""}",
    );

    await SharePlus.instance.share(params);
  }

  void _copyNoteToClipboard(Note note) {
    Clipboard.setData(
      ClipboardData(text: "${note.noteTitle}\n\n${note.noteBody ?? ""}"),
    );
  }

  // Note organization
  Map<String, List<Note>> _categorizeNotes() {
    if (_categorizedNotesCache != null) return _categorizedNotesCache!;

    final notesToUse = _isSearching ? _filteredNotes : _notes;

    return _categorizedNotesCache = {
      "Pinned": notesToUse.where((note) => note.isPinned == true).toList(),
      "All Notes": notesToUse.where((note) => note.isPinned != true).toList(),
    };
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      final weekday = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      return weekday[dateTime.weekday - 1];
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  // UI Components
  Widget _buildNotesList() {
    final categorizedNotes = _categorizeNotes();
    final theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...categorizedNotes.entries.where((e) => e.value.isNotEmpty).map((
              entry,
            ) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 16,
                      bottom: 8,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          entry.key == "Pinned"
                              ? Icons.push_pin_outlined
                              : Icons.edit,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        const Gap(8),
                        Text(
                          entry.key,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _isGridView
                      ? MasonryGridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: entry.value.length,
                        itemBuilder:
                            (context, idx) => _buildNoteCard(entry.value[idx]),
                      )
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: entry.value.length,
                        itemBuilder:
                            (context, idx) =>
                                _buildNoteListTile(entry.value[idx]),
                      ),
                ],
              );
            }),
            const Gap(80), // Extra space at bottom for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    final theme = Theme.of(context);
    final isPinned = note.isPinned ?? false;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Hero(
        tag: 'note_${note.id}',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewNote(note)),
                ).then((_) => _fetchNotes()),
            onLongPress: () => _showNoteOptions(note),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.05),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          note.noteTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (isPinned)
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.push_pin_outlined,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                    ],
                  ),
                  const Divider(height: 16),
                  Text(
                    note.noteBody ?? "",
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                    ),
                  ),
                  const Gap(6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDate(note.updatedAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                          fontSize: 10,
                        ),
                      ),
                      if (note.noteBody != null && note.noteBody!.length > 100)
                        Text(
                          '${note.noteBody!.length} chars',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.4,
                            ),
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoteListTile(Note note) {
    final theme = Theme.of(context);
    final isPinned = note.isPinned ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Hero(
        tag: 'note_${note.id}',
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: theme.dividerColor.withValues(alpha: 0.5),
              ),
            ),
            tileColor: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.2,
            ),
            title: Text(
              note.noteTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (note.noteBody != null && note.noteBody!.isNotEmpty)
                  Text(
                    note.noteBody!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const Gap(4),
                Text(
                  _formatDate(note.updatedAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            trailing:
                isPinned
                    ? Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.push_pin_outlined,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                    )
                    : null,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewNote(note)),
                ).then((_) => _fetchNotes()),
            onLongPress: () => _showNoteOptions(note),
          ),
        ),
      ),
    );
  }

  void _showNoteOptions(Note note) {
    final theme = Theme.of(context);
    final isPinned = note.isPinned ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Gap(16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Icon(
                            Icons.note_alt,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.noteTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _formatDate(note.updatedAt),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 32),
                  _buildOptionTile(
                    context,
                    icon: Icons.edit_outlined,
                    label: 'Edit Note',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditNote(note)),
                      ).then((_) => _fetchNotes());
                    },
                  ),
                  _buildOptionTile(
                    context,
                    icon: isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                    label: isPinned ? 'Unpin Note' : 'Pin Note',
                    onTap: () {
                      _togglePinNote(note);
                      Navigator.pop(context);
                    },
                  ),
                  _buildOptionTile(
                    context,
                    icon: Icons.content_copy_outlined,
                    label: 'Copy Note',
                    onTap: () {
                      _copyNoteToClipboard(note);
                      Navigator.pop(context);
                    },
                  ),
                  _buildOptionTile(
                    context,
                    icon: Icons.share_outlined,
                    label: 'Share Note',
                    onTap: () {
                      _shareNoteAsFile(note);
                      Navigator.pop(context);
                    },
                  ),
                  _buildOptionTile(
                    context,
                    icon: Icons.delete_outline,
                    label: 'Delete Permanently',
                    color: theme.colorScheme.error,
                    onTap: () {
                      _deleteNote(note);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: color ?? theme.colorScheme.onSurface),
      title: Text(
        label,
        style: theme.textTheme.bodyLarge?.copyWith(color: color),
      ),
      onTap: onTap,
      dense: true,
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notes_rounded,
              size: 64,
              color: theme.colorScheme.primary,
            ),
          ),
          const Gap(24),
          Text(
            _isSearching ? "No matching notes found" : "No notes yet",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _isSearching
                  ? "Try searching with different keywords"
                  : "Capture your ideas, lists, and reminders",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          if (!_isSearching) ...[
            const Gap(32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditNote(null)),
                ).then((_) => _fetchNotes());
              },
              icon: const Icon(Icons.add),
              label: const Text("Create Note"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,

        decoration: InputDecoration(
          fillColor: Colors.transparent,
          hintText: 'Search notes',
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final notesToShow = _isSearching ? _filteredNotes : _notes;

    return Scaffold(
      appBar: AppStyles.appBar(
        "Notes",
        context,
        actions: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.format_list_bulleted : Icons.grid_view,
              size: 22,
            ),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort, size: 24),
            onPressed: () {
              // Show sorting options in the future
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sorting options coming soon')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: notesToShow.isEmpty ? _buildEmptyState() : _buildNotesList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'NotesHero',
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditNote(null)),
          ).then((_) => _fetchNotes());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
