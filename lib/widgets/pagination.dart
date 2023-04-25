

import '../utils/exports.dart';

class Pagination extends StatelessWidget {
  final int itemsLength;
  final int current;
  final Color? activeColor;
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
