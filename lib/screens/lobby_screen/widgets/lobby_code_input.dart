import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../themes/app_colors.dart';

class LobbyCodeInput extends StatelessWidget {
  final String code; 

  const LobbyCodeInput({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: SelectableText(
                code,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Copied to clipboard!"),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Icon(Icons.copy, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }
}
