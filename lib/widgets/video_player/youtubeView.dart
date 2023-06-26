import 'package:flutter/material.dart';
import 'package:wbc_connect_app/widgets/video_player/playPauseButton.dart';
import 'package:wbc_connect_app/widgets/video_player/rawYoutubePlayer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../resources/resource.dart';
import 'error.dart';

class YoutubeVideoPlayer extends StatefulWidget {
  final Key? key;
  final YoutubePlayerController controller;
  final double? width;
  final Duration controlsTimeOut;
  final Widget? bufferIndicator;
  final ProgressBarColors progressColors;
  final Color progressIndicatorColor;
  final VoidCallback? onReady;
  final void Function(YoutubeMetaData metaData)? onEnded;
  final Color liveUIColor;
  final List<Widget>? topActions;
  final List<Widget>? bottomActions;
  final EdgeInsetsGeometry actionsPadding;
  final Widget? thumbnail;
  final bool showVideoProgressIndicator;

  const YoutubeVideoPlayer({required this.key,
    required this.controller,
    this.width,
    this.controlsTimeOut = const Duration(seconds: 3),
    this.bufferIndicator,
    Color? progressIndicatorColor,
    ProgressBarColors? progressColors,
    this.onReady,
    this.onEnded,
    this.liveUIColor = Colors.red,
    this.topActions,
    this.bottomActions,
    this.actionsPadding = const EdgeInsets.all(8.0),
    this.thumbnail,
    this.showVideoProgressIndicator = false,
  })  : progressColors = progressColors ?? const ProgressBarColors(),
        progressIndicatorColor = progressIndicatorColor ?? Colors.red;


  static String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }

  static String getThumbnail({
    required String videoId,
    String quality = ThumbnailQuality.standard,
    bool webp = true,
  }) =>
      webp
          ? 'https://i3.ytimg.com/vi_webp/$videoId/$quality.webp'
          : 'https://i3.ytimg.com/vi/$videoId/$quality.jpg';

  @override
  _YoutubeVideoPlayerState createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  late YoutubePlayerController controller;

  bool _initialLoad = true;

  @override
  void initState() {
    super.initState();
    controller = widget.controller..addListener(listener);
  }

  @override
  void didUpdateWidget(YoutubeVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.controller.removeListener(listener);
    widget.controller.addListener(listener);
  }

  void listener() async {
    if (controller.value.isReady && _initialLoad) {
      _initialLoad = false;
      if (controller.flags.autoPlay) controller.play();
      if (controller.flags.mute) controller.mute();
      widget.onReady?.call();
      if (controller.flags.controlsVisibleAtStart) {
        controller.updateValue(
          controller.value.copyWith(isControlsVisible: true),
        );
      }
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Colors.black,
      child: InheritedYoutubePlayer(
        controller: controller,
        child: Container(
          color: Colors.black,
          width: widget.width ?? MediaQuery.of(context).size.width,
          child: _buildPlayer(
            errorWidget: Container(
              color: Colors.black87,
              padding:
              const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: colorWhite,
                      ),
                      const SizedBox(width: 5.0),
                      Expanded(
                        child: Text(
                          errorString(
                            controller.value.errorCode,
                            videoId: controller.metadata.videoId.isNotEmpty
                                ? controller.metadata.videoId
                                : controller.initialVideoId,
                          ),
                          style: const TextStyle(
                            color: colorWhite,
                            fontWeight: FontWeight.w300,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Error Code: ${controller.value.errorCode}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayer({required Widget errorWidget}) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        RawYoutube(
          key: widget.key,
          onEnded: (YoutubeMetaData metaData) {
            if (controller.flags.loop) {
              controller.load(controller.metadata.videoId,
                  startAt: controller.flags.startAt,
                  endAt: controller.flags.endAt);
            }

            widget.onEnded?.call(metaData);
          },
        ),
        if (!controller.flags.hideThumbnail)
          AnimatedOpacity(
            opacity: controller.value.isPlaying ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            child: widget.thumbnail ?? _thumbnail,
          ),
        if (!controller.value.isFullScreen &&
            !controller.flags.hideControls &&
            controller.value.position > const Duration(milliseconds: 100) &&
            !controller.value.isControlsVisible &&
            widget.showVideoProgressIndicator &&
            !controller.flags.isLive)
          Positioned(
            bottom: -7.0,
            left: -7.0,
            right: -7.0,
            child: IgnorePointer(
              ignoring: true,
              child: ProgressBar(
                colors: widget.progressColors.copyWith(
                  handleColor: Colors.transparent,
                ),
              ),
            ),
          ),
        if (!controller.flags.hideControls) ...[
          TouchShutter(
            disableDragSeek: controller.flags.disableDragSeek,
            timeOut: widget.controlsTimeOut,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: !controller.flags.hideControls &&
                  controller.value.isControlsVisible
                  ? 1
                  : 0,
              duration: const Duration(milliseconds: 300),
              child: controller.flags.isLive
                  ? LiveBottomBar(
                liveUIColor: widget.liveUIColor,
                showLiveFullscreenButton:
                widget.controller.flags.showLiveFullscreenButton,
              )
                  : Padding(
                padding: widget.bottomActions == null
                    ? const EdgeInsets.all(0.0)
                    : widget.actionsPadding,
                child: Row(
                  children: widget.bottomActions ??
                      [
                        const SizedBox(width: 14.0),
                        CurrentPosition(),
                        const SizedBox(width: 8.0),
                        ProgressBar(
                          isExpanded: true,
                          colors: widget.progressColors,
                        ),
                        RemainingDuration(),
                        const PlaybackSpeedButton(),
                        FullScreenButton(),
                      ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: !controller.flags.hideControls &&
                  controller.value.isControlsVisible
                  ? 1
                  : 0,
              duration: const Duration(milliseconds: 300),
              child: Padding(
                padding: widget.actionsPadding,
                child: Row(
                  children: widget.topActions ?? [Container()],
                ),
              ),
            ),
          ),
        ],
        if (!controller.flags.hideControls)
           Center(
            child: PlayPause(bufferIndicator: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation(colorWhite),
                  strokeWidth: 0.7.w
              ),
            )),
          ),
        if (controller.value.hasError) errorWidget,
      ],
    );
  }

  Widget get _thumbnail => Image.network(
    YoutubePlayer.getThumbnail(
      videoId: controller.metadata.videoId.isEmpty
          ? controller.initialVideoId
          : controller.metadata.videoId,
    ),
    fit: BoxFit.cover,
    loadingBuilder: (_, child, progress) =>
    progress == null ? child : Container(color: Colors.black),
    errorBuilder: (context, _, __) => Image.network(
      YoutubePlayer.getThumbnail(
        videoId: controller.metadata.videoId.isEmpty
            ? controller.initialVideoId
            : controller.metadata.videoId,
        webp: false,
      ),
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) =>
      progress == null ? child : Container(color: Colors.black),
      errorBuilder: (context, _, __) => Container(),
    ),
  );
}
