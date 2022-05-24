import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final AgoraClient _client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: '8bc57c6c318645e7b16388000c956f88',
      channelName: 'DoctorAppointment',
    ),
  );

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    await _client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Call In Progress'),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                AgoraVideoViewer(
                  client: _client,
                  layoutType: Layout.floating,
                  showNumberOfUsers: true,
                ),
                AgoraVideoButtons(
                  client: _client,
                  enabledButtons: const [
                    BuiltInButtons.toggleCamera,
                    BuiltInButtons.callEnd,
                    BuiltInButtons.toggleMic,
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
