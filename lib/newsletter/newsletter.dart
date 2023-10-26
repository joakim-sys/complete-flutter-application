import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_one/analytics/analytics_bloc.dart';
import 'package:pro_one/gen/assets.gen.dart';
import 'package:pro_one/l10n/l10n.dart';
import 'package:pro_one/newsletter/newsletter_bloc.dart' hide NewsletterEvent;
import 'package:pro_one/newsletter/newsletter_succeeded.dart';
import 'package:pro_one/packages/app_ui/app_spacing.dart';
import 'package:pro_one/packages/news_repository.dart';
import 'package:pro_one/packages/ntg_event.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Newsletter extends StatelessWidget {
  const Newsletter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewsletterBloc>(
        create: (context) =>
            NewsletterBloc(newsRepository: context.read<NewsRepository>()),
        child: const NewsletterView());
  }
}

class NewsletterView extends StatefulWidget {
  const NewsletterView({super.key});

  @override
  State<NewsletterView> createState() => _NewsletterViewState();
}

class _NewsletterViewState extends State<NewsletterView> {
  bool _newsletterShown = false;

  @override
  Widget build(BuildContext context) {
    final isEmailValid =
        context.select<NewsletterBloc, bool>((bloc) => bloc.state.isValid);
    return VisibilityDetector(
      key: const Key('newsletterView'),
      onVisibilityChanged: _newsletterShown
          ? null
          : (visibility) {
              if (!visibility.visibleBounds.isEmpty) {
                context
                    .read<AnalyticsBloc>()
                    .add(TrackAnalyticsEvent(NewsletterEvent.impression()));
                setState(() {
                  _newsletterShown = true;
                });
              }
            },
      child: BlocConsumer<NewsletterBloc, NewsletterState>(
        listener: (context, state) {
          if (state.status == NewsletterStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                  SnackBar(content: Text(context.l10n!.subscribeErrorMessage)));
          } else if (state.status == NewsletterStatus.success) {
            context
                .read<AnalyticsBloc>()
                .add(TrackAnalyticsEvent(NewsletterEvent.signUp()));
          }
        },
        builder: (context, state) {
            if (state.status == NewsletterStatus.success) {
            return NewsletterSucceeded(
              headerText: context.l10n!.subscribeSuccessfulHeader,
              content: SizedBox(
                height: AppSpacing.xxxlg + AppSpacing.md,
                width: AppSpacing.xxxlg + AppSpacing.md,
                child: Assets.icons.envelopeOpen.svg(),
              ),
              footerText: context.l10n!.subscribeSuccessfulEmailBody,
            );
          }
        },
      ),
    );
  }
}
