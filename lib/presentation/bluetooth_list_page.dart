import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothListPage extends StatefulWidget {
  const BluetoothListPage({Key? key}) : super(key: key);

  @override
  _BluetoothListPageState createState() => _BluetoothListPageState();
}

class _BluetoothListPageState extends State<BluetoothListPage> {
  @override
  void initState() {
    super.initState();
    FlutterBlue.instance.startScan();
  }

  @override
  void dispose() {
    FlutterBlue.instance.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth'),
      ),
      body: StreamBuilder<List<ScanResult>>(
        stream: FlutterBlue.instance.scanResults,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('正在扫描中，请稍候');
          }
          final List<ScanResult> results = snapshot.data
                  ?.where((element) => element.device.name != '')
                  .toList() ??
              [];
          final List<ScanResult> nullResults = snapshot.data
                  ?.where((element) => !(element.device.name != ''))
                  .toList() ??
              [];
          results.addAll(nullResults);

          return ListView.builder(
            itemBuilder: (context, index) {
              final ScanResult result = results[index];
              final BluetoothDevice device = result.device;
              final AdvertisementData advertisement = result.advertisementData;
              var advertisement2 = advertisement;
              return DefaultTextStyle(
                style: TextStyle(
                  fontSize: 50,
                ),
                child: Card(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${"名称".padRight5()}:${device.name}'),
                        SizedBox(
                          height: 10,
                        ),
                        Text('${"ID".padRight5()}:${device.id}'),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                            '${"制造商".padRight5()}:${advertisement2.manufacturerData}'),
                        SizedBox(
                          height: 10,
                        ),
                        Text('${"RSSI".padRight5()}:${result.rssi}'),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: results.length,
          );
        },
      ),
    );
  }
}

extension StringX on String {
  String padRight5() {
    return this.padRight(5);
  }
}
