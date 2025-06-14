import 'package:digittwinsystem/constant.dart';
import 'package:digittwinsystem/controller/globalvar.dart';
import 'package:digittwinsystem/controller/robot_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({super.key});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  final RobotController robotController = Get.put(RobotController());
  final GlobalVariable globalVariable = Get.put(GlobalVariable());
  @override
  Widget build(BuildContext context) {
    return Container(
        //color: const Color.fromARGB(255, 223, 220, 220),
        color: screenbackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  SizedBox(width: 10,),
                  Icon(
                    Icons.menu, 
                    size: 30,
                    color: Colors.white,
                  ),
                  SizedBox(width: 15,),
                  Text(
                    'Debug',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Group1_Indicator(),
                SizedBox(width: 30),
                Group2_Indicator(),
                SizedBox(width: 30),
                Group3_Indicator(),
                SizedBox(width: 30),
                Group4_Indicator()
              ],
            )
          ]
        )
    );
  }


  Widget Group4_Indicator() {
    return Card(
      elevation: 6, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), 
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Text(
                "Servo Motor Status",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Obx(() => Row(
              children: [
                JointControlButton("Joint 1", 0, "°", "joint"),
                Container(
                  width: 250,
                  child: _robotJointTemVol("Joint 1", globalVariable.joint_temp_feedback[0].toString(), globalVariable.joint_vol_feedback[0].toString())
                ),
              ]
            )),
            Obx(() => Row(
              children: [
                JointControlButton("Joint 2", 1, "°", "joint"),
                Container(
                  width: 250,
                  child: _robotJointTemVol("Joint 2", globalVariable.joint_temp_feedback[1].toString(), globalVariable.joint_vol_feedback[1].toString())
                ),
              ]
            )),
            Obx(() => Row(
              children: [
                JointControlButton("Joint 3", 2, "°", "joint"),
                Container(
                  width: 250,
                  child: _robotJointTemVol("Joint 3", globalVariable.joint_temp_feedback[2].toString(), globalVariable.joint_vol_feedback[2].toString())
                ),
              ]
            )),
            Obx(() => Row(
              children: [
                JointControlButton("Joint 4", 3, "°", "joint"),
                Container(
                  width: 250,
                  child: _robotJointTemVol("Joint 4", globalVariable.joint_temp_feedback[3].toString(), globalVariable.joint_vol_feedback[3].toString())
                ),
              ]
            )),
            Obx(() => Row(
              children: [
                JointControlButton("Joint 5", 4, "°", "joint"),
                Container(
                  width: 250,
                  child: _robotJointTemVol("Joint 5", globalVariable.joint_temp_feedback[4].toString(), globalVariable.joint_vol_feedback[4].toString())
                ),
              ]
            )),
            Obx(() => Row(
              children: [
                JointControlButton("Joint 6", 5, "°", "joint"),
                Container(
                  width: 250,
                  child: _robotJointTemVol("Joint 6", globalVariable.joint_temp_feedback[5].toString(), globalVariable.joint_vol_feedback[5].toString())
                ),
              ]
            )),
          ],
        ),
      ),
    );
  }


  Widget Group3_Indicator() {
    return Card(
      elevation: 6, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), 
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Text(
                "Actuator Status",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Obx(() => Indicator("Box Conveyor  ", globalVariable.sensor_actuator[0] == "On", 200.0)),
            SizedBox(height: 10),
            Obx(() => Indicator("Fruit Conveyor", globalVariable.sensor_actuator[1] == "On", 200.0)),
            SizedBox(height: 10),
            Obx(() => Indicator("End - Effector", globalVariable.sensor_actuator[2] == "On", 200.0)),
          ],
        ),
      ),
    );
  }

  Widget Group2_Indicator() {
    return Card(
      elevation: 6, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), 
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Text(
                "Conveyor Sensor",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Obx(() => Indicator("IR Box Conveyor", globalVariable.sensor_conveyor[0] == "On", 320.0)),
            SizedBox(height: 10),
            Obx(() => Indicator_String("Laser Fruit Conveyor", globalVariable.sensor_conveyor[1], 320.0)),
          ],
        ),
      ),
    );
  }

  Widget Group1_Indicator() {
    return Card(
      elevation: 6, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), 
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Text(
                "Box Sensor",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Obx(() => Indicator("IR Box 1", globalVariable.ir_box[0] == "On", 150.0)),
            SizedBox(height: 10),
            Obx(() => Indicator("IR Box 2", globalVariable.ir_box[1] == "On", 150.0)),
            SizedBox(height: 10),
            Obx(() => Indicator("IR Box 3", globalVariable.ir_box[2] == "On", 150.0)),
            SizedBox(height: 10),
            Obx(() => Indicator("IR Box 4", globalVariable.ir_box[3] == "On", 150.0)),
          ],
        ),
      ),
    );
  }

  Widget Indicator_String(String name, String value, double width) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3.0),
            child: Container(
              width: width,
              padding: EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    " " + name + " :",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 90,
                    child: Text(
                      value + " mm",
                      style: TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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

  Widget Indicator(String name, bool variable, double size) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3.0),
            child: Container(
              width: size,
              padding: EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: variable ? Colors.green : Colors.red,
                      border: Border.all(color: Colors.white, width: 2),
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

  Widget JointControlButton(String joint, int number, String unit, String method) {
    return Padding(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 100, // ⬅️ Reduced width
              padding: EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                joint,
                style: TextStyle(
                  fontSize: 20, // ⬅️ Smaller font
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 100, // ⬅️ Smaller display
              padding: EdgeInsets.symmetric(vertical: 2),
              margin: EdgeInsets.only(top: 3),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.tealAccent, width: 1.5),
              ),
              child: Obx(() {
                return Text(
                  ' ${globalVariable.joint_feedback[number].toStringAsFixed(1)}' + unit,
                  style: TextStyle(
                    fontSize: 20, // ⬅️ Smaller font
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                  ),
                  textAlign: TextAlign.center,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _robotJointTemVol(String name, String temperature, String voltage) {
    Color titleBackgroundColor = Colors.blue.shade900;
    Color tempBackgroundColor = Colors.orange.shade600;
    Color volBackgroundColor = Colors.blue.shade600;
    double borderRadius = 12.0;
    //double borderWidth = 2.0;

    return Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [titleBackgroundColor, Colors.black],
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: SizedBox(
          height: 40,
          child: Column(
            children: [
              // Temperature and Voltage Row
              SizedBox(
                child: Row(
                  children: [
                    // Temperature
                    Expanded(
                      child: Container(
                        //width: 110,
                        decoration: BoxDecoration(
                          color: tempBackgroundColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(borderRadius),
                            topLeft: Radius.circular(borderRadius),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.thermostat,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                temperature + " °C",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Voltage
                    Expanded(
                      child: Container(
                        width: 95,
                        decoration: BoxDecoration(
                          color: volBackgroundColor,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(borderRadius),
                            topRight: Radius.circular(borderRadius),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bolt, // Voltage icon
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                voltage + " V",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}