import 'package:flutter/material.dart';

class CustomAvatar extends StatefulWidget {
  final String mainImagePath;
  final String firstLabel;
  final VoidCallback onPressed;
  final EdgeInsets mainImagePadding;

  const CustomAvatar({
    Key? key,
    required this.mainImagePath,
    required this.firstLabel,
    required this.onPressed,
    this.mainImagePadding = const EdgeInsets.only(left: 0.0),
  }) : super(key: key);

  @override
  State<CustomAvatar> createState() => _CustomAvatarState();
}

class _CustomAvatarState extends State<CustomAvatar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.84),
                radius: 45,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 0.5),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: widget.mainImagePadding,
                        child: Image.asset(
                          widget.mainImagePath,
                          width: 45,
                          height: 45,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 3,
                      bottom: 0,
                      child: Image.asset(
                        'assets/images/plus_icon.png',
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${widget.firstLabel}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
