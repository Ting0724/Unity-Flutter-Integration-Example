import 'package:digittwinsystem/constant.dart';
import 'package:flutter/material.dart';

class SortingSystemPage extends StatefulWidget {
  const SortingSystemPage({super.key});

  @override
  State<SortingSystemPage> createState() => _SortingSystemPageState();
}

class _SortingSystemPageState extends State<SortingSystemPage> {
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
                    'Digital Twin of Robotic Sorting System',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )
                  ),
                ],
              ),
            ),
            Text(
              'Robotic Sorting System Page Content',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
  }
}