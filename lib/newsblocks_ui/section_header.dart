import 'package:api/client.dart';
import 'package:flutter/material.dart';

import 'block_action_callback.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.block, this.onPressed});

  final SectionHeaderBlock block;
  final BlockActionCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = Text(block.title, style: theme.textTheme.displaySmall);
    final action = block.action;
    final trailing = action != null
        ? IconButton(
            onPressed: () => onPressed?.call(action),
            icon: const Icon(Icons.chevron_right))
        : null;
    return ListTile(
      title: title,
      trailing: trailing,
      visualDensity:
          const VisualDensity(vertical: VisualDensity.minimumDensity),
    );
  }
}
