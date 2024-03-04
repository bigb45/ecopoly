import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/models/property.dart';
import 'package:ecopoly/widgets/animated_shadow_container.dart';
import 'package:flutter/material.dart';

const cellRadius = 12.0;

class BlurryContainer extends StatelessWidget {
  final double width;
  final double height;
  final double blurStrength;
  final Cell cell;

  final Widget child;
  final Widget? centerChild;

  const BlurryContainer({
    super.key,
    required this.width,
    required this.height,
    required this.blurStrength,
    required this.child,
    required this.cell,
    this.centerChild,
  });

  @override
  Widget build(BuildContext context) {
    bool isProperty = cell.type == CellType.property ||
        cell.type == CellType.bikelane ||
        cell.type == CellType.utility;

    return Container(
      // shadow of the whole cell
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(cellRadius),
          color: Color(int.parse("0xFF130F2D")),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 0),
            ),
          ]),
      child: ClipPath(
        clipper: CustomRoundedClipper(
          borderRadius: cellRadius,
          padding: EdgeInsets.only(
            top: cell.index > 20 && cell.index < 30 ? 100 : 0,
            bottom: cell.index < 11 ? 100 : 0,
            left: cell.index > 10 && cell.index < 20 ? 100 : 0,
            right: cell.index > 30 && cell.index < 40 ? 100 : 0,
          ),
        ),

        // player ownership shadow
        child: AnimatedShadowContainer(
          cellRadius: cellRadius,
          ownerColor: isProperty ? (cell as Property).owner?.color : null,
          width: width,
          height: height,
          isProperty: isProperty,
          // decoration: BoxDecoration(
          //   color: Colors.transparent,
          //   borderRadius: BorderRadius.circular(cellRadius),
          //   boxShadow: [
          //     BoxShadow(
          //       color: isProperty
          //           ? (cell as Property).owner?.color ?? Colors.transparent
          //           : Colors.transparent,
          //       spreadRadius: 10,
          //       blurRadius: 10,
          //       offset: const Offset(0, 0),
          //     ),
          //   ],
          // ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(cellRadius),
                child: Image.asset(
                  cell.imageName,
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                // opacity over the whole cell
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(cellRadius),
                ),
                child: centerChild ?? Container(),
              ),
              if (isProperty && (cell as Property).owner == null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        // price tag opacity
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 1, horizontal: 2),
                        child: Text(
                          "\$${(cell as Property).cost}",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 11),
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: height, width: width, child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomRoundedClipper extends CustomClipper<Path> {
  final double borderRadius;
  final EdgeInsets padding;

  const CustomRoundedClipper({
    required this.borderRadius,
    this.padding = EdgeInsets.zero,
  });

  @override
  Path getClip(Size size) {
    final rect = padding.inflateRect(Offset.zero & size);
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));
  }

  @override
  bool shouldReclip(CustomRoundedClipper oldClipper) =>
      oldClipper.borderRadius != borderRadius || oldClipper.padding != padding;
}
