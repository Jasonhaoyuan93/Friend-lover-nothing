import 'package:flutter/material.dart';
import 'package:friend_lover_nothing/model/event.dart';
import 'package:friend_lover_nothing/widget/event_view.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';

class TictokScroll extends StatefulWidget {
  const TictokScroll({Key? key, required this.eventData}) : super(key: key);

  final List<Event> eventData;

  @override
  State<TictokScroll> createState() => _TictokScrollState();
}

class _TictokScrollState extends State<TictokScroll> {
  late Controller controller;

  @override
  initState() {
    controller = Controller();
    // controller.jumpToPosition(4);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TikTokStyleFullPageScroller(
      contentSize: widget.eventData.length,
      swipePositionThreshold: 0.2,
      // ^ the fraction of the screen needed to scroll
      swipeVelocityThreshold: 600,
      // ^ the velocity threshold for smaller scrolls
      animationDuration: const Duration(milliseconds: 400),
      // ^ how long the animation will take
      controller: controller,
      // ^ registering our own function to listen to page changes
      builder: (BuildContext context, int index) {
        int reversedIndex = widget.eventData.length - index - 1;
        if (reversedIndex < 0 || reversedIndex >= widget.eventData.length) {
          reversedIndex = widget.eventData.length - 1;
        }
        return Container(
            color: Colors.black,
            child: EventView(event: widget.eventData[reversedIndex]));
      },
    );
  }
}
