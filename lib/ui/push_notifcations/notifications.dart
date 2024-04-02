import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/ui/push_notifcations/firebase_push_notifications.dart';
import 'package:sample_latest/widgets/custom_app_bar.dart';

class NotificationWithRemoteAndLocal extends StatefulWidget {

  final Widget child;

  const NotificationWithRemoteAndLocal(this.child, {super.key});

  @override
  State<NotificationWithRemoteAndLocal> createState() => _NotificationWithRemoteAndLocalState();
}

class _NotificationWithRemoteAndLocalState extends State<NotificationWithRemoteAndLocal> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: const Text('Push Notifications'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
                height: 100,
                child: BottomNavigationBar(
                    currentIndex: selectedIndex,
                    onTap: (index){
                     setState(() {
                       selectedIndex = index;
                     });
        
                     if(selectedIndex == 0) {
                       GoRouter.of(context).push(
                           '/home/push-notifications/remote-notifications');
                     }else{
                       GoRouter.of(context).push(
                           '/home/push-notifications/local-notifications');
                     }
                    },
                    items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.notification_add), label: 'Remote Notifications'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.notification_add_outlined), label: 'Local Notifications')
                ])),
            Expanded(child: widget.child)
          ],
        ),
      ),
    );
  }
}
