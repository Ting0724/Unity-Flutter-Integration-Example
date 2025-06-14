import 'package:digittwinsystem/constant.dart';
import 'package:digittwinsystem/controller/globalvar.dart';
import 'package:digittwinsystem/screen/result_data/latency_graph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OEEMonitoringPage extends StatefulWidget {
  const OEEMonitoringPage({super.key});

  @override
  State<OEEMonitoringPage> createState() => _OEEMonitoringPageState();
}

class _OEEMonitoringPageState extends State<OEEMonitoringPage> {
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
                  'Data Analysis & Result',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )
                ),
              ],
            ),
          ),
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BoxFruitCount("Apple", "1", globalVariable.box_fruit_count[0][1].toString(), globalVariable.box_fruit_count[5][1].toString()),
              SizedBox(width: 15,),
              BoxFruitCount("Banana", "2", globalVariable.box_fruit_count[1][1].toString(), globalVariable.box_fruit_count[6][1].toString()),
              SizedBox(width: 15,),
              BoxFruitCount("Guava", "3", globalVariable.box_fruit_count[2][1].toString(), globalVariable.box_fruit_count[7][1].toString()),
              SizedBox(width: 15,),
              BoxFruitCount("Lime", "4", globalVariable.box_fruit_count[3][1].toString(), globalVariable.box_fruit_count[8][1].toString()),
              SizedBox(width: 15,),
              BoxFruitCount("Reject", "", "", globalVariable.box_fruit_count[4][1].toString()),
            ],
          )),
          SizedBox(height: 10),
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LatencyValue("Serial Latency (s)", "Serial123", double.parse(globalVariable.latency_graph[0][2]).toStringAsFixed(4), "Serial456", double.parse(globalVariable.latency_graph[0][4]).toStringAsFixed(3)),
              SizedBox(width: 15,),
              LatencyValue("TCP Latency (s)", "", "", "TCP/IP", double.parse(globalVariable.latency_graph[0][4]).toStringAsFixed(4)),
              SizedBox(width: 15,),
              LatencyValue("Websocket Latency (s)", "", "", "Websocket", double.parse(globalVariable.latency_graph[0][5]).toStringAsFixed(4)),
            ],
          )),
        ],
      ),
    );
  }

  Widget LatencyValue(String name, String latency1, String latency1value, String latency2, String latency2value) {
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
                name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 5),
            ComLatency(250.0, latency1, latency1value, latency2, latency2value),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget ComLatency(double size, String latency1, String latency1value, String latency2, String latency2value) {
    if(latency1 != "" && latency1value != "") {
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
                    SizedBox(width: 10),
                    Text(
                      "${latency1}: ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        border: Border.all(color: Colors.blueAccent, width: 2),
                      ),
                      child: Text(
                        latency1value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                    SizedBox(width: 10),
                    Text(
                      "${latency2}: ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        border: Border.all(color: Colors.blueAccent, width: 2),
                      ),
                      child: Text(
                        latency2value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    else {
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
                    SizedBox(width: 10),
                    Text(
                      "${latency2}: ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        border: Border.all(color: Colors.blueAccent, width: 2),
                      ),
                      child: Text(
                        latency2value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget BoxFruitCount(String name, String box, String count, String total_count) {
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
                name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 5),
            CountingValue(250.0, box, count, total_count),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget CountingValue(double size, String box, String count, String total_count) {
    if(box != "" && count != "") {
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
                    SizedBox(width: 10),
                    Text(
                      "Box ${box}: ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        border: Border.all(color: Colors.blueAccent, width: 2),
                      ),
                      child: Text(
                        count,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                    SizedBox(width: 10),
                    Text(
                      "Total Count: ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        border: Border.all(color: Colors.blueAccent, width: 2),
                      ),
                      child: Text(
                        total_count,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    else {
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
                    SizedBox(width: 10),
                    Text(
                      "Total Reject: ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        border: Border.all(color: Colors.blueAccent, width: 2),
                      ),
                      child: Text(
                        total_count,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}