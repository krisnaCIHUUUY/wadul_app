import 'package:flutter/material.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';
import 'package:wadul_app/core/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();

  List<IconData> navIcons = [
    Icons.home,
    Icons.notifications,
    Icons.add,
    Icons.article_outlined,
    Icons.person,
  ];

  List<String> navTitles = ["Home", "notification", "", "article", "profile"];

  int selectedIndex = 0;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: putihBackground,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: 110,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/wadul_logo.png',
                          fit: BoxFit.contain,
                          height: 200,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: darkTosca,
                            child: Icon(Icons.person, color: putihText),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      fillColor: putihText,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(width: 2, color: tosca),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {},
                        child: Icon(Icons.search, size: 30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pupolar',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'View all',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(10),
                              side: BorderSide.none,
                            ),
                            backgroundColor: darkTosca,
                            fixedSize: Size.fromWidth(150),
                          ),
                          child: Text(
                            'Hari ini',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: putihText,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(10),
                              side: BorderSide(width: 2, color: darkTosca),
                            ),
                            backgroundColor: putihBackground,
                            fixedSize: Size.fromWidth(150),
                          ),
                          child: Text(
                            'tertangani',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: hitamtext,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  margin: EdgeInsets.only(left: 36, right: 30),
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(right: 20, left: 20),
                        // height: 200,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    },
                  ),
                ),
                // BOTTOM NAVIGATION BAR E
              ],
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
