
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

typedef MqttClientBuilderCallback = Widget Function(
    BuildContext context,
    MqttServerClient client,
    );

// Server Initialization Widget
class MqttServerInitializeWrapper extends StatefulWidget {
  final int? port;
  final String? address;
  final void Function(String)? onError;
  final void Function()? onSuccess;
  final MqttClientBuilderCallback builder;

  const MqttServerInitializeWrapper({
    Key? key,
    this.port,
    this.address,
    this.onError,
    this.onSuccess, required this.builder,
  }) : super(key: key);

  @override
  State<MqttServerInitializeWrapper> createState() => _MqttServerInitializeWrapperState();
}

class _MqttServerInitializeWrapperState extends State<MqttServerInitializeWrapper> {

  final client = MqttServerClient('192.168.1.44', 'flutter_client');

  bool _isInitialized = false;

  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
   if(!(client.connectionStatus?.state == MqttConnectionState.connecting || client.connectionStatus?.state == MqttConnectionState.connected)) _connectToMqttBroker();
  }

  Future<({bool status, String message})> _connectToMqttBroker() async {
    client.port = 1883;
    client.setProtocolV311();
    client.logging(on: false);
    client.onDisconnected = () {
      // If already disposed, skip
      if (_isDisposed) return;

      // if(mounted) {
      //   setState(() {
      //   _isInitialized = false;
      // });
      // }
    };
    client.onConnected = () {
     // setState(() {
     //   _isInitialized = true;
     // });
    };

    try {
     var status = await client.connect();

     if(status == null) return (status : false, message: 'Unable to figure out the status');

      switch(status.state){
        case MqttConnectionState.disconnecting:
          return (status : false, message: 'Disconnecting');
        case MqttConnectionState.disconnected:
          return (status : false, message: 'Disconnected');
        case MqttConnectionState.connecting:
          return (status : false, message: 'Connecting');
        case MqttConnectionState.connected:
          return (status : true, message: 'Connected');
        case MqttConnectionState.faulted:
          return (status : false, message: 'Faulted');
      }
    } catch (e) {
      client.disconnect();
      return (status : false, message: 'Exception : ${e.toString()}');
    }
  }

  @override
  void dispose() {
    client.disconnect();
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? widget.builder(context, client) :  FutureBuilder<({bool status, String message})>(
      future: _connectToMqttBroker(), // Server is initialized in initState
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;

          if(data != null && (data.status || _isInitialized)){
            return widget.builder(context, client);
          }else {
            return Center(
              child: Text('${data?.message}'),
            );
          }
        }else{
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}