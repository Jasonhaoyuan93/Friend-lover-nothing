import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:friend_lover_nothing/model/event.dart';
import 'package:friend_lover_nothing/pages/like_page.dart';

class EventView extends StatefulWidget {
  const EventView({super.key, required this.event});
  final Event event;
  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  @override
  Widget build(BuildContext context) {
    return PageView(
        controller: PageController(),
        scrollDirection: Axis.horizontal,
        children: createViews(context, widget.event));
  }
}

List<GestureDetector> createViews(context, event) {
  return List.from(event.eventImages.map(
    (image) => GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LikePage(event: event)));
      },
      child: Stack(fit: StackFit.passthrough, children: [
        FittedBox(
            fit: BoxFit.fitWidth,
            child: Center(
              child: CachedNetworkImage(
                imageUrl: image.imageLocation!,
              ),
            )),
        Positioned(
          bottom: 15,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 12,
            child: Text(image.imageDescription,
                maxLines: 3,
                softWrap: true,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                semanticsLabel: image.imageDescription),
          ),
        )
      ]),
    ),
  ));
}
