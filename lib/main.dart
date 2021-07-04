import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

void main() => runApp(ProviderApp());

class ProviderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Data(),
      child: MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Some TITLE',
          style: TextStyle(
            color: context.watch<Data>().getTitleColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimContainer(),
            Switcher(),
          ],
        ),
      ),
    );
  }
}

class AnimContainer extends StatefulWidget {
  @override
  _AnimContainerState createState() => _AnimContainerState();
}

class _AnimContainerState extends State<AnimContainer> {
  // bool selected = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      width: context.watch<Data>().getSelected ? 250.0 : 150.0,
      height: context.watch<Data>().getSelected ? 100.0 : 150.0,
      color: context.watch<Data>()._dataContainerColor,
      curve: Curves.fastOutSlowIn,
    );
  }
}

class Switcher extends StatefulWidget {
  @override
  _SwitcherState createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  bool isSwitched = false;
  Color? newContainerColor;
  Color? newTitleColor;
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isSwitched,
      onChanged: (value) {
        // set Container color
        newContainerColor =
            Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0);
        context.read<Data>().changeContainerColor(newContainerColor!);
        // set Title color
        newTitleColor = Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0);
        context.read<Data>().changeTitleColor(newTitleColor!);
        setState(() {
          isSwitched = value;
          context.read<Data>().changeSelectedContainer(isSwitched);
        });
      },
      activeColor: context.watch<Data>().getContainerColor,
      activeTrackColor: context.watch<Data>().getContainerColor,
      inactiveTrackColor: context.watch<Data>().getContainerColor,
      inactiveThumbColor: context.watch<Data>().getContainerColor,
    );
  }
}

class Data extends ChangeNotifier {
  Color _dataContainerColor = Colors.yellow;
  Color _dataTitleColor = Colors.pink;
  bool _selectedContainer = false;

  Color get getContainerColor => _dataContainerColor;

  Color get getTitleColor => _dataTitleColor;

  bool get getSelected => _selectedContainer;

  void changeContainerColor(Color color) {
    _dataContainerColor = color;

    notifyListeners();
  }

  void changeTitleColor(Color color) {
    _dataTitleColor = color;
    notifyListeners();
  }

  void changeSelectedContainer(bool selected) {
    _selectedContainer = selected;
    notifyListeners();
  }
}
