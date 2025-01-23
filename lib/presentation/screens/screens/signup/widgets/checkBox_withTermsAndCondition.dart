import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class CheckBoxWithTermsAndCondition extends StatefulWidget {
  const CheckBoxWithTermsAndCondition({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  State<CheckBoxWithTermsAndCondition> createState() =>
      _CheckBoxWithTermsAndConditionState();
}

class _CheckBoxWithTermsAndConditionState
    extends State<CheckBoxWithTermsAndCondition> {
  bool? isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = value;
                  });
                })),
        const SizedBox(
          width: TSizes.spaceBtwItems,
        ),
        Text.rich(
          TextSpan(children: [
            const TextSpan(text: '${TTexts.iAgreeTo} '),
            TextSpan(
              text: TTexts.privacyPolicy,
              style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: widget.dark ? TColors.white : TColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor:
                        widget.dark ? TColors.white : TColors.primary,
                  ),
            ),
            const TextSpan(text: ' ${TTexts.and} '),
            TextSpan(
              text: TTexts.termsOfUse,
              style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: widget.dark ? TColors.white : TColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor:
                        widget.dark ? TColors.white : TColors.primary,
                  ),
            ),
          ]),
        ),
      ],
    );
  }
}
