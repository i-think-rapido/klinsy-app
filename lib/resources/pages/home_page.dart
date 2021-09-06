import 'package:Klinsy/app/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nylo_support/helpers/helper.dart';
import 'package:nylo_support/widgets/ny_state.dart';
import 'package:nylo_support/widgets/ny_stateful_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaml/yaml.dart';

class MyHomePage extends NyStatefulWidget {
  final HomeController controller = HomeController();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends NyState<MyHomePage> {
  String version = 'no version';

  _MyHomePageState() {
    rootBundle.loadString('pubspec.yaml').then((String yaml) {
      setState(() {
        version = loadYaml(yaml)['version'];
      });
    });
  }

  @override
  widgetDidLoad() async {}

  @override
  Widget build(BuildContext context) {
    widget.controller.construct(context);

    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              trans(context, getEnv("SHORT_DESCRIPTION"))!,
              style: Theme.of(context).accentTextTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
            Image.asset(
              getImageAsset("nylo_logo.png"),
              height: 100,
              width: 100,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Divider(),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 9,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      MaterialButton(
                        child: Text(
                          trans(context, "todos")!.capitalize(),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        onPressed: widget.controller.onTapShowTodos,
                      ),
                      Divider(
                        height: 0,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          shape: BoxShape.circle,
                        ),
                        width: 40,
                        child: IconButton(
                            onPressed: widget.controller.onTapNewTask,
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).buttonColor,
                            )),
                      ),
                      Divider(
                        height: 0,
                      ),
                      MaterialButton(
                        child: Text(
                          trans(context, "active")!.capitalize(),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        onPressed: widget.controller.onTapShowActive,
                      ),
                      Divider(
                        height: 0,
                      ),
                      MaterialButton(
                        child: Text(
                          trans(context, "archive")!.capitalize(),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        onPressed: widget.controller.onTapShowArchive,
                      ),
                    ],
                  ),
                ),
                Text(
                  version,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.grey),
                ),
                ElevatedButton(
                  onPressed: () => launch(
                      'https://github.com/i-think-rapido/klinsy-app/blob/main/privacy-policy.md'),
                  child: Text(trans(context, 'privacy policy')!),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).accentColor,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                  child: Text(trans(context, 'settings')!),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).accentColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
