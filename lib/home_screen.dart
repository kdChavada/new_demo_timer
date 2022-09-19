import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice_message_package/voice_message_package.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  late final RecorderController recorderController;
  late final PlayerController playerController1;
  late final PlayerController playerController2;
  late final PlayerController playerController3;
  late final PlayerController playerController4;
  late final PlayerController playerController5;
  late final PlayerController playerController6;
  String? path;
  String? musicFile;
  bool isRecording = false;
  late Directory appDirectory;

  ValueNotifier<List<String>> myVoiceData = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _getDir();
    _initialiseControllers();
  }

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    _preparePlayers();
    path = "${appDirectory.path}/music.aac";
  }

  Future<ByteData> _loadAsset(String path) async {
    return await rootBundle.load(path);
  }

  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000
      ..bitRate = 64000;
    playerController1 = PlayerController()
      ..addListener(() {
        if (mounted) setState(() {});
      });
    playerController2 = PlayerController()
      ..addListener(() {
        if (mounted) setState(() {});
      });
    playerController3 = PlayerController()
      ..addListener(() {
        if (mounted) setState(() {});
      });
    playerController4 = PlayerController()
      ..addListener(() {
        if (mounted) setState(() {});
      });
    playerController5 = PlayerController()
      ..addListener(() {
        if (mounted) setState(() {});
      });
    playerController6 = PlayerController()
      ..addListener(() {
        if (mounted) setState(() {});
      });
  }

  void _preparePlayers() async {
    ///audio-1
    final file1 = File('${appDirectory.path}/audio1.mp3');
    await file1.writeAsBytes(
        (await _loadAsset('assets/audios/audio1.mp3')).buffer.asUint8List());
    playerController1.preparePlayer(file1.path);

    ///audio-2
    final file2 = File('${appDirectory.path}/audio2.mp3');
    await file2.writeAsBytes(
        (await _loadAsset('assets/audios/audio2.mp3')).buffer.asUint8List());
    playerController2.preparePlayer(file2.path);

    ///audio-3
    final file3 = File('${appDirectory.path}/audio3.mp3');
    await file3.writeAsBytes(
        (await _loadAsset('assets/audios/audio3.mp3')).buffer.asUint8List());
    playerController3.preparePlayer(file3.path);

    ///audio-4
    final file4 = File('${appDirectory.path}/audio4.mp3');
    await file4.writeAsBytes(
        (await _loadAsset('assets/audios/audio4.mp3')).buffer.asUint8List());
    playerController4.preparePlayer(file4.path);
  }

  // void _pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //   if (result != null) {
  //     musicFile = result.files.single.path;
  //     await playerController6.preparePlayer(musicFile!);
  //   } else {
  //     debugPrint("File not picked");
  //   }
  // }

  void _disposeControllers() {
    recorderController.dispose();
    playerController1.stopAllPlayers();
    playerController2.dispose();
    playerController3.dispose();
    playerController4.dispose();
    playerController5.dispose();
    playerController6.dispose();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      _disposeControllers();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF252331),
      appBar: AppBar(
        backgroundColor: const Color(0xFF252331),
        elevation: 1,
        centerTitle: true,
        shadowColor: Colors.grey,
        title: const Text('KD'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: myVoiceData,
                  builder: (context, v, c) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: myVoiceData.value.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 70,
                                      width: w * 0.5,
                                      child: VoiceMessage(
                                        meBgColor: Colors.blue,
                                        audioSrc: myVoiceData.value[index],
                                        played: false,
                                        // To show played badge or not.
                                        me: true,
                                        // Set message side.
                                        onPlay:
                                            () {}, // Do something when voice played.
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        });
                  }),
            ),
            SafeArea(
              child: Row(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: isRecording
                        ? AudioWaveforms(
                            enableGesture: true,
                            size:
                                Size(MediaQuery.of(context).size.width / 2, 50),
                            recorderController: recorderController,
                            waveStyle: const WaveStyle(
                              waveColor: Colors.white,
                              extendWaveform: true,
                              showMiddleLine: false,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: const Color(0xFF1E1B26),
                            ),
                            padding: const EdgeInsets.only(left: 18),
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                          )
                        : Container(
                            width: w * 0.6,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1B26),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.only(left: 18),
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: const TextField(
                              style: TextStyle(color: Colors.white),
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: "Type Something...",
                                hintStyle: TextStyle(color: Colors.white54),
                                contentPadding: EdgeInsets.only(top: 16),
                                border: InputBorder.none,
                                // suffixIcon: IconButton(
                                //   onPressed: _pickFile,
                                //   icon: Icon(Icons.adaptive.share),
                                //   color: Colors.white54,
                                // ),
                              ),
                            ),
                          ),
                  ),
                  IconButton(
                    onPressed: () {
                      _refreshWave();
                      setState(() {
                        isRecording = false;
                      });
                    },
                    icon: Icon(
                      isRecording ? Icons.refresh : Icons.send,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {
                      _startOrStopRecording();
                      setState(() {
                        isRecording = false;
                      });
                    },
                    icon: Icon(isRecording ? Icons.stop : Icons.mic),
                    color: Colors.white,
                    iconSize: 28,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  void _playOrPausePlayer(PlayerController controller) async {
    controller.playerState == PlayerState.playing
        ? await controller.pausePlayer()
        : await controller.startPlayer(finishMode: FinishMode.loop);
  }

  void _startOrStopRecording() async {
    if (isRecording) {
      recorderController.reset();
      final path = await recorderController.stop(false);
      debugPrint("------------------- Record File Path ............. $path");
      myVoiceData.value.add(path!);
      myVoiceData.notifyListeners();
      isRecording = false;
      if (path != null) {
        debugPrint("Recorded file size: ${File(path).lengthSync()}");
        await playerController1.preparePlayer(path);
      }
    } else {
      await recorderController.record(path);
    }
    setState(() {
      isRecording = !isRecording;
    });
  }

  void _refreshWave() {
    isRecording = false;
    if (isRecording) recorderController.refresh();
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;

  const ChatBubble({
    Key? key,
    required this.text,
    this.isSender = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isSender) const Spacer(),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isSender
                        ? const Color(0xFF276bfd)
                        : const Color(0xFF343145)),
                padding: const EdgeInsets.only(
                    bottom: 9, top: 8, left: 14, right: 12),
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WaveBubble extends StatelessWidget {
  final PlayerController playerController;
  final VoidCallback onTap;
  final bool isSender;
  final bool isPlaying;

  const WaveBubble({
    Key? key,
    required this.playerController,
    required this.onTap,
    required this.isPlaying,
    this.isSender = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(
          bottom: 6,
          right: isSender ? 0 : 10,
          top: 6,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSender ? const Color(0xFF276bfd) : const Color(0xFF343145),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onTap,
              icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
              color: Colors.white,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            AudioFileWaveforms(
              size: Size(MediaQuery.of(context).size.width / 2, 70),
              playerController: playerController,
              density: 1.5,
              playerWaveStyle: const PlayerWaveStyle(
                scaleFactor: 0.8,
                fixedWaveColor: Colors.white30,
                liveWaveColor: Colors.white,
                waveCap: StrokeCap.butt,
              ),
            ),
            if (isSender) const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
