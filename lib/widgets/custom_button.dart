import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.desabilitado,
    required this.label,
    required this.onTap,
  });

  final bool desabilitado;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: desabilitado ? null : onTap,
      child: Text(label),
    );
  }
}
