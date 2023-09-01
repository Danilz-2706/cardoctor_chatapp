import 'package:flutter/material.dart';

import '../page/contains.dart';

class AppBarReview extends StatelessWidget {
  final String title;
  final bool isList;
  final String avatar;
  final VoidCallback press;
  const AppBarReview({
    super.key,
    required this.title,
    this.isList = true,
    required this.avatar,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F6F6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: press,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20, bottom: 5, top: 5, right: 5),
              child: Image.asset(
                'assets/imgs/ic_back.png',
                height: 24,
                width: 24,
                package: Consts.packageName,
              ),
            ),
          ),
          if (!isList)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 32,
                  width: 32,
                  child: Image.asset(
                    avatar,
                    height: 28,
                    width: 28,
                    package: Consts.packageName,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          if (isList)
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          const SizedBox(
            height: 24,
            width: 24,
          ),
        ],
      ),
    );
  }
}
