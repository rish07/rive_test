import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({Key key}) : super(key: key);

  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> {
  final riveFileName = 'assets/car.riv';
  Artboard _artboard;
  RiveAnimationController _wipersController;
  bool _wipers = false;

  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile();

    if (file.import(bytes)) {
      // Select an animation by its name
      setState(() => _artboard = file.mainArtboard
        ..addController(
          SimpleAnimation('idle'),
        ));
    }
  }

  void _wipersChange(bool wipersOn) {
    if (_wipersController == null) {
      _artboard.addController(
        _wipersController = SimpleAnimation('windshield_wipers'),
      );
    }
    setState(() => _wipersController.isActive = _wipers = wipersOn);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadRiveFile();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(
            child: _artboard != null
                ? Rive(
                    artboard: _artboard,
                    fit: BoxFit.cover,
                  )
                : Container(),
          ),
          SizedBox(
            height: 50,
            width: 200,
            child: SwitchListTile(
              title: const Text('Wipers'),
              value: _wipers,
              onChanged: _wipersChange,
            ),
          ),
        ],
      ),
    );
  }
}
