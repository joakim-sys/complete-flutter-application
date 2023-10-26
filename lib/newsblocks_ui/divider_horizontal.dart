import 'package:api/client.dart';
import 'package:flutter/material.dart';

class DividerHorizontal extends StatelessWidget {
  const DividerHorizontal({super.key, required this.block});

  final DividerHorizontalBlock block;
  @override
  Widget build(BuildContext context) {
    return const Divider();
  }
}
