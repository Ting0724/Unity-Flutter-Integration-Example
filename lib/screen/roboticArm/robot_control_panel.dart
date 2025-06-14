import 'dart:convert';
import 'dart:typed_data';

import 'package:digittwinsystem/api/api_communication.dart';
import 'package:digittwinsystem/controller/globalvar.dart';
import 'package:digittwinsystem/controller/robot_controller.dart';
import 'package:digittwinsystem/screen/roboticArm/robot_simulation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RobotControlPanel extends StatefulWidget {
  const RobotControlPanel({super.key});

  @override
  State<RobotControlPanel> createState() => _RobotControlPanelState();
}

class _RobotControlPanelState extends State<RobotControlPanel> {
  final RobotController robotController = Get.put(RobotController());
  late Future<List<String>> programListFuture; // Store Future result
  List<TextEditingController> textControllers = List.generate(6, (index) => TextEditingController());
  @override
  void initState() {
    super.initState();
    programListFuture = ServiceAPI.getProgramList(); // Call function before build
    for (int i = 0; i < 6; i++) {
      textControllers[i].text = robotController.act_pos[i].toString();
    }
  }

  @override
  void dispose() {
    // Dispose of each controller when the page is destroyed
    for (var controller in textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: programListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),)); // Show loading indicator
        } else if (snapshot.hasError) {
          return Center(child: Text("Error loading data"));
        } else {
          robotController.programList.value = snapshot.data ?? ['Sorting'];
          return buildControlPanel(context); // Build UI with data
          //return Container(); 
        }
      },
    );
  }

  Widget buildControlPanel (BuildContext context) {
    return Card(
      elevation: 6, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), 
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  child: Row(
                    children: [
                      Text(
                        "Mode: ",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 10,),
                      Obx((){
                        return DropdownButton<String>(
                          value: robotController.selectedMode.value,
                          onChanged: (String? newValue) {
                            robotController.updateMode(newValue);
                          },
                          items: robotController.modes.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),
                              ),
                            );
                          }).toList(),
                        );
                      })
                    ],
                  ),
                ),
                SizedBox(width: 10,),
                SizedBox(
                  child: Row(
                    children: [
                      Text(
                        "Program: ",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 10,),
                      Obx((){
                        return DropdownButton<String>(
                          value: robotController.selectedProgram.value,
                          onChanged: (String? newValue) {
                            robotController.updateProgram(newValue);
                          },
                          items: robotController.programList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),
                              ),
                            );
                          }).toList(),
                        );
                      })
                    ],
                  ),
                ),
                SizedBox(width: 15,),
                SizedBox(
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          print("Play button press");
                          robotController.switchPlayProgram(robotController.selectedMode.value);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, 
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        ),
                        child: Icon(Icons.play_arrow, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          print("Stop button press");
                          robotController.switchStopProgram(robotController.selectedMode.value);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, 
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        ),
                        child: Icon(Icons.stop, color: Colors.white),
                      ),
                    ],
                  ),
                )
      
              ],
            ),
            SizedBox(height: 15),
            DropDownModeSelection(context)
          ],
        ),
      ),
    );
  }

  Widget DropDownModeSelection(BuildContext context) {
    return Obx((){
      //robotController.clearSequence();
      if (robotController.selectedMode.value == "Live Control") {
        return LiveControlMode(context);
      }
      else if (robotController.selectedMode.value == "Simulation") {
        return SimulationMode();
      }
      else {
        return Container();
      }
    });
  }

  Widget SimulationMode () {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Row(
                      children: [
                        SizedBox(width: 5,),
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: 40,
                            child: GestureDetector(
                              onTapDown: (_) => robotController.resetJointCartesianValue("True"),
                              onTapUp: (_) => robotController.resetJointCartesianValue("False"),
                              onTapCancel: () => robotController.resetJointCartesianValue("False"),
                              child: ElevatedButton(
                                onPressed: () {
                                  print("Initializing");
                                  //robotController.resetJointCartesianValue();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade600, 
                                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                ),
                                child: Icon(Icons.refresh_rounded, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                print("Switching Control Mode");
                                robotController.switchControlPanel();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600, 
                                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                              ),
                              child: Icon(Icons.swap_vert_rounded, color: Colors.white),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Obx(() {
                            if(robotController.switchControl.value == true) {
                              return Text(
                                "Joint",
                                style: TextStyle(
                                  fontSize: 20, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              );
                            }
                            else {
                              return Text(
                                "Cartesian",
                                style: TextStyle(
                                  fontSize: 20, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              );
                            }
                          })
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    if(robotController.switchControl.value == true) {
                      return JointControlPanel("Simulation");
                    }
                    else {
                      return CartesianControlPanel("Simulation");
                    }
                  })
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: RobotSimulation()
          )
        ],
      ),
    );
  }

  Widget LiveControlMode (BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: JointControlPanel("Live"),
          ),
          Expanded(
            flex: 4,
            child: CartesianControlPanel("Live")
          ),
          Expanded(
            flex: 3,
            child: ControlExecution(context)
          )
        ],
      ),
    );
  }

  Widget ControlExecution (BuildContext context) {
    return Container(
      child: Column(
        children: [
          ViewCamButton(context),
          CartesianExecutionControl(),
          SwitchControlButton("End-Effector", robotController.end_effector_control), 
          SwitchControlButton("Fruit Conveyor", robotController.fruit_conveyor_control),
          SwitchControlButton("Box Conveyor", robotController.box_conveyor_control),
        ],
      ),
    );
  }

  Widget SwitchControlButton(String name, RxBool variable) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3.0),
            child: Container(
              width: 150,
              padding: EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Switch(
                    value: variable.value,
                    onChanged: (bool value) {
                      setState(() {
                        variable.value = value;
                      });
                      //widget.onEndEffectorToggle(value);
                    },
                    activeColor: Colors.teal,
                    inactiveTrackColor: Colors.redAccent,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget ViewCamButton(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3.0),
            child: Container(
              width: 220,
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => showCamViewDialog(context),
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [Colors.orange, Colors.orange.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepOrangeAccent.withOpacity(0.5),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Cam View",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showCamViewDialog(BuildContext context) {
    final GlobalVariable globalVariable = Get.put(GlobalVariable());
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.centerLeft, // Moves the dialog to the left
          child: FractionallySizedBox(
            widthFactor: 0.48, // 30% of the screen width
            child: Dialog(
              backgroundColor: Colors.black87,
              child: Container(
                padding: EdgeInsets.all(10),
                constraints: BoxConstraints(
                  maxWidth: 600, // Adjust width
                  maxHeight: 700, // Adjust height
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Detected Image",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Obx(() {
                      if(globalVariable.yolo_image.value != "") {
                        return FutureBuilder<Uint8List>(
                          future: Future(() {
                            return base64Decode(globalVariable.yolo_image.value);
                          }),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError || snapshot.data == null) {
                              return Text("Error loading image", style: TextStyle(color: Colors.red));
                            }
                            return Image.memory(
                              snapshot.data!,
                              width: 500, // Adjust image size
                              height: 300,
                              fit: BoxFit.contain,
                            );
                          },
                        );
                      }
                      else {
                        return Text("Error loading image", style: TextStyle(color: Colors.red));
                      }
                    }),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Close", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Widget CartesianExecutionControl() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3.0),
            child: Container(
              width: 220,
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              child: Column(
                children: [
                  Container(
                    width: 150,
                    padding: EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade800,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "O. Mode: ",
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(width: 5),
                        Obx((){
                          return DropdownButton<String>(
                            value: robotController.selectedXYZMode.value,
                            onChanged: (String? newValue) {
                              robotController.updateXYZMode(newValue);
                            },
                            items: robotController.XYZmodes.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              );
                            }).toList(),
                          );
                        })
                      ],
                    )
                  ),
                  SizedBox(height: 8),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTapDown: (_) => robotController.cartesianExecutionMode("On"),
                      onTapUp: (_) => robotController.cartesianExecutionMode("Off"),
                      onTapCancel: () => robotController.cartesianExecutionMode("Off"),
                      child: Container(
                        width: 80,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [Colors.teal, Colors.teal],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.greenAccent.withOpacity(0.5),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Execute',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget JointControlPanel (String mode) {
    if (mode == "Live") {
      return Container(
        child: Column(
          children: [
            Text(
              "Joint Control",
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            JointControlButton("Joint 1", 0, "°", "joint"),
            JointControlButton("Joint 2", 1, "°", "joint"),
            JointControlButton("Joint 3", 2, "°", "joint"),
            JointControlButton("Joint 4", 3, "°", "joint"),
            JointControlButton("Joint 5", 4, "°", "joint"),
            JointControlButton("Joint 6", 5, "°", "joint"),
          ],
        ),
      );
    }
    else {
      return Container(
        child: Column(
          children: [
            JointControlButton("Joint 1", 0, "°", "joint"),
            JointControlButton("Joint 2", 1, "°", "joint"),
            JointControlButton("Joint 3", 2, "°", "joint"),
            JointControlButton("Joint 4", 3, "°", "joint"),
            JointControlButton("Joint 5", 4, "°", "joint"),
            JointControlButton("Joint 6", 5, "°", "joint"),
          ],
        ),
      );
    }
  }

  Widget CartesianControlPanel (String mode) {
    if(mode == "Live") {
      return Container(
        child: Column(
          children: [
            Text(
              "Cartesian Control",
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            CartesianControlFieldText("X", 0, "cm", "cartesian", "X cm"),
            CartesianControlFieldText("Y", 1, "cm", "cartesian", "Y cm"),
            CartesianControlFieldText("Z", 2, "cm", "cartesian", "Z cm"),
            CartesianControlFieldText("Rx", 3, "°", "cartesian", "a"),
            CartesianControlFieldText("Ry", 4, "°", "cartesian", "o"),
            CartesianControlFieldText("Rz", 5, "°", "cartesian", "n"),
          ],
        ),
      );
    }
    else {
      return Container(
        child: Column(
          children: [
            CartesianControlButton("X", 0, "cm", "cartesian"),
            CartesianControlButton("Y", 1, "cm", "cartesian"),
            CartesianControlButton("Z", 2, "cm", "cartesian"),
            CartesianDisplay("Rx", 3, "°", "cartesian"),
            CartesianDisplay("Ry", 4, "°", "cartesian"),
            CartesianDisplay("Rz", 5, "°", "cartesian")
          ],
        ),
      );
    }
  }

  Widget JointControlButton(String joint, int number, String unit, String method) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3.0),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTapDown: (_) => robotController.keepDecreaseAngle(number, method),
              onTapUp: (_) => robotController.stopAngleTimer(),
              onTapCancel: () => robotController.stopAngleTimer(),
              child: Container(
                width: 40, height: 40, // ⬅️ Smaller button size
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.redAccent, Colors.deepOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.5),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.remove, size: 22, color: Colors.white),
                  onPressed: () {
                    robotController.decrementAngle(number, method);
                  },
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  width: 90, // ⬅️ Reduced width
                  padding: EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    joint,
                    style: TextStyle(
                      fontSize: 16, // ⬅️ Smaller font
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 90, // ⬅️ Smaller display
                  padding: EdgeInsets.symmetric(vertical: 2),
                  margin: EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.tealAccent, width: 1.5),
                  ),
                  child: Obx(() {
                    return Text(
                      ' ${robotController.jointAngle[number].toStringAsFixed(1)}' + unit,
                      style: TextStyle(
                        fontSize: 18, // ⬅️ Smaller font
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }),
                ),
              ],
            ),
            GestureDetector(
              onTapDown: (_) => robotController.keepIncreaseAngle(number, method),
              onTapUp: (_) => robotController.stopAngleTimer(),
              onTapCancel: () => robotController.stopAngleTimer(),
              child: Container(
                width: 40, height: 40, // ⬅️ Smaller button size
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.greenAccent, Colors.teal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.5),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.add, size: 22, color: Colors.white),
                  onPressed: () {
                    robotController.incrementAngle(number, method);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget CartesianControlFieldText(String joint, int number, String unit, String method, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3.0),
      child: Container(
        height: 85.5,
        width: 180,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  width: 75, 
                  padding: EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    joint,
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 75, 
                  padding: EdgeInsets.symmetric(vertical: 2),
                  margin: EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.tealAccent, width: 1.5),
                  ),
                  child: Obx(() {
                    return Text(
                      '${robotController.cartesianValue[number].toStringAsFixed(1)} $unit',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }),
                ),
              ],
            ),
            SizedBox(width: 5),
            SizedBox(
              width: 80,
              child: TextField(
                controller: textControllers[number], // Unique controller for each servo
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade800, 
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.cyanAccent, width: 1.5),
                  ),
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    double? newValue = double.tryParse(value);
                    if (newValue != null) {
                      robotController.act_pos[number] = newValue.toString();
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
  /*
  Widget CartesianControlFieldText(String joint, int number, String unit, String method, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3.0),
      child: Container(
        height: 85.5,
        width: 180,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  width: 75, // ⬅️ Reduced width
                  padding: EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    joint,
                    style: TextStyle(
                      fontSize: 16, // ⬅️ Smaller font
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 75, // ⬅️ Smaller display
                  padding: EdgeInsets.symmetric(vertical: 2),
                  margin: EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.tealAccent, width: 1.5),
                  ),
                  child: Obx(() {
                    return Text(
                      ' ${robotController.cartesianValue[number].toStringAsFixed(1)}' + unit,
                      style: TextStyle(
                        fontSize: 16, // ⬅️ Smaller font
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }),
                ),
              ],
            ),
            SizedBox(width: 5),
            // TextField for user input
            SizedBox(
              width: 80,
              child: TextField(
                controller: TextEditingController(
                  text: robotController.act_pos[number].toString(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white, // White text for contrast
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade800, // Dark grey but visible on black
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.cyanAccent, width: 1.5), // Matching border
                  ),
                  hintText: hint,
                  hintStyle: TextStyle(color: Colors.grey.shade400), // Subtle hint text
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    double? newValue = double.tryParse(value);
                    if (newValue != null) {
                      robotController.act_pos[number] = newValue.toString();
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }*/

  Widget CartesianDisplay(String joint, int number, String unit, String method) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3.0),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  width: 90, // ⬅️ Reduced width
                  padding: EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    joint,
                    style: TextStyle(
                      fontSize: 16, // ⬅️ Smaller font
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 90, // ⬅️ Smaller display
                  padding: EdgeInsets.symmetric(vertical: 2),
                  margin: EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.tealAccent, width: 1.5),
                  ),
                  child: Obx(() {
                    return Text(
                      ' ${robotController.cartesianValue[number].toStringAsFixed(1)}' + unit,
                      style: TextStyle(
                        fontSize: 18, // ⬅️ Smaller font
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget CartesianControlButton(String joint, int number, String unit, String method) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3.0),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTapDown: (_) => robotController.keepDecreaseAngle(number, method),
              onTapUp: (_) => robotController.stopAngleTimer(),
              onTapCancel: () => robotController.stopAngleTimer(),
              child: Container(
                width: 40, height: 40, // ⬅️ Smaller button size
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.redAccent, Colors.deepOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.5),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.remove, size: 22, color: Colors.white),
                  onPressed: () {
                    //robotController.decrementAngle(number, method);
                  },
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  width: 90, // ⬅️ Reduced width
                  padding: EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    joint,
                    style: TextStyle(
                      fontSize: 16, // ⬅️ Smaller font
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 90, // ⬅️ Smaller display
                  padding: EdgeInsets.symmetric(vertical: 2),
                  margin: EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.tealAccent, width: 1.5),
                  ),
                  child: Obx(() {
                    return Text(
                      ' ${robotController.cartesianValue[number].toStringAsFixed(1)}' + unit,
                      style: TextStyle(
                        fontSize: 18, // ⬅️ Smaller font
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }),
                ),
              ],
            ),
            GestureDetector(
              onTapDown: (_) => robotController.keepIncreaseAngle(number, method),
              onTapUp: (_) => robotController.stopAngleTimer(),
              onTapCancel: () => robotController.stopAngleTimer(),
              child: Container(
                width: 40, height: 40, // ⬅️ Smaller button size
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.greenAccent, Colors.teal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.5),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.add, size: 22, color: Colors.white),
                  onPressed: () {
                    //robotController.incrementAngle(number, method);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



/* 
  Widget CartesianDisplay(String joint, int number, String unit, String method) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3.0),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  width: 90, // ⬅️ Reduced width
                  padding: EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    joint,
                    style: TextStyle(
                      fontSize: 16, // ⬅️ Smaller font
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 90, // ⬅️ Smaller display
                  padding: EdgeInsets.symmetric(vertical: 2),
                  margin: EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.tealAccent, width: 1.5),
                  ),
                  child: Obx(() {
                    return Text(
                      ' ${robotController.cartesianValue[number].toStringAsFixed(1)}' + unit,
                      style: TextStyle(
                        fontSize: 18, // ⬅️ Smaller font
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget CartesianControlButton(String joint, int number, String unit, String method) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3.0),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTapDown: (_) => robotController.keepDecreaseAngle(number, method),
              onTapUp: (_) => robotController.stopAngleTimer(),
              onTapCancel: () => robotController.stopAngleTimer(),
              child: Container(
                width: 40, height: 40, // ⬅️ Smaller button size
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.redAccent, Colors.deepOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.5),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.remove, size: 22, color: Colors.white),
                  onPressed: () {
                    //robotController.decrementAngle(number, method);
                  },
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  width: 90, // ⬅️ Reduced width
                  padding: EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade800,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    joint,
                    style: TextStyle(
                      fontSize: 16, // ⬅️ Smaller font
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 90, // ⬅️ Smaller display
                  padding: EdgeInsets.symmetric(vertical: 2),
                  margin: EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.tealAccent, width: 1.5),
                  ),
                  child: Obx(() {
                    return Text(
                      ' ${robotController.cartesianValue[number].toStringAsFixed(1)}' + unit,
                      style: TextStyle(
                        fontSize: 18, // ⬅️ Smaller font
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }),
                ),
              ],
            ),
            GestureDetector(
              onTapDown: (_) => robotController.keepIncreaseAngle(number, method),
              onTapUp: (_) => robotController.stopAngleTimer(),
              onTapCancel: () => robotController.stopAngleTimer(),
              child: Container(
                width: 40, height: 40, // ⬅️ Smaller button size
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.greenAccent, Colors.teal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.5),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.add, size: 22, color: Colors.white),
                  onPressed: () {
                    //robotController.incrementAngle(number, method);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  */

