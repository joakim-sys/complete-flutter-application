import 'package:flutter/material.dart';
import 'package:pro_one/login/login_modal.dart';
import 'package:pro_one/packages/app_ui/app_back_button.dart';

import 'magic_link_prompt_view.dart';

class MagicLinkPromptPage extends StatelessWidget {
  const MagicLinkPromptPage({super.key, required this.email});
  final String email;

  static Route<void> route({required String email}) => MaterialPageRoute<void>(
      builder: (_) => MagicLinkPromptPage(email: email));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context)
                  .popUntil((route) => route.settings.name == LoginModal.name),
              icon: const Icon(Icons.close))
        ],
      ),
      body: MagicLinkPromptView(email: email),
    );
  }
}
