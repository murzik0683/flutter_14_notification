import 'package:flutter/material.dart';
import 'package:flutter_14_notification/local_notification_service.dart';
import 'package:flutter_14_notification/second_screen.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late final LocalNotificationService service;

  @override
  void initState() {
    super.initState();
    service = LocalNotificationService();
    service.initialize();
    listenToNotification();

    service.showScheduleNotification(
      id: 5,
      name: 'Добро пожаловать!',
      body: '',
      seconds: 3,
    );
    service.showDailyNotification(
      context,
      id: 6,
      name: 'Ежедневное напоминание',
      body: 'Выделить полчаса на занятия программированием',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
            child: SizedBox(
          height: 400,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.extended(
                    onPressed: () {
                      service.showNotification(
                        id: 0,
                        name: 'Простое уведомление по нажатию на кнопку',
                        //body: 'Пора пить чай',
                      );
                    },
                    heroTag: 1,
                    icon: const Icon(Icons.notifications),
                    label: const Text('Простое уведомление Show'),
                    backgroundColor: Colors.purple.shade200),
                FloatingActionButton.extended(
                    onPressed: () {
                      service.showScheduleNotification(
                          id: 1,
                          name: 'Вы нажали кнопку 5 секунд назад',
                          //body: '',
                          seconds: 5);
                    },
                    heroTag: 2,
                    label: const Text('Duration 5 sec zonedSchedule'),
                    backgroundColor: Colors.purple.shade300),
                FloatingActionButton.extended(
                  onPressed: () {
                    service.showHourlyNotification(
                        id: 2,
                        name: 'Напоминание каждый час',
                        body:
                            'Ты помнишь, что нужно заняться программированием?');
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          backgroundColor: const Color(0xFFF2D7F6),
                          title: const Text('Напоминание каждый час'),
                          content: const Text(
                            ' "Ты помнишь, что нужно заняться программированием?" ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.purple,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'ОК',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  heroTag: 3,
                  label: const Text('Напоминание каждый час periodicallyShow'),
                  backgroundColor: Colors.purple.shade400,
                ),
                FloatingActionButton.extended(
                    onPressed: () {
                      service.showNotificationWithDetails(
                          id: 3,
                          name: 'Нажми сюда!',
                          body: '',
                          payload: 'Пора кормить котенка!');
                    },
                    heroTag: 4,
                    label: const Text('Уведомление с переходом payLoad'),
                    backgroundColor: Colors.purple.shade500),
                FloatingActionButton.extended(
                    onPressed: () {
                      service.showNotificationsDailyAt8Time(
                        id: 7,
                        name: 'Запланированное уведомление',
                        body: 'Пора заняться спортом!!!',
                      );
                      final snackBar = SnackBar(
                          content: const Text(
                            'Напоминание на 8 утра запланировано!',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.purple.shade600);
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    },
                    heroTag: 5,
                    icon: const Icon(Icons.notifications_active),
                    label: const Text('Уведомление на 8 утра'),
                    backgroundColor: Colors.purple.shade700),
                FloatingActionButton.extended(
                    onPressed: () {
                      service.showNotificationsDailyAtChosenTime(context,
                          id: 9,
                          name: 'Напоминание на выбранное время',
                          body: 'Вспомни, что нужно сделать!))');
                    },
                    heroTag: 7,
                    label: const Text('Выбери время для уведомления'),
                    backgroundColor: Colors.purple.shade800),
                FloatingActionButton.extended(
                  onPressed: () {
                    service.deleteNotification();
                  },
                  label: const Text('Удалить все уведомления'),
                  heroTag: 6,
                  backgroundColor: Colors.red,
                ),
              ]),
        )),
      )),
    );
  }

  void listenToNotification() {
    service.onNotificationClick.stream.listen(onNotificationListener);
  }

  void onNotificationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      print('payload $payload');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => SecondScreen(payload: payload))));
    }
  }
}
