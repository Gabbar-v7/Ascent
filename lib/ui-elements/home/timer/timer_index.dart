import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TimerIndex extends StatefulWidget {
  const TimerIndex({super.key});

  @override
  State<TimerIndex> createState() => _TimerIndexState();
}

class _TimerIndexState extends State<TimerIndex> {
  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: double.infinity,
        ),
        modeLabel("Focus"),
        const Gap(48),
        animatedCounter(),
        const Gap(76),
        controlButtons(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget modeLabel(String label) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
            color: Theme.of(context).colorScheme.onSurface, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        child: Text(
          "Focus",
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget animatedCounter() {
    const counterTextStyle =
        TextStyle(fontSize: 100, fontWeight: FontWeight.bold);

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedFlipCounter(
            value: 25,
            wholeDigits: 2,
            textStyle: counterTextStyle,
          ),
          Text(
            ':',
            style: counterTextStyle,
          ),
          AnimatedFlipCounter(
            value: 00,
            wholeDigits: 2,
            textStyle: counterTextStyle,
          )
        ]);
  }

  Widget controlButtons() {
    const secondaryIconSize = 25.0;
    const primaryIconSize = 48.0;
    final secondaryBoxDecoration = BoxDecoration(
      color: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.1),
      shape: BoxShape.circle,
    );
    final primaryBoxDecoration = BoxDecoration(
      color: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.2),
      shape: BoxShape.circle,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 22,
      children: [
        Container(
          decoration: secondaryBoxDecoration,
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.refresh),
            iconSize: secondaryIconSize,
          ),
        ),
        Container(
          decoration: primaryBoxDecoration,
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.pause),
            iconSize: primaryIconSize,
          ),
        ),
        Container(
          decoration: secondaryBoxDecoration,
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.skip_next),
            iconSize: secondaryIconSize,
          ),
        )
      ],
    );
  }
}
