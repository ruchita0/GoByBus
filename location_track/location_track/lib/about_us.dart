import 'dart:async';

import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key});

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  final List<Map<String, String>> teamMembers = [
    {
      "name": "Rachana Mangalaram",
      "role": "Project Manager",
      "image": "images/Rachana.png"
    },
    {
      "name": "Sampada Tikale",
      "role": "UI/UX Designer",
      "image": "images/Sampada.png"
    },
    {
      "name": "Ruchita Mangalaram",
      "role": "Lead Developer",
      "image": "images/Ruchita.png"
    },
    {
      "name": "Sanjana Yerate",
      "role": "Software Engineer",
      "image": "images/Sanjana.jpg"
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context); // Navigate back when arrow button is pressed
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(
                  constraints.maxWidth > 600 ? 40 : 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Meet Our Team',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'We are a team of passionate developers currently enrolled as students at N. K Orchid College of Engineering and Technology, specializing in the Computer Science and Engineering department. Comprising four dedicated members, we have collaborated under the mentorship and guidance of Prof. S. Sanmukh to bring our project to fruition.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: constraints.maxWidth > 600 ? 400 : 300,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: teamMembers.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    radius:
                                        constraints.maxWidth > 600 ? 100 : 80,
                                    backgroundImage: AssetImage(
                                        teamMembers[index]["image"]!),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    teamMembers[index]["name"]!,
                                    style: TextStyle(
                                      fontSize:
                                          constraints.maxWidth > 600 ? 24 : 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    teamMembers[index]["role"]!,
                                    style: TextStyle(
                                      fontSize:
                                          constraints.maxWidth > 600 ? 20 : 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
