import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../resources/resource.dart';


class PlayPause extends StatefulWidget {
  final YoutubePlayerController? controller;
  final Widget? bufferIndicator;

  const PlayPause({super.key,
    this.controller,
    this.bufferIndicator,
  });

  @override
  State<PlayPause> createState() => _PlayPauseState();
}

class _PlayPauseState extends State<PlayPause>
    with TickerProviderStateMixin {
  late YoutubePlayerController _controller;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      value: 0,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = YoutubePlayerController.of(context);
    if (controller == null) {
      assert(
      widget.controller != null,
      '\n\nNo controller could be found in the provided context.\n\n'
          'Try passing the controller explicitly.',
      );
      _controller = widget.controller!;
    } else {
      _controller = controller;
    }
    _controller.removeListener(_playPauseListener);
    _controller.addListener(_playPauseListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_playPauseListener);
    _animController.dispose();
    super.dispose();
  }

  void _playPauseListener() => _controller.value.isPlaying
      ? _animController.forward()
      : _animController.reverse();

  @override
  Widget build(BuildContext context) {
    final _playerState = _controller.value.playerState;
    if ((!_controller.flags.autoPlay && _controller.value.isReady) ||
        _playerState == PlayerState.playing ||
        _playerState == PlayerState.paused) {
      return Visibility(
        visible: _playerState == PlayerState.cued ||
            !_controller.value.isPlaying ||
            _controller.value.isControlsVisible,
        child: Material(
          color: colorTransparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(50.0),
            onTap: () => _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play(),
            child: CircleAvatar(
              radius: 4.5.w,
              backgroundColor: colorWhite,
              child: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                progress: _animController.view,
                color: colorBlack,
                size: 7.w,
              ),
            ),
          ),
        ),
      );
    }
    if (_controller.value.hasError) return const SizedBox();
    return widget.bufferIndicator ??
        SizedBox(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation(colorWhite),
              strokeWidth: 0.7.w
          ),
        );
  }
}
