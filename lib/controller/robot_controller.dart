import 'dart:async';

import 'package:get/get.dart';

class RobotController extends GetxController {
  static RobotController instance = Get.find();

  // Initiallization
  RobotController() {
    addPointList("Init", "130", "130", "130", "130", "130", "130");
  }

  Timer? _timer;

  var selectedMode = 'Live Control'.obs; 
  var selectedProgram = 'Sorting'.obs; 
  var selectedXYZMode = 'X'.obs;
  var selectedAction = ''.obs;
  var jointAngle = <double>[0.0, 0.0, 0.0, 0.0, 0.0, 0.0].obs;
  var cartesianValue = <double>[0.0, 0.0, 0.0, 0.0, 0.0, 0.0].obs;
  var switchControl = true.obs;
  var end_effector_control = false.obs;
  var fruit_conveyor_control = false.obs;
  var box_conveyor_control = false.obs;


  var live_playProgram = "Program Stop".obs;
  var simulation_playProgram = "Program Stop".obs;
  var cartesianExecution = "Off".obs;
  var act_joint = <String>["","","","","",""].obs;
  //var act_pos = <String>["","",""].obs;
  var act_pos = <String>["","","","","",""].obs;
  var simulation_reset = false.obs;

  // Dropdown Menu
  final List<String> modes = ['Live Control', 'Simulation'];
  final List<String> XYZmodes = ['X', 'Y', 'Z'];
  var programList = <String>['Sorting'].obs;
  //final List<String> action = ['', 'Go Point', 'End-Effector On', 'End-Effector Off', 'Delay'];

  void updateMode(String? newValue) {
    selectedMode.value = newValue!;
  }

  void updateProgram(String? newValue) {
    selectedProgram.value = newValue!;
  }

  void updateXYZMode(String? newValue) {
    selectedXYZMode.value = newValue!;
  }

  void cartesianExecutionMode(String? control) {
    if(control == "On") {
      cartesianExecution.value = "On";
    }
    else {
      cartesianExecution.value = "Off";
    }
  }

  void keepIncreaseAngle(int id, String control) {
    if(control == "joint") {
      for(int i=0; i<6; i++) {
        if(i == id) {
          act_joint[i] = "+";
        }
      }
    }
    if(control == "cartesian") {
      for(int i=0; i<3; i++) {
        if(i == id) {
          act_pos[i] = "+";
        }
      }
    }
    /* 
    incrementAngle(id, control);
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if(selectedMode == 'Simulation') {
        for(int i = 0; i<6; i++) {
          if(jointAngle[i] < 250.0 && i == id && control == "joint") {
            jointAngle[i] += 1.0;
          }
          if(cartesianValue[i] < 1000.0 && i == id && control == "cartesian") {
            cartesianValue[i] += 1.0;
          }
        }
      }
      else {
        for(int i=0; i<6; i++) {
          if(i == id) {
            act_joint[i] = "+";
          }
        }
      }
    });*/
  }

  void keepDecreaseAngle(int id, String control) {
    if(control == "joint") {
      for(int i=0; i<6; i++ ) {
        if(i == id) {
          act_joint[i] = "-";
        }
      }
    }
    if(control == "cartesian") {
      for(int i=0; i<3; i++) {
        if(i == id) {
          act_pos[i] = "-";
        }
      }
    }
      
    /* 
    decrementAngle(id,control);
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if(selectedMode == 'Simulation') {
        for(int i = 0; i<6; i++) {
          if(jointAngle[i] > 0.0 && i == id && control == "joint") {
            jointAngle[i] -= 1.0;
          }
          if(cartesianValue[i] > 0.0 && i == id && control == "cartesian") {
            cartesianValue[i] -= 1.0;
          }
        }
      }
      else {
        for(int i=0; i<6; i++ ) {
          if(i == id) {
            act_joint[i] = "-";
          }
        }
      }
    });*/
  }

  void decrementAngle(int id, String control) {
    if(selectedMode == 'Simulation') {
      for(int i = 0; i<6; i++) {
        if(jointAngle[i] > 0.0 && i == id && control == "joint") {
          jointAngle[i] -= 1.0;
        }
        if(cartesianValue[i] > 0.0 && i == id && control == "cartesian") {
          cartesianValue[i] -= 1.0;
        }
      }
    }
    else {
        for(int i=0; i<6; i++) {
          if(i == id) {
            //act_joint[i] = "-";
          }
        }
      }
  }

  void incrementAngle(int id, String control) {
    if(selectedMode == 'Simulation'){
      for(int i = 0; i<6; i++) {
        if(jointAngle[i] < 250.0 && i == id && control == "joint") {
          jointAngle[i] += 1.0;
        }
        if(cartesianValue[i] < 1000.0 && i == id && control == "cartesian") {
          cartesianValue[i] += 1.0;
        }
      }
    }
    else {
        for(int i=0; i<6; i++) {
          if(i == id) {
            //act_joint[i] = "+";
          }
        }
      }
  }

  void stopAngleTimer() {
    _timer?.cancel();
    for(int i=0; i<6; i++) {
      act_joint[i] = "";
    }
    for(int i=0; i<3; i++) {
      act_pos[i] = "";
    }
  }

  void resetJointCartesianValue(String action) {
    if(action == "True") {
      simulation_reset.value = true;
    }
    if(action == "False") {
      simulation_reset.value = false;
    }
  }

  void switchControlPanel() {
    switchControl.value = !switchControl.value;
  }

  void switchStopProgram(String mode) {
    if(mode == "Live Control") {
      live_playProgram.value = "Program Stop";
    }
    if(mode == "Simulation") {
      simulation_playProgram.value = "Program Stop";
    }
  }

  void switchPlayProgram(String mode) {
    if(mode == "Live Control") {
      live_playProgram.value = "Program Running";
    }
    if(mode == "Simulation") {
      simulation_playProgram.value = "Program Running";
    }
    
  }

  void switchCompletedProgram(String mode) {
    if(mode == "Live Control") {
      live_playProgram.value = "Program Completed";
    }
    if(mode == "Simulation") {
      simulation_playProgram.value = "Program Completed";
      print("Just Checking: ${simulation_playProgram.value}");
    }
  }
  // ---------------------------------------------------------------------------------------
  // For Simulation
  var controlSequence = <Map<String, dynamic>>[].obs;
  var pointList = <Map<String, dynamic>>[].obs;
  final List<String> robotActions = ['Move', 'End-Effector On', 'End-Effector Off', 'Delay', 'Loop'];

  var points = <String>['Init'].obs;

  void addAction(String action, {String? point, String? delay}) {
    controlSequence.add({
      'action': action,
      'point': point,
      'delay': delay
    });
  }

  void addPointList(String action, String j1, String j2, String j3, String j4, String j5, String j6) {
    pointList.add({
      'name': action,
      'joint1': j1,
      'joint2': j2,
      'joint3': j3,
      'joint4': j4,
      'joint5': j5,
      'joint6': j6,
    });
  }

  void deleteAction(int index) {
    controlSequence.removeAt(index);
  }

  void reorderAction(int oldIndex, int newIndex) {
    var item = controlSequence.removeAt(oldIndex);
    //print("This the item to check: ${item}");
    controlSequence.insert(newIndex, item);
  }

  void addPoint(String point) {
    points.add(point);
  }

  void defaultSetting() {
    addPointList("init", "130", "130", "130", "130", "130", "130");
    addPoint("init");
  }

  void resetProgramEditor() {
    controlSequence.clear();
    pointList.clear();
    points.clear();
    defaultSetting();
  }
}