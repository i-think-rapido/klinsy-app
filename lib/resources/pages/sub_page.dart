import 'package:Klinsy/resources/widgets/safearea_widget.dart';
import 'package:flutter/material.dart';

class SubPage extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isHomeScreen;

  SubPage({Key? key, required this.title, required this.child, this.isHomeScreen = false, })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        leading: isHomeScreen ? null : IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).accentColor,
            )),
      ),
      body: SafeAreaWidget(
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
