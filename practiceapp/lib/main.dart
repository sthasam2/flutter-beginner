import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Welcome to Flutter",
        theme: ThemeData(
            primaryColor: Colors.black, scaffoldBackgroundColor: Colors.white),
        home: RandomWords());
  }
}

// custom word widget widget
class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

// state of RandomWord widget
class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18);

  Widget _buildSuggestions() {
    //odd row divider
    //even row wordPair
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext _context, int i) {
        //divider
        if (i.isOdd) return Divider();

        final int index = i ~/ 2;
        // combination of wordPair and divider. So index integer division will return 0, 1,1, 2,2 ... instead of 0,1,2,3,4... thus making divider word combo

        // words generator when view index is exceeded ie the list ends in order for an infinite list. initially at 0 also builds new words
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs()
              .take(10)); // add 10 new words to _suggestions list
        }

        // word pair row build
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    // generate a tiled list of words from the words in _suggestions list and favourite icon
    return ListTile(
      title: Text(pair.asPascalCase, style: _biggerFont),
      trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red[600] : null),
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

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        final tiles = _saved.map((WordPair pair) {
          return ListTile(
            title: Text(pair.asPascalCase, style: _biggerFont),
          );
        });

        final divided = ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Saved Suggestions'),
          ),
          body: ListView(padding: EdgeInsets.all(10), children: divided),
        );
      },
    ));
  }

  // final build method
  @override
  Widget build(BuildContext context) {
    // final wordPair = WordPair.random(); //generates random word
    // return Text(wordPair.asPascalCase);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Name Generator'),
        actions: [IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)],
      ),
      body: _buildSuggestions(),
    );
  }
}
