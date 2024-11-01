import 'package:flutter/material.dart';

class TopFiveScreen extends StatefulWidget {
  const TopFiveScreen({super.key});

  @override
  _TopFiveScreenState createState() => _TopFiveScreenState();
}

class _TopFiveScreenState extends State<TopFiveScreen> {
  final List<String> topFiveItems = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
          child: const Icon(Icons.person)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text('Top Five Items'),
      ),
      body: ListView.builder(
        itemCount: topFiveItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text(topFiveItems[index]),
          );
        },
      ),
    );
  }
}
