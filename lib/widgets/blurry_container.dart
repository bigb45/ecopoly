import 'package:ecopoly/models/cell.dart';
import 'package:ecopoly/models/property.dart';
import 'package:flutter/material.dart';

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
    return ClipRect(
      clipper: ClipPad(
        padding: EdgeInsets.only(
          top: cell.index > 20 && cell.index < 30 ? 100 : 0,
          bottom: cell.index < 11 ? 100 : 0,
          left: cell.index > 10 && cell.index < 20 ? 100 : 0,
          right: cell.index > 30 && cell.index < 40 ? 100 : 0,
        ),
      ),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: isProperty
                  ? (cell as Property).owner?.color ?? Colors.transparent
                  : Colors.transparent,
              spreadRadius: 10,
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
          ],
          border: Border.all(
              color: Colors.black,
              width: 1,
              strokeAlign: BorderSide.strokeAlignCenter),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Image.asset(
                cell.imageName,
                width: width,
                height: height,
                fit: BoxFit.cover,
              ),
            ),

            Container(
              width: width,
              height: height,
              color: Colors.black.withOpacity(0.4),
              child: centerChild ?? Container(),
            ),

            if (isProperty && (cell as Property).owner == null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 2),
                      child: Text(
                        "\$${(cell as Property).cost}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
                ),
              ),
            // if ((cell.type == CellType.property ||
            //         cell.type == CellType.utility ||
            //         cell.type == CellType.railroad) &&
            //     (cell as Property).owner != null)
            //   ClipRect(
            //     clipper: const ClipPad(padding: EdgeInsets.only(top: 3)),
            //     child: Container(
            //       height: 12,
            //       width: width,
            //       decoration: BoxDecoration(
            //         color: (cell as Property).owner!.color,
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.black.withOpacity(0.5),
            //             spreadRadius: 1,
            //             blurRadius: 5,
            //             offset: const Offset(0, 0),
            //           ),
            //         ],
            //         borderRadius: const BorderRadius.only(
            //           topLeft: Radius.circular(2),
            //           topRight: Radius.circular(2),
            //         ),
            //       ),
            //     ),
            //   ),
            SizedBox(height: height, width: width, child: child),
          ],
        ),
      ),
    );
  }
}

class ClipPad extends CustomClipper<Rect> {
  final EdgeInsets padding;

  const ClipPad({this.padding = EdgeInsets.zero});

  @override
  Rect getClip(Size size) => padding.inflateRect(Offset.zero & size);

  @override
  bool shouldReclip(ClipPad oldClipper) => oldClipper.padding != padding;
}
