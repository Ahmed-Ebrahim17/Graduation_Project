import 'package:flutter/material.dart';

import 'widgets/sign_upForm.dart';
import '../../../../utils/helpers/helper_functions.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: TSizes.defaultSpace / 2,
              left: TSizes.defaultSpace,
              right: TSizes.defaultSpace,
              bottom: TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TTexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              // ! SignUP Form
              TSignUpForm(dark: dark),
              // ! CheckBox and text

              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              // ! Divider

              // //! Scoail button
            ],
          ),
        ),
      ),
    );
  }
}
