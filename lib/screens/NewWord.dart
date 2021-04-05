import 'package:flutter/material.dart';

class NewWord extends StatefulWidget {
  NewWord({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NewWord createState() => _NewWord();
}

class _NewWord extends State<NewWord> {
  final TextEditingController _controller = TextEditingController();

  void _saveWord() {
    Navigator.pop(context, _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Add new word',
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                  hintText: 'Type something', labelText: 'Text Field '
              ),
            ),
            ElevatedButton(
              onPressed: _saveWord,
              child: Text('Save'))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
