import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lncmis_mobile_app/core/constants/custom_dimension.dart';

class SplashImplementingPartnerList extends StatelessWidget {
  const SplashImplementingPartnerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFFFFFFFF),
        padding: EdgeInsets.only(top: CustomDimension.defaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2),
              height: 50,
              child: const Image(image: AssetImage('assets/logos/perpfar.png')),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2),
              height: 40,
              child: const Image(image: AssetImage('assets/logos/usaid.png')),
            ),
            SvgPicture.asset('assets/logos/kb.svg'),
            SvgPicture.asset('assets/logos/hisptz.svg'),
          ],
        ));
  }
}
