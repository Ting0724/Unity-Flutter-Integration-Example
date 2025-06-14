import 'dart:convert';

import 'package:digittwinsystem/api/api_communication.dart';
import 'package:digittwinsystem/controller/robot_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RobotSimulation extends StatelessWidget {
  final RobotController _controller = Get.put(RobotController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 560,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        border: Border.all(width: 2, color: Colors.blueGrey), 
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.blueGrey[800], 
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Program Editor',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, 
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ListView 
          Obx(() {
            _controller.controlSequence.length;
            return Expanded(
              child: GetBuilder<RobotController>(
                builder: (controller) {
                  return ListView.builder(
                    itemCount: controller.controlSequence.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.blueGrey[700], // Card background color
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: ListTile(
                          leading: Text('${index + 1}', style: TextStyle(color: Colors.white)),
                          title: Text(controller.controlSequence[index]['action'], style: TextStyle(color: Colors.white)),
                          subtitle: controller.controlSequence[index]['point'] != null
                                    ? Text('Point: ${controller.controlSequence[index]['point']}', style: TextStyle(color: Colors.white70))
                                    : controller.controlSequence[index]['delay'] != null
                                        ? Text('Second: ${controller.controlSequence[index]['delay']}s', style: TextStyle(color: Colors.white70))
                                        : null,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red[500]),
                                onPressed: () {
                                  controller.deleteAction(index);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_upward, color: Colors.white),
                                onPressed: index > 0 ? () {
                                  controller.reorderAction(index, index - 1);
                                } : null,
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_downward, color: Colors.white),
                                onPressed: index < controller.controlSequence.length - 1 ? () {
                                  controller.reorderAction(index, index + 1);
                                } : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[600], 
                    foregroundColor: Colors.white, 
                  ),
                  onPressed: () {
                    _showActionDialog(context);
                  },
                  child: Text('Add'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[600], 
                    foregroundColor: Colors.white, 
                  ),
                  onPressed: () {
                    _showSaveDialog(context);
                  },
                  child: Text('Save'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[600], 
                    foregroundColor: Colors.white, 
                  ),
                  onPressed: () {
                    _controller.resetProgramEditor();
                  },
                  child: Text('Discard'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showActionDialog(BuildContext context) {
  String selectedAction = 'Move'; 
  String selectedPoint = _controller.points.isNotEmpty ? _controller.points[0] : '';
  String selectedDelay = "0";

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        alignment: Alignment.centerLeft, // Position the dialog to the left
        insetPadding: EdgeInsets.only(left: 190),
        child: IntrinsicHeight(
          child: IntrinsicWidth( // Ensures the dialog takes up minimum width
            child: StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: Colors.white, 
                  title: Text('Select Action', style: TextStyle(color: Colors.black)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min, // Ensures the content takes up minimum height
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min, // Ensures the row takes up minimum width
                        children: [
                          DropdownButton<String>(
                            value: selectedAction,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedAction = newValue!;
                              });
                            },
                            items: _controller.robotActions.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: TextStyle(color: Colors.black)),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 16),
                          if (selectedAction == 'Move') 
                            Row(
                              mainAxisSize: MainAxisSize.min, // Ensures the row takes up minimum width
                              children: [
                                Obx(() => DropdownButton<String>(
                                  value: selectedPoint,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedPoint = newValue!;
                                    });
                                  },
                                  items: _controller.points.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, style: TextStyle(color: Colors.black)),
                                    );
                                  }).toList(),
                                )),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueGrey[600], 
                                    foregroundColor: Colors.white, 
                                  ),
                                  onPressed: () {
                                    _showAddPointDialog(context);
                                  },
                                  child: Text('Add New Point'),
                                ),
                              ],
                            ),
                        ],
                      ),
                      if (selectedAction == 'Delay')
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Delay Duration (seconds)',
                            hintText: 'Seconds',
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) {
                            setState(() {
                              selectedDelay = value ?? "0.0";
                            });
                          },
                        ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[600], 
                        foregroundColor: Colors.white, 
                      ),
                      onPressed: () {
                        Navigator.pop(context); 
                      },
                      child: Text('Cancel', style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[600], 
                        foregroundColor: Colors.white, 
                      ),
                      onPressed: () {
                        _controller.addAction(selectedAction, point: selectedAction == 'Move' ? selectedPoint : null, delay: selectedAction == 'Delay' ? selectedDelay : null);
                        Navigator.pop(context); 
                      },
                      child: Text('Add', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

  // Function to show the add point dialog
  void _showAddPointDialog(BuildContext context) {
    TextEditingController pointController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          alignment: Alignment.centerLeft, // Position the dialog to the left
          insetPadding: EdgeInsets.only(left: 190),
          child: IntrinsicHeight(
            child: IntrinsicWidth(
              child: AlertDialog(
                backgroundColor: Colors.white,
                title: Text('Add New Point', style: TextStyle(color: Colors.black)),
                content: TextField(
                  controller: pointController,
                  decoration: InputDecoration(
                    labelText: 'Point Name',
                    hintText: 'Point Name',
                    //labelStyle: TextStyle(color: Colors.blueGrey),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[600], 
                      foregroundColor: Colors.white, 
                    ),
                    onPressed: () {
                      Navigator.pop(context); 
                    },
                    child: Text('Cancel', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[600], 
                      foregroundColor: Colors.white, 
                    ),
                    onPressed: () {
                    bool isDuplicate = _controller.pointList.any((point) => point['name'] == pointController.text);
              
                    if (!isDuplicate) {
                      _controller.addPoint(pointController.text);
                      _controller.addPointList(
                        pointController.text,
                        _controller.jointAngle[0].toString(),
                        _controller.jointAngle[1].toString(),
                        _controller.jointAngle[2].toString(),
                        _controller.jointAngle[3].toString(),
                        _controller.jointAngle[4].toString(),
                        _controller.jointAngle[5].toString(),
                      );
                      Navigator.pop(context);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            alignment: Alignment.centerLeft, // Position the dialog to the left
                            insetPadding: EdgeInsets.only(left: 190),
                            child: IntrinsicHeight(
                              child: IntrinsicWidth(
                                child: AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0), ),// Rounded corners
                                  backgroundColor: Colors.orange[50], // Light orange background
                                  title: Row(
                                    children: [
                                      Icon(
                                        Icons.warning, // Warning icon
                                        color: Colors.orange[800], // Orange color for the icon
                                        size: 30,
                                      ),
                                      SizedBox(width: 10), // Spacing between icon and text
                                      Text(
                                        'Duplicate Point',
                                        style: TextStyle(
                                          fontSize: 22, // Larger font size
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange[800], // Orange color for the title
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: Text(
                                    'Point "${pointController.text}" already exists!',
                                    style: TextStyle(
                                      fontSize: 18, // Larger font size
                                      color: Colors.black87,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Close the dialog
                                      },
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                          fontSize: 18, // Larger font size
                                          color: Colors.orange[800], // Orange color for the button
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                    child: Text('Add', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSaveDialog(BuildContext context) {
    TextEditingController saveProgramController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          alignment: Alignment.centerLeft, // Position the dialog to the left
          insetPadding: EdgeInsets.only(left: 190),
          child: IntrinsicHeight(
            child: IntrinsicWidth(
              child: AlertDialog(
                backgroundColor: Colors.white, // Dialog background color
                title: Text('Save Program', style: TextStyle(color: Colors.black)),
                content: TextField(
                  controller: saveProgramController,
                  decoration: InputDecoration(
                    labelText: 'Program Name',
                    hintText: 'Program Name',
                    //labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[600], 
                      foregroundColor: Colors.white, 
                    ),
                    onPressed: () {
                      Navigator.pop(context);  
                    },
                    child: Text('Cancel', style: TextStyle(color: Colors.white)),
                  ),
              
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[600], 
                      foregroundColor: Colors.white, 
                    ),
                    onPressed: () async {
                      if(saveProgramController.text != "") {
                        //print("This is the ${saveProgramController.text}: ${_controller.controlSequence}");
                        //print("This is the point list: ${_controller.pointList}");
                        final combinedData = combineData(_controller.controlSequence, _controller.pointList);
                        final jsonData = jsonEncode(combinedData);
                        ServiceAPI.saveProgramFile(saveProgramController.text, jsonData);
                        //print("This is the program file: ${combinedData}");
                        Navigator.pop(context); 
                        _controller.programList.value = await ServiceAPI.getProgramList();
                      } 
                    },
                    child: Text('Save', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> combineData(List<Map<String, dynamic>> program_content, List<Map<String, dynamic>> pointList) {
    //print("This is program: ${program_content}");
    //print("This is point list: ${pointList}");

    return program_content.map((content) {
      // Initialize pointData as null
      Map<String, dynamic> pointData = {};

      // Check if the point exists in the program_content
      if (content["point"] != null) {
        // Convert both the point and name to lowercase for case-insensitive matching
        final pointName = content["point"].toString().toLowerCase();

        // Find the corresponding point data in the pointList
        pointData = pointList.firstWhere(
          (pointItem) => pointItem["name"].toString().toLowerCase() == pointName,
          orElse: () => {},
        );

        // Remove the "name" key from the point data
        //pointData.remove("name");

        // Debug: Print the point being processed and the matched point data
        //print("Processing point: ${content["point"]}");
        //print("Matched point data: ${pointData}");
      }

      // Combine the data
      return {
        "action": content["action"],
        "point": pointData.isNotEmpty ? pointData : null,
        "delay": content["delay"],
      };
    }).toList();
  }
}