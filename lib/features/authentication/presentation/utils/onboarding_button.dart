import 'package:flutter/material.dart';
import 'package:wadul_app/core/colors/custom_colors.dart';

class OnboardingButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  const OnboardingButton({super.key, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        // backgroundColor: putihBackground,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadiusGeometry.circular(15),
        ),
        fixedSize: Size(double.infinity, 60),
        disabledBackgroundColor: putihBackground,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          color: hitamtext,
        ),
      ),
    );
  }
}
