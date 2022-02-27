import 'package:animated_listing/animated_listing.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AnimatedListingExample());
}

class AnimatedListingExample extends StatefulWidget {
  const AnimatedListingExample({Key? key}) : super(key: key);

  @override
  State<AnimatedListingExample> createState() => _AnimatedListingExampleState();
}

class _AnimatedListingExampleState extends State<AnimatedListingExample> {
  late final list = List.generate(
    50,
    (index) => AnimatedListingExampleItem(
      fullName: 'Syed Murtaza',
      phoneNumber: '+92 311 123456',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: AnimatedListingWidget(
          itemBuilder: (_, i) => ItemWidget(item: list[i]),
          itemsCount: list.length,
          separatorBuilder: (_, __) => const Divider(),
          animatedListingType: AnimatedListingType.elevation,
          animationDuration: const Duration(seconds: 5),
          animatedResizeOptions: const AnimatedResizeOptions(finalHeight: 50),
        ),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({required this.item, Key? key}) : super(key: key);

  final AnimatedListingExampleItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 48,
          width: 48,
          child: ClipOval(
            child: ColoredBox(
              color: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.fullName,
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                item.phoneNumber,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class AnimatedListingExampleItem {
  AnimatedListingExampleItem({
    required this.fullName,
    required this.phoneNumber,
  });

  final String fullName;
  final String phoneNumber;
}
