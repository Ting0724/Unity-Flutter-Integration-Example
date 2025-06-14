import 'package:digittwinsystem/constant.dart';
import 'package:digittwinsystem/controller/globalvar.dart';
import 'package:digittwinsystem/screen/login.dart';
import 'package:digittwinsystem/screen/roboticArm/robotic_arm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> navItems = [
    {
      'icon': MaterialCommunityIcons.robot_industrial, 
      'label': 'Digital Twin   ',
    },
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPageContent() {
    final GlobalVariable globalVariable = Get.put(GlobalVariable());
    switch (_selectedIndex) {
      case 0:
        globalVariable.page.value = "Robot";
        return const RoboticArmPage();
        //return Container();
      default:
        return Center(
          child: Text(
            'Error Content Not Found',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //color: const Color.fromARGB(255, 223, 220, 220),
        color: screenbackgroundColor,
        child: Row(
          children: [
            SideNavigationBar(
              navItems: navItems,
              onItemSelected: _onItemSelected,
              selectedIndex: _selectedIndex,
            ),
            Expanded(
              child: Container(
                //color: Colors.grey.shade100,
                child: _getPageContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SideNavigationBar extends StatelessWidget {
  final List<Map<String, dynamic>> navItems;
  final Function(int) onItemSelected;
  final int selectedIndex;

  const SideNavigationBar({
    Key? key,
    required this.navItems,
    required this.onItemSelected,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120, 
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade900, Colors.black],
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 50),
          Column(
            children: navItems
                .asMap()
                .entries
                .map(
                  (entry) => NavBarItem(
                    icon: entry.value['icon'],
                    label: entry.value['label'],
                    isSelected: selectedIndex == entry.key,
                    onTap: () => onItemSelected(entry.key),
                  ),
                )
                .toList(),
          ),
          Spacer(), 
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: NavBarItem(
              icon: Icons.logout,
              label: 'Logout',
              isSelected: false,
              onTap: () {
                Get.off(() => AuthenticationPage());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NavBarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Function onTap;

  const NavBarItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, 
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => widget.onTap(),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200), 
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? Colors.white.withOpacity(0.2)
                : _isHovered
                    ? Colors.white.withOpacity(0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: widget.isSelected ? Colors.white : Colors.white70,
                size: 24,
              ),
              SizedBox(height: 5), 
              Text(
                widget.label,
                textAlign: TextAlign.center, 
                style: TextStyle(
                  color: widget.isSelected ? Colors.white : Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
