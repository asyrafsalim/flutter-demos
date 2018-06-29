// uses material design
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

// fat arrow (=>) notation, which is short hand used for one-line functions or methods
void main() => runApp(new MyApp());

// The app extends StatelessWidget which makes the app itself a widget. 
// In Flutter, almost everything is a widget, including alignment, padding, and layout.
class MyApp extends StatelessWidget {
  @override
  // The Scaffold widget, from the Material library, provides a default app bar, title, and a body property that holds the widget tree for the home screen.
  // The build() method describes how to display the widget in terms of other, lower level widgets.
  // The widget tree for this example consists of a Center widget containing a Text child widget. The Center widget aligns its widget subtree to the center of the screen.
  Widget build(BuildContext context) {
    // You can easily change an app’s theme by configuring the ThemeData class. Your app currently uses the default theme, but you’ll be changing the primary color to be white.
    return new MaterialApp(
      title: 'Startup Name Generator',
      theme: new ThemeData(
        primaryColor: Colors.white
      ),
      home: new RandomWords(),
    );
  }
}

// Stateless widgets are immutable, meaning that their properties can’t change—all values are final.
// Stateful widgets maintain state that might change during the lifetime of the widget. 
// Implementing a stateful widget requires at least two classes: 
// 1) a StatefulWidget class that creates an instance of 
// 2) a State class. 
// The StatefulWidget class is, itself, immutable, but the State class persists over the lifetime of the widget.
class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

// The RandomWordsState class, most of the app’s code resides in this class, which maintains the state for the RandomWords widget. 
// This class will save the generated word pairs, which grow infinitely as the user scrolls, and also favorite word pairs, as the user adds or removes them from the list by toggling the heart icon.
class RandomWordsState extends State<RandomWords> {
  // _suggestions list for saving suggested word pairings. The variable begins with an underscore (_)—prefixing an identifier with an underscore enforces privacy in the Dart language.
  final _suggestions = <WordPair>[];

  // Add a _saved Set to RandomWordsState. This Set stores the word pairings that the user favorited. Set is preferred to List because a properly implemented Set does not allow duplicate entries.
  final _saved = new Set<WordPair>();

  // biggerFont variable for making the font size larger
  final _biggerFont = const TextStyle(fontSize: 18.0);

  // Add a _pushSaved() function to the RandomWordsState class.
  // When the user taps the list icon in the app bar, build a route and push it to the Navigator’s stack. This action changes the screen to display the new route.
  // The content for the new page is built in MaterialPageRoute’s builder property, in an anonymous function.
  // Add the call to Navigator.push, as shown by the highlighted code, which pushes the route to the Navigator’s stack.
  void _pushSaved() {
    Navigator.of(context).push(
      // Add the MaterialPageRoute and its builder. For now, add the code that generates the ListTile rows. The divideTiles() method of ListTile adds horizontal spacing between each ListTile. The divided variable holds the final rows, converted to a list by the convenience function, toList().
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
            (pair) { 
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              ); 
            }
          );

          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          // The builder property returns a Scaffold, containing the app bar for the new route, named “Saved Suggestions.” The body of the new route consists of a ListView containing the ListTiles rows; each row is separated by a divider.
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        }
      )
    );
  }

  // Add a _buildSuggestions() function to the RandomWordsState class. This method builds the ListView that displays the suggested word pairing.
  // The ListView class provides a builder property, itemBuilder, a factory builder and callback function specified as an anonymous function. Two parameters are passed to the function—the BuildContext, and the row iterator, i. The iterator begins at 0 and increments each time the function is called, once for every suggested word pairing. This model allows the suggested list to grow infinitely as the user scrolls.
  Widget _buildRow(WordPair pair) {
    // Add an alreadySaved check to ensure that a word pairing has not already been added to favorites.
    final alreadySaved = _saved.contains(pair);

    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      // add heart-shaped icons to the ListTiles to enable favoriting. Later, you’ll add the ability to interact with the heart icons.
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      // Make the name suggestion tiles tappable in the _buildRow function. If a word entry has already been added to favorites, tapping it again removes it from favorites. When a tile has been tapped, the function calls  setState() to notify the framework that state has changed.
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
  
  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      // The itemBuilder callback is called once per suggested word pairing,
      // and places each suggestion into a ListTile row.
      // For even rows, the function adds a ListTile row for the word pairing.
      // For odd rows, the function adds a Divider widget to visually
      // separate the entries. Note that the divider may be difficult
      // to see on smaller devices.
      itemBuilder: (context, i) {
        // Add a one-pixel-high divider widget before each row in theListView.
        if (i.isOdd) return new Divider();
        // The syntax "i ~/ 2" divides i by 2 and returns an integer result.
        // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
        // This calculates the actual number of word pairings in the ListView,
        // minus the divider widgets.
        final index = i ~/ 2;
        // If you've reached the end of the available word pairings...
        if (index >= _suggestions.length) {
          // ...then generate 10 more and add them to the suggestions list.
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      }
    );
  }

  // Display will be managed by RandomWordsState, which makes it easier to change the name of the route in the app bar as the user navigates from one screen to another in the next step.
  @override
  Widget build(BuildContext context) {
    // Add the icon and its corresponding action to the build method
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}