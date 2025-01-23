import 'package:easy_summary/Common/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../data/services/api.dart';
import 'checkBox_withTermsAndCondition.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class TSignUpForm extends StatefulWidget {
  const TSignUpForm({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  State<TSignUpForm> createState() => _TSignUpFormState();
}

class _TSignUpFormState extends State<TSignUpForm> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final phoneController = TextEditingController();
    final firstnameController = TextEditingController();
    final lastnameController = TextEditingController();
    final usernameController = TextEditingController();

    return Form(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //* First name
              Expanded(
                child: TextFormField(
                  controller: firstnameController,
                  expands: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.user),
                    labelText: TTexts.firstName,
                  ),
                ),
              ),
              const SizedBox(
                width: TSizes.spaceBtwInputFields,
              ),
              //* lastName
              Expanded(
                child: TextFormField(
                  controller: lastnameController,
                  expands: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.user),
                    labelText: TTexts.lastName,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),
          //* UserName
          TextFormField(
            controller: usernameController,
            expands: false,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.user_edit),
              labelText: TTexts.username,
            ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),
          //* Email
          TextFormField(
            controller: emailController,
            expands: false,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.direct),
              labelText: TTexts.email,
            ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),
          //* Phone
          TextFormField(
            controller: phoneController,
            expands: false,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.call),
              labelText: TTexts.phoneNo,
            ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),
          //* Password
          TextFormField(
            controller: passwordController,
            expands: false,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.password_check),
              suffixIcon: Icon(Iconsax.eye_slash),
              labelText: TTexts.password,
            ),
            obscureText: true,
          ),
          // ignore: prefer_const_constructors
          SizedBox(
            height: TSizes.spaceBtwSections,
          ),
          //! ChechBox with terms and conditions.
          CheckBoxWithTermsAndCondition(dark: widget.dark),
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),
          // ! SignUp Button.
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await ApiServices()
                    .signUpUser(
                  context: context,
                  firstName: firstnameController.text,
                  lastName: lastnameController.text,
                  username: usernameController.text,
                  phoneNumber: phoneController.text,
                  email: emailController.text,
                  password: passwordController.text,
                )
                    .then((response) {
                  if (response) {
                    Navigator.pop(context);
                  } else {
                    showSnackBar(context, "Register failed. Please try again.",
                        Colors.red);
                  }
                });
              },
              child: const Text(TTexts.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}
