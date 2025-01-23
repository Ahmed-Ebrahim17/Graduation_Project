import 'package:easy_summary/presentation/screens/screens/onBoarding/controllers/onBoarding_controller.dart';
import 'package:easy_summary/presentation/screens/screens/onBoarding/widgets/onBoarding_Skip.dart';
import 'package:easy_summary/presentation/screens/screens/onBoarding/widgets/onboarding_dot_navigation.dart';
import 'package:easy_summary/presentation/screens/screens/onBoarding/widgets/onboarding_nextbutton.dart';
import 'package:easy_summary/presentation/screens/screens/onBoarding/widgets/onboarding_page.dart';
import 'package:easy_summary/utils/constants/text_strings.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              OnBoardingPage(
                image: TImages.onBoardingImage1,
                title: TTexts.onBoardingTitle1,
                subTitle: TTexts.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: TImages.onBoardingImage2,
                title: TTexts.onBoardingTitle2,
                subTitle: TTexts.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: TImages.onBoardingImage3,
                title: TTexts.onBoardingTitle3,
                subTitle: TTexts.onBoardingSubTitle3,
              ),
            ],
          ),
          OnBoardingSkip(),
          OnBoardingDotNavigation(),
          OnBoardingNextButton(),
        ],
      ),
    );
  }
}
