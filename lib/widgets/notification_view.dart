import 'package:battery_plugin/model/notification_storage.dart';
import 'package:battery_plugin/model/notification_model.dart';
import 'package:battery_plugin/widgets/notification_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class NotificationView extends StatefulWidget {
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  static const String _table = "notificationTable";
  Database db;

  @override
  void initState() {
    NotificationStorage().initialize();
    db = NotificationStorage().db;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
            leading: IconButton(
              icon: Icon(
                CupertinoIcons.back,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            expandedHeight: 90,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: 20,
                bottom: 0,
              ),
              title: Text(
                "Notifikácie",
                style: TextStyle(
                  fontSize: 28 / 1.5,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            pinned: true,
            elevation: 0,
            actions: [
              IconButton(
                icon: Image.asset(
                  'assets/icons/settings.png',
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => NotificationSettings(),
                    ),
                  );
                },
              ),
              SizedBox(
                width: 8,
              ),
            ]),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          sliver: SliverToBoxAdapter(
            child: FutureBuilder<List<Map<String, dynamic>>>(
                future: db.query("$_table"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<NotificationModel> data;
                    snapshot.data.forEach((element) {
                      data.add(NotificationModel.fromJson(element));
                    });
                    return ListView(
                      children: List.generate(
                        data.length,
                        (int index) => Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    data[index].title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    data[index].body,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Image.network(
                                    data[index].image,
                                    errorBuilder:
                                        (context, error, stackTrace) => Text(
                                      stackTrace.toString(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            IconButton(
                                onPressed: () {
                                  db.delete(data[index].id);
                                },
                                icon: Icon(
                                  Icons.delete_forever,
                                  size: 40,
                                  color: Colors.red,
                                )),
                          ],
                        ),
                      ),
                    );
                  } else
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Nemáte žiadne notifikácie',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey[600],
                              ),
                            ),
                          ]),
                    );
                }),
          ),
        )
      ],
    );
  }
}
