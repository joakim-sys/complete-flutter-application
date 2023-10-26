import 'package:flutter/material.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';

class CategoryFeedLoaderItem extends StatefulWidget {
  const CategoryFeedLoaderItem({super.key, this.onPresented});

  final VoidCallback? onPresented;

  @override
  State<CategoryFeedLoaderItem> createState() => _CategoryFeedLoaderItemState();
}

class _CategoryFeedLoaderItemState extends State<CategoryFeedLoaderItem> {
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
