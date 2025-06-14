import 'package:get/get.dart';

class GlobalVariable extends GetxController {
  static GlobalVariable instance = Get.find();
  var joint_feedback = [0.0,0.0,0.0,0.0,0.0,0.0].obs;
  var cartesian_feedback = [0.0,0.0,0.0,0.0,0.0,0.0].obs;
  var ir_box = ["Off","Off","Off","Off"].obs;
  var sensor_conveyor = ["Off",""].obs;
  var sensor_actuator = ["Off","Off","Off"].obs;
  var joint_temp_feedback = ["-","-","-","-","-","-"].obs;
  var joint_vol_feedback = ["-","-","-","-","-","-"].obs;
  var digitaltwinconnection = "Connecting".obs;
  var connection_status = "Disconnected".obs;
  var page = "".obs;
  var yolo_image = "".obs;
  var box_fruit_count = [].obs;
  var latency_graph = [].obs; 
  var serial_latency123 = 0.0.obs;
  var serial_latency456 = 0.0.obs;
  var tcp_latency = 0.0.obs;
  var websocket_latency = 0.0.obs;
}
