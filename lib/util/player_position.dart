import 'dart:math';

(int, int) getPosition(int index) {
  if (index < 10) {
    return (10, index);
  } else if (index < 20) {
    return (10 - index, 10);
  } else if (index < 30) {
    return (0, 10 - (index - 20));
  } else {
    return (index - 30, 0);
  }
}

double getDirection(int position) {
  if (position < 10) {
    return pi;
  } else if (position < 20) {
    return -pi / 2;
  } else if (position < 30) {
    return 2 * pi;
  } else {
    return pi / 2;
  }
}
