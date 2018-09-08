import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

// Define model for counter
class AppModel extends Model {
  // private variable count
  int _count = 0;

  // set getter
  int get count => _count;

  // Add increment and decrement methods
  void increment() {
    _count++;
    // tells widget to update
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }
}

void main() => runApp(new MyApp());

// * Main Widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counters',
      theme: ThemeData.dark(),
      home: ScopedModel<AppModel>(
        model: AppModel(),
        child: Home(),
      ),
    );
  }
}

// * Home widget
class Home extends StatelessWidget {
  final AppModel appModelOne = AppModel();
  final AppModel appModelTwo = AppModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scoped Model Demo with two counters')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ScopedModel<AppModel>(
              model: appModelOne,
              child: Counter(counterName: 'App Model One'),
            ),
            ScopedModel<AppModel>(
              model: appModelTwo,
              child: Counter(counterName: 'App Model Two'),
            ),
          ],
        ),
      ),
    );
  }
}

// * Counter Widget
class Counter extends StatelessWidget {
  final String counterName;

  // Counter constructor
  Counter({Key key, this.counterName});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("$counterName:"),
              Text(
                model.count.toString(),
                style: Theme.of(context).textTheme.display1,
              ),
              ButtonBar(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: model.increment,
                  ),
                  IconButton(
                    icon: Icon(Icons.minimize),
                    onPressed: model.decrement,
                  ),
                ],
              ),
            ],
          ),
    );
  }
}
