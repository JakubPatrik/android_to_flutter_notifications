import 'dart:io';

import 'package:battery_plugin/bloc/notification_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationSettings extends StatefulWidget {
  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  static const platform = MethodChannel('battery_plugin/channel');

  Future<void> _showNotificationCenter() async {
    try {
      await platform.invokeMethod('showNotificationCenter');
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  Future<void> _subscribeToTopic(String topic) async {
    try {
      await platform.invokeMethod('subscribeToTopic', {"topic": topic});
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  Future<void> _unsubscribeFromTopic(String topic) async {
    try {
      await platform.invokeMethod('_unsubscribeFromTopic', {"topic": topic});
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  bool _allowNotifications = false;

  final kText = TextStyle(
    color: Colors.black,
    fontSize: 17,
    fontWeight: FontWeight.w700,
  );

  List<String> texts = [
    "Zlavy a vypredaje",
    "Novinky",
    "Specialne pre vas",
    "Tovar na sklade"
  ];

  final String os = Platform.isAndroid ? "Android" : "iOS";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            leading: GestureDetector(
              child: Icon(
                Icons.keyboard_backspace,
                color: Colors.black,
              ),
              onTap: () => Navigator.pop(context),
            ),
            automaticallyImplyLeading: false,
            largeTitle: Text(
              "Notifikacie",
              textAlign: TextAlign.left,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: Color.fromRGBO(234, 235, 237, 0.7),
                height: 40,
              ),
              buildSwitchTile(
                "Povolit notifikacie",
                "",
                () => _subscribeToTopic("topic"),
                () => _unsubscribeFromTopic("topic"),
                _allowNotifications,
              ),
              Container(
                  color: Color.fromRGBO(12, 158, 242, 0.2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 25,
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "You’ll need to opt in into notification through the $os Settings app to recieve notifications on Topankovo app.",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              GestureDetector(
                                onTap: () => _showNotificationCenter(),
                                child: Text(
                                  "Go to Settings",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff0c9ef2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ])),
              ...List.generate(
                4,
                (index) => buildSwitchTile(
                  texts[index],
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit aliquet commodo",
                  () {},
                  () {},
                  _allowNotifications,
                ),
              ),
              StreamBuilder(
                  stream: NotificationsBloc.instance.notificationStream,
                  builder: (context, snapshot) {
                    return Container(
                      child: Text(
                          snapshot.hasData ? snapshot.data.toString() : ""),
                    );
                  })
            ]),
          ),
        ],
      ),
    );
  }

  Container buildSwitchTile(
      String text, String desc, Function fyes, Function fno, bool show) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.label_outline,
                  size: 30,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: desc != ""
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text,
                              style: kText,
                            ),
                            Text(
                              desc,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color(0xff666666),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          text,
                          style: kText,
                        ),
                )),
                Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    onChanged: (value) async {
                      setState(() {
                        _allowNotifications = value;
                      });
                      if (value)
                        await fyes.call();
                      else
                        await fno.call();
                    },
                    value: show,
                    trackColor: Color(0xffE0E1E3),
                    activeColor: Colors.black,
                  ),
                )
              ],
            ),
          ),
          if (desc != "")
            Divider(
              height: 5,
              thickness: 1,
            ),
        ],
      ),
    );
  }
}
