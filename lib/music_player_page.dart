import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({Key? key}) : super(key: key);

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  late RiveAnimationController _prevButtonController;
  late RiveAnimationController _nextButtonController;
  late RiveAnimationController _soundWaveController;

  SMIInput<bool>? _playButtonInput;
  Artboard? _playButtonArtboard;

  void _playTrackChangeAnimation(RiveAnimationController controller) {
    if (controller.isActive == false) {
      controller.isActive = true;
    }
  }

  void _playPauseButtonAnimation() {
    if (_playButtonInput?.value == false &&
        _playButtonInput?.controller.isActive == false) {
      _playButtonInput?.value = true;
      _toggleWaveAnimation();
    } else if (_playButtonInput?.value == true &&
        _playButtonInput?.controller.isActive == false) {
      _playButtonInput?.value = false;
      _toggleWaveAnimation();
    }
  }

  void _toggleWaveAnimation() => setState(
        () => _soundWaveController.isActive = !_soundWaveController.isActive,
      );

  @override
  void initState() {
    super.initState();
    _prevButtonController = OneShotAnimation(
      'onPrev',
      autoplay: false,
    );
    _nextButtonController = OneShotAnimation(
      'onNext',
      autoplay: false,
    );
    _soundWaveController = SimpleAnimation(
      'loopingAnimation',
      autoplay: false,
    );

    rootBundle.load('assets/PlayPauseButton.riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      var controller = StateMachineController.fromArtboard(
        artboard,
        'PlayPauseButton',
      );
      if (controller != null) {
        artboard.addController(controller);
        _playButtonInput = controller.findInput('isPlaying');
      }
      setState(
        () => _playButtonArtboard = artboard,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[600],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/album_cover.png',
                  ),
                ),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(
              height: 60,
            ),
            _playButtonArtboard == null
                ? SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTapDown: (_) => _playTrackChangeAnimation(
                          _prevButtonController,
                        ),
                        child: SizedBox(
                          height: 115,
                          width: 115,
                          child: RiveAnimation.asset(
                            'assets/PrevTrackButton.riv',
                            controllers: [
                              _prevButtonController,
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTapDown: (_) => _playPauseButtonAnimation(),
                        child: SizedBox(
                          height: 125,
                          width: 125,
                          child: Rive(
                            artboard: _playButtonArtboard!,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTapDown: (_) => _playTrackChangeAnimation(
                          _nextButtonController,
                        ),
                        child: SizedBox(
                          height: 115,
                          width: 115,
                          child: RiveAnimation.asset(
                            'assets/NextTrackButton.riv',
                            controllers: [
                              _nextButtonController,
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
            SizedBox(
              height: 40,
            ),
            Container(
                height: 100,
                width: 400,
                child: RiveAnimation.asset(
                  'assets/SoundWave.riv',
                  fit: BoxFit.contain,
                  controllers: [
                    _soundWaveController,
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
