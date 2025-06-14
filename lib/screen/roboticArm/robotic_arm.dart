import 'package:digittwinsystem/constant.dart';
import 'package:digittwinsystem/controller/globalvar.dart';
import 'package:digittwinsystem/screen/roboticArm/digitaltwin_robotic_arm.dart';
import 'package:digittwinsystem/screen/roboticArm/robot_control_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoboticArmPage extends StatefulWidget {
  const RoboticArmPage({super.key});

  @override
  State<RoboticArmPage> createState() => _RoboticArmPageState();
}

class _RoboticArmPageState extends State<RoboticArmPage> {
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
                    'Digital Twin System',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Obx(() => Row(
              children: [
                Expanded(child: _robotJointTemVol("Joint 1", globalVariable.joint_temp_feedback[0].toString(), globalVariable.joint_vol_feedback[0].toString())),
                Expanded(child: _robotJointTemVol("Joint 2", globalVariable.joint_temp_feedback[1].toString(), globalVariable.joint_vol_feedback[1].toString())),
                Expanded(child: _robotJointTemVol("Joint 3", globalVariable.joint_temp_feedback[2].toString(), globalVariable.joint_vol_feedback[2].toString())),
                Expanded(child: _robotJointTemVol("Joint 4", globalVariable.joint_temp_feedback[3].toString(), globalVariable.joint_vol_feedback[3].toString())),
                Expanded(child: _robotJointTemVol("Joint 5", globalVariable.joint_temp_feedback[4].toString(), globalVariable.joint_vol_feedback[4].toString())),
                Expanded(child: _robotJointTemVol("Joint 6", globalVariable.joint_temp_feedback[5].toString(), globalVariable.joint_vol_feedback[5].toString())),
                SizedBox(width: 20,)
              ],
            )), 
            SizedBox(height: 10,),
            Row(
              children: [
                SizedBox(width: 14,),
                Expanded(flex: 4, child: RobotControlPanel()),
                //Expanded(flex: 7, child: Container()),
                Expanded(flex: 7, child: DigitalTwinRoboticArm()),
                SizedBox(width: 14,)
              ],
            )
          ],
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
          height: 80,
          child: Column(
            children: [
              // Title Bar
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Servo " + name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
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