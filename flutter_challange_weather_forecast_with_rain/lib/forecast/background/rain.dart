import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as flutterServices;
import 'package:spritewidget/spritewidget.dart' as spriteWidget;

spriteWidget.ImageMap _images;
spriteWidget.SpriteSheet _sprites;

class Rain extends StatefulWidget {
  _RainState createState() => _RainState();
}

class _RainState extends State<Rain> {
  bool assetsLoaded = false;
  WeatherWorld weatherWorld;

  @override
  void initState() {
    super.initState();

    flutterServices.AssetBundle bundle = flutterServices.rootBundle;
    _loadAssets(bundle).then((_) => setState(() {
          assetsLoaded = true;
          weatherWorld = WeatherWorld();
        }));
  }

  Future<Null> _loadAssets(flutterServices.AssetBundle bundle) async {
    _images = spriteWidget.ImageMap(bundle);

    await _images.load([
      'assets/weathersprites.png',
    ]);

// This json decides, how to cut out the SpriteSheet
    String json = await DefaultAssetBundle.of(context)
        .loadString('assets/weathersprites.json');

    _sprites =
        spriteWidget.SpriteSheet(_images['assets/weathersprites.png'], json);
  }

  @override
  Widget build(BuildContext context) {
    return assetsLoaded ? spriteWidget.SpriteWidget(weatherWorld) : Container();
  }
}

class WeatherWorld extends spriteWidget.NodeWithSize {
  RainNode _rain;

  WeatherWorld() : super(const Size(2048.0, 2048.0)) {
    _rain = RainNode();
    _rain.active = true;
    addChild(_rain);
  }
}

class RainNode extends spriteWidget.Node {
  List<spriteWidget.ParticleSystem> _particles = [];

  RainNode() {
    _addParticles(1.0);
    _addParticles(1.5);
    _addParticles(2.0);
  }

  void _addParticles(double distance) {
    spriteWidget.ParticleSystem particle = spriteWidget.ParticleSystem(
      _sprites['raindrop.png'],
      transferMode:
          BlendMode.lighten, //It will only render white parts of the drops
      posVar: const Offset(1300.0, 0.0),
      direction: 90.0,
      directionVar: 0.0,
      speed: 10000.0 / distance,
      speedVar: 200.0 / distance,
      startSize: 1.2 / distance,
      startSizeVar: 0.2 / distance,
      endSize: 1.2 / distance,
      endSizeVar: 0.2 / distance,
      life: 1.5 * distance,
      maxParticles: 45,
    );

    particle.position = const Offset(1024.0, -200.0);
    particle.rotation = 0.0;
    particle.opacity = 0.0;

    _particles.add(particle);
    addChild(particle); //Add it to the display graph
  }

  set active(bool active) {
    actions.stopAll();
    for (spriteWidget.ParticleSystem system in _particles) {
      if (active) {
        actions.run(spriteWidget.ActionTween<double>(
          (value) => system.opacity = value,
          system.opacity,
          1.0,
          2.0,
        ));
      } else {
        actions.run(
          spriteWidget.ActionTween<double>(
            (value) => system.opacity = value,
            system.opacity,
            0.0,
            0.5,
          ),
        );
      }
    }
  }
}
