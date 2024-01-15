import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  List<Item> _data = generateItems();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
      ),
      body: SingleChildScrollView(
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _data[index].isExpanded = !isExpanded;
            });
          },
          children: _data.map<ExpansionPanel>((Item item) {
            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(item.headerValue),
                );
              },
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(item.expandedValue),
              ),
              isExpanded: item.isExpanded,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class Item {
  Item({
    required this.headerValue,
    required this.expandedValue,
    this.isExpanded = false,
  });

  String headerValue;
  String expandedValue;
  bool isExpanded;
}

List<Item> generateItems() {
  return [
    Item(
      headerValue: 'Da li je aplikacija konacna?',
      expandedValue: 'Ne, aplikacija nije konacna i ne bi trebala da se koristi u stvarnom svetu. Aplikacija je namenjena da bude rad na zadatu temu na fakultetu kao predispitna obaveza.',
    ),
    Item(
      headerValue: 'Da li neko moze da hakuje aplikaciju?',
      expandedValue: 'Podaci aplikacije se cuvaju u cloudu. Podaci bi trebali da budu sigurni.',
    ),
    Item(
      headerValue: 'Koji je techstack?',
      expandedValue: 'Flutter/Dart, Firebase i Material UI.',
    ),
    Item(
      headerValue: 'Da li ce aplikacija ostati na App Store-u?',
      expandedValue: 'Nece, bice skinuta posle mesec dana.',
    ),
    Item(
      headerValue: 'Koje verzije androida mogu da koriste ovu aplikaciju?',
      expandedValue: 'Samo moderne verzije (28 - 33).',
    ),
  ];
}
