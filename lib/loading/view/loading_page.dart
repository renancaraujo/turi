import 'package:crystal_ball/l10n/l10n.dart';
import 'package:crystal_ball/loading/loading.dart';
import 'package:crystal_ball/title/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Future<void> onPreloadComplete(BuildContext context) async {
    final navigator = Navigator.of(context);
    await Future<void>.delayed(AnimatedProgressBar.intrinsicAnimationDuration);
    if (!mounted) {
      return;
    }
    await navigator.pushReplacement<void, void>(TitlePage.route());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PreloadCubit, PreloadState>(
      listenWhen: (prevState, state) =>
          !prevState.isComplete && state.isComplete,
      listener: (context, state) => onPreloadComplete(context),
      child: const Scaffold(
        body: Center(
          child: _LoadingInternal(),
        ),
      ),
    );
  }
}

class _LoadingInternal extends StatelessWidget {
  const _LoadingInternal();

  @override
  Widget build(BuildContext context) {
    final primaryTextTheme = Theme.of(context).primaryTextTheme;
    final l10n = context.l10n;

    return BlocBuilder<PreloadCubit, PreloadState>(
      builder: (context, state) {
        final loadingLabel = l10n.loadingPhaseLabel(state.currentLabel);
        final loadingMessage = l10n.loading(loadingLabel);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: AnimatedProgressBar(
                progress: state.progress,
                backgroundColor: const Color(0xFF2A48DF),
                foregroundColor: const Color(0xFFFFFFFF),
              ),
            ),
            Text(
              loadingMessage,
              style: primaryTextTheme.bodySmall!.copyWith(
                color: const Color(0xFF2A48DF),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        );
      },
    );
  }
}
