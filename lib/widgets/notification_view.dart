import 'package:battery_plugin/bloc/notification_bloc.dart';
import 'package:battery_plugin/bloc/notification_events.dart';
import 'package:battery_plugin/bloc/notification_state.dart';
import 'package:battery_plugin/model/notification_storage.dart';
import 'package:battery_plugin/model/notification_model.dart';
import 'package:battery_plugin/src/bloc_provider.dart';
import 'package:battery_plugin/widgets/notification_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final db = NotificationStorage.instance;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
            backgroundColor: Colors.white,
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
                icon: Icon(
                  Icons.settings,
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
            child: Container(
              color: Colors.white,
              child: StreamBuilder<NotificationState>(
                  stream: BlocProvider.of<NotificationBloc>(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.widgetState !=
                          NotificationWidgetState.error) {
                        List<NotificationModel> data =
                            snapshot.data.notifications;
                        if (data == null || data?.length == 0) {
                          return buildNoNotifications(context);
                        }

                        return Column(
                          children: List.generate(
                            data.length,
                            (int index) {
                              String time = DateTime.now()
                                  .difference(
                                      DateTime.fromMillisecondsSinceEpoch(1000 *
                                          int.parse(data[index].created)))
                                  .inMinutes
                                  .toString();
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    height: 300,
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      image: DecorationImage(
                                        fit: BoxFit.fitWidth,
                                        image: NetworkImage(
                                          data[index].image,
                                          scale: 1,
                                        ),
                                      ),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        BlocProvider.of<NotificationBloc>(
                                                context)
                                            .add(
                                          RemoveNotification(
                                              notification: data[index]),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.delete_forever,
                                        size: 40,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    data[index].id,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 5),
                                    child: Text(
                                      data[index].title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    data[index].body,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    "$time minutes ago",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 2,
                                    height: 50,
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      }
                      return Text("ERROR");
                    }
                    return Text("ERROR");
                  }),
            ),
          ),
        )
      ],
    );
  }

  Container buildNoNotifications(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
  }
}
