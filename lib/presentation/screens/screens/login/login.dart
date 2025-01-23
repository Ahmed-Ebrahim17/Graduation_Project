// ignore_for_file: prefer_const_constructors

import 'package:easy_summary/presentation/screens/screens/login/widgets/login_form.dart';
import 'package:easy_summary/presentation/screens/screens/login/widgets/login_header.dart';
import 'package:flutter/material.dart';

import '../../../../Common/styles/spacing_styles.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              //* logo ,title , subTitle.
              TLoginHeader(dark: dark),
              SizedBox(
                height: TSizes.spaceBtwSections + 10,
              ),
              //! Form
              TLoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
