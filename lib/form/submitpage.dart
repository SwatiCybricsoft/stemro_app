import 'package:flutter/material.dart';

class SubmitPage extends StatefulWidget {
  const SubmitPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<SubmitPage> createState() => _SubmitPageState();
}
Color themeColor = const Color(0xFF43D19E);

class _SubmitPageState extends State<SubmitPage> {
  double screenWidth = 600;
  double screenHeight = 400;
  Color textColor = const Color(0xFF32567A);

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 170,
              padding: const EdgeInsets.all(35),
              decoration: BoxDecoration(
                color: themeColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                "assets/cardimage.png",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: screenHeight * 0.1),
            Text(
              "Thank You!",
              style: TextStyle(
                color: themeColor,
                fontWeight: FontWeight.w600,
                fontSize: 36,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            const Text(
              "Details filled Successfully",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            const Text(
              "You will be redirected to the home page shortly\nor click here to return to home page",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            SizedBox(height: screenHeight * 0.06),
            // Flexible(
            //   child: HomeButton(
            //     title: 'Home',
            //     onTap: () {
            //       Navigator.pop(context);
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}