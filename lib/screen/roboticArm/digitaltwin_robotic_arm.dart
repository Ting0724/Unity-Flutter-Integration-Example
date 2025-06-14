import 'package:digittwinsystem/controller/globalvar.dart';
import 'package:digittwinsystem/controller/robot_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:get/get.dart';

class DigitalTwinRoboticArm extends StatefulWidget {
  const DigitalTwinRoboticArm({super.key});

  @override
  State<DigitalTwinRoboticArm> createState() => _DigitalTwinRoboticArmState();
}

class _DigitalTwinRoboticArmState extends State<DigitalTwinRoboticArm> {
  final GlobalVariable globalVariable = Get.put(GlobalVariable());
  final RobotController robotController = Get.put(RobotController());
  UnityWidgetController? _unityWidgetController;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), 
      ),
      child: Container(
        height: 670,
        child: Padding(
        padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Obx(() => Icon(
                          globalVariable.connection_status.value == "Connected"
                              ? Icons.signal_cellular_4_bar_rounded
                              : Icons.signal_cellular_connected_no_internet_4_bar_rounded,
                          color: globalVariable.connection_status.value == "Connected"
                              ? Colors.green
                              : Colors.red,
                          size: 28,
                        )),
                        SizedBox(width: 8), 
                        // Status Text
                        Obx(() => Text(
                          globalVariable.connection_status.value,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: globalVariable.connection_status.value == "Connected"
                                ? Colors.green
                                : Colors.red,
                          ),
                        )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Obx(() => Text(
                        (robotController.selectedMode.value == "Live Control"
                            ? "Live Monitoring (" + robotController.live_playProgram.value + ")"
                            : robotController.selectedMode.value == "Simulation"
                                ? "Simulation (" + robotController.simulation_playProgram.value + ")"
                                : robotController.selectedMode.value == "Prediction"
                                    ? "Prediction"
                                    : ""),
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: (robotController.selectedMode.value == "Live Control" &&
                                  robotController.live_playProgram.value == "Program Running") ||
                                (robotController.selectedMode.value == "Simulation" &&
                                  robotController.simulation_playProgram.value == "Program Running")
                              ? const Color.fromARGB(255, 27, 138, 30) // Green if "Program Running"
                              : (robotController.selectedMode.value == "Live Control" &&
                                  robotController.live_playProgram.value == "Program Completed") ||
                                (robotController.selectedMode.value == "Simulation" &&
                                  robotController.simulation_playProgram.value == "Program Completed")
                                  ? Colors.yellow // Yellow if "Program Completed"
                                  : Colors.red, // Red otherwise
                        ),
                        textAlign: TextAlign.center,
                      )),
                    ),
                  ),
                  Expanded(
                    child: SizedBox()
                  ),
                  Container(
                    width: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        print("Camera View Initialization");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                        ),
                      ),
                      child: Icon(
                        Icons.remove_red_eye_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Container(
                height: 595,
                child: UnityWidget(
                  onUnityCreated: _onUnityCreated,
                  onUnityMessage: onUnityMessage,
                  onUnitySceneLoaded: onUnitySceneLoaded,
                  useAndroidViewSurface: false,
                  borderRadius: const BorderRadius.all(Radius.circular(70)),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  void onUnityMessage(message) {
    //print('Received message from unity: ${message.toString()}');
  }

  void onUnitySceneLoaded(SceneLoaded? scene) {
    if (scene != null) {
      print('Received scene loaded from unity: ${scene.name}');
      print('Received scene loaded from unity buildIndex: ${scene.buildIndex}');
    } else {
      print('Received scene loaded from unity: null');
    }
  }

  // Callback that connects the created controller to the unity controller
  void _onUnityCreated(controller) {
    controller.resume();
    _unityWidgetController = controller;
  }
}