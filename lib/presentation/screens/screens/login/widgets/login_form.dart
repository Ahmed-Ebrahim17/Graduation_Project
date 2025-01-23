import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../Common/widgets/show_snackbar.dart';
import '../../../../../data/services/api.dart';
import '../../homePage/home_page.dart';
import '../../signup/sign_up.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class TLoginForm extends StatefulWidget {
  const TLoginForm({
    super.key,
  });

  @override
  State<TLoginForm> createState() => _TLoginFormState();
}

class _TLoginFormState extends State<TLoginForm> {
  bool isChecked = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          //* email
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.direct_right),
              labelText: TTexts.email,
            ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),
          //* password
          TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.password_check),
              suffixIcon: Icon(Iconsax.eye_slash),
              labelText: TTexts.password,
            ),
            obscureText: true,
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields / 2),

          //* Remeber me & forget password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //* Remeber me
              Row(
                children: [
                  Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value!;
                        });
                      }),
                  const Text(TTexts.rememberMe),
                ],
              ),
              //* forget password
              TextButton(
                  onPressed: () {}, child: const Text(TTexts.forgetPassword)),
            ],
          ),
          const SizedBox(
            height: TSizes.spaceBtwSections / 1.4,
          ),
          //* SignIn Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () async {
                  await ApiServices()
                      .loginUser(
                          context: context,
                          email: emailController.text,
                          password: passwordController.text)
                      .then((response) {
                    if (response) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const HomePage()));
                    } else {
                      showSnackBar(context, "Login failed. Please try again.",
                          Colors.red);
                    }
                  });
                },
                child: const Text(TTexts.signIn)),
          ),
          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),
          //* Create an account
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
                onPressed: () => Get.to((() => const SignUpScreen())),
                child: const Text(TTexts.createAccount)),
          ),
        ],
      ),
    );
  }
}
