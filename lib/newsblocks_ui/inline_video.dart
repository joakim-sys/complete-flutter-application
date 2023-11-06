import 'package:flutter/material.dart';
import 'package:pro_one/gen/assets.gen.dart';
import 'package:video_player/video_player.dart';

typedef VideoPlayerControllerBuilder = VideoPlayerController Function(
    Uri videoUrl);

class InlineVideo extends StatefulWidget {
  const InlineVideo({
    super.key,
    required this.videoUrl,
    required this.progressIndicator,
    this.videoPlayerControllerBuilder = VideoPlayerController.networkUrl,
  });

  static const _aspectRatio = 3 / 2;
  final String videoUrl;
  final Widget progressIndicator;
  final VideoPlayerControllerBuilder videoPlayerControllerBuilder;

  @override
  State<InlineVideo> createState() => _InlineVideoState();
}

class _InlineVideoState extends State<InlineVideo> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.videoPlayerControllerBuilder(Uri.parse(widget.videoUrl))
          ..addListener(_onVideoUpdated)
          ..initialize().then((value) {
            if (mounted) setState(() {});
          });
  }

  @override
  void dispose() {
    super.dispose();
    _controller
      ..removeListener(_onVideoUpdated)
      ..dispose();
  }

  void _onVideoUpdated() {
    if (!mounted || _isPlaying == _controller.value.isPlaying) {
      return;
    }
    setState(() {
      _isPlaying = _controller.value.isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: InlineVideo._aspectRatio,
      child: _controller.value.isInitialized
          ? GestureDetector(
              onTap: () {
                setState(() {
                  _isPlaying ? _controller.pause() : _controller.play();
                });
              },
              child: ClipRRect(
                child: Stack(
                  children: [
                    SizedBox.expand(
                        child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                                width: _controller.value.size.width,
                                height: _controller.value.size.height,
                                child: VideoPlayer(_controller)))),
                    Center(
                      child: Visibility(
                          visible: !_isPlaying,
                          child: Assets.icons.playIcon.svg()),
                    )
                  ],
                ),
              ),
            )
          : widget.progressIndicator,
    );
  }
}
