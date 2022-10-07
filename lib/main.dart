// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'notification.dart';
import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();




void main() {
  runApp(const MyApp());
}






const simpleDelayedTask = "be.tramckrijte.workmanagerExample.simpleDelayedTask";
const simplePeriodicTask =
    "be.tramckrijte.workmanagerExample.simplePeriodicTask";
Timer? timer;

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
  
     
     
      case simpleDelayedTask:
        Notif.showBigTextNotification(title: "New message title", body: "Arka planda çalıştı", fln: flutterLocalNotificationsPlugin);
        break;
      case simplePeriodicTask:
         Notif.showBigTextNotification(title: "New message title", body: "Arka planda çalıştı", fln: flutterLocalNotificationsPlugin);
         
        break;
      
      case Workmanager.iOSBackgroundTask:
        print("The iOS background fetch was triggered");
        Directory? tempDir = await getTemporaryDirectory();
        String? tempPath = tempDir.path;
        print(
            "You can access other plugins in the background, for example Directory.getTemporaryDirectory(): $tempPath");
        break;
    }

    return Future.value(true);
  });
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
  
      home:  MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



@override
  void initState() {
   
    super.initState();
        Notif.initialize(flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
      
        title: Text(widget.title),
      ),
      body:  Padding(
        padding:  const EdgeInsets.all(40.0),
        child:  Column(
          children: [
            Center(
            child: ElevatedButton(
              onPressed: (){
                Notif.showBigTextNotification(title: "New message title", body: "Your long body", fln: flutterLocalNotificationsPlugin);
              
              },
              child: const Text('Notification Gönder'),),
     
            ),
         ElevatedButton(
                  child: const Text("Start the Flutter background service"),
                  onPressed: () {
                    Workmanager().initialize(
                      callbackDispatcher,
                      isInDebugMode: true,
                    );
                  },
                ),
                const SizedBox(height: 16),

                //This task runs once.
                //Most likely this will trigger immediately
                
                
              
                //This task runs once
                //This wait at least 10 seconds before running
                ElevatedButton(
                    child: const Text("Register Delayed OneOff Task"),
                    onPressed: () {
                      Workmanager().registerOneOffTask(
                        simpleDelayedTask,
                        simpleDelayedTask,
                        initialDelay: const Duration(seconds: 100),
                      );
                    }),
                const SizedBox(height: 8),
                //This task runs periodically
                //It will wait at least 10 seconds before its first launch
                //Since we have not provided a frequency it will be the default 15 minutes
                ElevatedButton(
                    onPressed: Platform.isAndroid
                        ? () {
                            Workmanager().registerPeriodicTask(
                              simplePeriodicTask,
                              simplePeriodicTask,
                              initialDelay: const Duration(seconds: 5),
                            );
                          }
                        : null,
                    child: const Text("Register Periodic Task (Android)")),
                //This task runs periodically
                //It will run about every hour
               
                const SizedBox(height: 16),
                Text(
                  "Task cancellation",
                  style: Theme.of(context).textTheme.headline5,
                ),
                ElevatedButton(
                  child: const Text("Cancel All"),
                  onPressed: () async {
                    await Workmanager().cancelAll();
                    print('Cancel all tasks completed');
                  },
                ),
          ],
        ),
      ),
   
    );
  }
}
