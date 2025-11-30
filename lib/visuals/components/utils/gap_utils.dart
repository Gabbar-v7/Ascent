import 'package:gap/gap.dart';

enum GapEnum {
  section(gap: Gap(20)),
  sectionHeader(gap: Gap(7)),
  sectionContent(gap: Gap(3));

  const GapEnum({required this.gap});

  final Gap gap;
}
