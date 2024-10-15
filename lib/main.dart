import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Matching Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Card Matching Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class CardModel {
  final String frontImage;
  bool isFaceUp;

  CardModel({required this.frontImage, this.isFaceUp = false});
}

class _MyHomePageState extends State<MyHomePage> {
  List<CardModel> _cards = [];
  int _matchesFound = 0;
  int? _firstCardIndex;
  int? _secondCardIndex;
  final String backImage = 'assets/back.jpg'; // Image for the back of the card

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // Create a list of 8 unique images, and duplicate each one for a pair
    List<String> images = [
      'assets/Kobe.jpg',
      'assets/Shaq.jpg',
      'assets/Kyrie.jpg',
      'assets/Lebron.jpg',
      'assets/Curry.jpg',
      'assets/Paul.jpg',
      'assets/Victor.jpg',
      'assets/Tatum.jpg',
      'assets/Kobe.jpg',
      'assets/Shaq.jpg',
      'assets/Kyrie.jpg',
      'assets/Lebron.jpg',
      'assets/Curry.jpg',
      'assets/Paul.jpg',
      'assets/Victor.jpg',
      'assets/Tatum.jpg',
    ];
    images.shuffle(); // Shuffle the list to randomize the card positions
    _cards = images.map((image) => CardModel(frontImage: image)).toList();
    _matchesFound = 0;
    _firstCardIndex = null;
    _secondCardIndex = null;
  }

  void _flipCard(int index) {
    setState(() {
      if (_firstCardIndex == null) {
        _firstCardIndex = index;
        _cards[index].isFaceUp = true;
      } else if (_secondCardIndex == null) {
        _secondCardIndex = index;
        _cards[index].isFaceUp = true;
        _checkForMatch();
      }
    });
  }

  void _checkForMatch() {
    if (_firstCardIndex != null && _secondCardIndex != null) {
      if (_cards[_firstCardIndex!].frontImage ==
          _cards[_secondCardIndex!].frontImage) {
        // Match found, keep the cards face-up
        _matchesFound += 1;
        _resetSelection();
      } else {
        // No match, flip the cards back down after a short delay
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _cards[_firstCardIndex!].isFaceUp = false;
            _cards[_secondCardIndex!].isFaceUp = false;
            _resetSelection();
          });
        });
      }
    }
  }

  void _resetSelection() {
    _firstCardIndex = null;
    _secondCardIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Matches found:',
            ),
            Text(
              '$_matchesFound',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4x4 grid
                ),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (!_cards[index].isFaceUp &&
                          _firstCardIndex != index &&
                          _secondCardIndex != index) {
                        _flipCard(index);
                      }
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: _cards[index].isFaceUp
                          ? Image.asset(
                              _cards[index].frontImage,
                              key: ValueKey(_cards[index].frontImage),
                            ) // Show the front image if face-up
                          : Image.asset(
                              backImage,
                              key: ValueKey(backImage),
                            ), // Show the back of the card if face-down
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _initializeGame();
          });
        },
        tooltip: 'Restart',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
