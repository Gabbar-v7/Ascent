import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

List<Widget> timerActions() =>
    [IconButton(onPressed: () {}, icon: Icon(Icons.settings)), const Gap(10)];

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
        const Gap(42),
        modeLabel("Focus"),
        const Gap(32),
        animatedCounter(),
        const Gap(48),
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
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 18),
        child: Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
            fontSize: 20, // Reduced from 22
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget animatedCounter() {
    // Responsive font size based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth < 400 ? 72.0 : 85.0;

    final counterTextStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );

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
    const secondaryIconSize = 22.0;
    const primaryIconSize = 42.0;
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
      borderRadius: BorderRadius.circular(10),
      shape: BoxShape.rectangle,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 18,
      children: [
        Container(
          decoration: secondaryBoxDecoration,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
            iconSize: secondaryIconSize,
          ),
        ),
        Container(
          decoration: primaryBoxDecoration,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.pause),
            iconSize: primaryIconSize,
            padding: EdgeInsets.all(10),
          ),
        ),
        Container(
          decoration: secondaryBoxDecoration,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.skip_next),
            iconSize: secondaryIconSize,
          ),
        )
      ],
    );
  }
}
