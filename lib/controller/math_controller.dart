import 'dart:math';

class ServoMathModel {
  // Coefficients for Servo 1
  static const double Servo1_p1 = 0.1355;
  static const double Servo1_p2 = -68.9502;

  // Coefficients for Servo 2
  static const double Servo2_p1 = 0.1345;
  static const double Servo2_p2 = -65.8601;

  // Coefficients for Servo 3
  static const double Servo3_p1 = 0.1352;
  static const double Servo3_p2 = -69.1186;

  // Coefficients for Servo 4
  static const double Servo4_p1 = 0.1337;
  static const double Servo4_p2 = -75.3556;

  // Coefficients for Servo 5
  static const double Servo5_p1 = 0.3136;
  static const double Servo5_p2 = 0.8976;
  static const double Servo5_p3 = -90.9239;

  // Coefficients for Servo 6
  static const double Servo6_p1 = 0.1343;
  static const double Servo6_p2 = -73.0095;

  // Method for Servo 1 model
  static double servo1Model(int x) {
    return (Servo1_p1 * x) + Servo1_p2;
  }

  // Method for Servo 2 model
  static double servo2Model(int x) {
    return (Servo2_p1 * x) + Servo2_p2;
  }

  // Method for Servo 3 model
  static double servo3Model(int x) {
    return (Servo3_p1 * x) + Servo3_p2;
  }

  // Method for Servo 4 model
  static double servo4Model(int x) {
    return (Servo4_p1 * x) + Servo4_p2;
  }

  // Method for Servo 5 model
  static double servo5Model(int x) {
    return (Servo5_p1 * pow(x, Servo5_p2)) + Servo5_p3;
  }

  // Method for Servo 6 model
  static double servo6Model(int x) {
    return (Servo6_p1 * x) + Servo6_p2;
  }

  // Static method for calculating joint angle
  static double calculateJointAngle(int i, int jointFeedback) {
    switch (i) {
      case 0:
        return servo1Model(jointFeedback);
      case 1:
        return servo2Model(jointFeedback);
      case 2:
        return servo3Model(jointFeedback);
      case 3:
        return servo4Model(jointFeedback);
      case 4:
        return servo5Model(jointFeedback);
      case 5:
        return servo6Model(jointFeedback);
      default:
        throw ArgumentError("Invalid index: $i");
    }
  }
}