import 'package:flutter/material.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
import 'package:wadul_app/features/report/presentation/pages/add_page.dart';
import 'package:wadul_app/features/report/presentation/pages/article_page.dart';
import 'package:wadul_app/core/pages/home_content.dart';
import 'package:wadul_app/core/pages/notification_page.dart';
import 'package:wadul_app/core/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<IconData> navIcons = [
    Icons.home,
    Icons.notifications,
    Icons.add,
    Icons.article_outlined,
    Icons.person,
  ];

  List<String> navTitles = ["Home", "notification", "", "riwayat", "profile"];

  int selectedIndex = 0;

  List<Widget> pages = [
    HomeContent(),
    NotificationPage(),
    AddPage(),
    ArticlePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: putihBackground,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 400),
              transitionBuilder: (child, Animation<double> animation) {
                final offsetAnimation = Tween<Offset>(
                  begin: const Offset(0.1, 0.0),
                  end: Offset.zero,
                ).animate(animation);
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  ),
                );
              },
              child: pages[selectedIndex],
            ),

            Align(
              alignment: AlignmentGeometry.bottomCenter,
              child: Container(
                height: 65,
                margin: EdgeInsets.only(left: 25, right: 25, bottom: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: putihText,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 20,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: navIcons.map((icon) {
                    int index = navIcons.indexOf(icon);
                    bool isSelected = (selectedIndex == index);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Material(
                        color: Colors.transparent,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                alignment: AlignmentGeometry.center,
                                margin: EdgeInsets.only(
                                  top: 0,
                                  right: 22,
                                  left: 22,
                                  bottom: 0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                child: Icon(
                                  icon,
                                  color: isSelected ? tosca : hitamtext,
                                ),
                              ),
                              Text(
                                navTitles[index],
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected ? tosca : hitamtext,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
