import '../utils/exports.dart';

// This is a pagination widget which is used for showing pagination for carousel slider
class Pagination extends StatelessWidget {
  // The length of the items
  final int itemsLength;
  // The current item
  final int current;
  // The color for the active item
  final Color? activeColor;
  // The color for the inactive item
  final Color? inactiveColor;
  const Pagination(
      {Key? key,
      required this.itemsLength,
      required this.current,
      this.activeColor,
      this.inactiveColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      for (int i = 0; i < itemsLength; i++)
        Container(
          width: i == current ? 40 : 6,
          height: i == current ? 5 : 6,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: current == i
                ? activeColor ?? Constants.appBarColor
                : inactiveColor ?? Colors.black12,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
    ]);
  }
}
