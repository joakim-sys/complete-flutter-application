import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

class ArticleContentLoaderItem extends StatefulWidget {
  const ArticleContentLoaderItem({super.key, this.onPresented});

  final VoidCallback? onPresented;

  @override
  State<ArticleContentLoaderItem> createState() =>
      _ArticleContentLoaderItemState();
}

class _ArticleContentLoaderItemState extends State<ArticleContentLoaderItem> {
  @override
  void initState() {
    super.initState();
    widget.onPresented?.call();
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
