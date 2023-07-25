import 'dart:developer';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  RxBool hasPermission = false.obs;
  final audioPlayer = AudioPlayer();
  var platIndex = 0.obs;
  var isPlaying = false.obs;
  var duration = ''.obs;
  var position = ''.obs;

  @override
  void onInit() {
    super.onInit();
    LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    audioQuery.setLogConfig(logConfig);
    checkAndRequestPermissions();
    checkPermission();
  }

  updatePosition() {
    audioPlayer.durationStream.listen((d) {
      duration.value = d.toString().split(".")[0];
    });
    audioPlayer.positionStream.listen((p) {
      position.value = p.toString().split(".")[0];
    });
  }

  checkAndRequestPermissions({bool retry = false}) async {
    hasPermission.value = await audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    hasPermission.value;
    update();
  }

  playSong(String? uri, index) {
    platIndex.value = index;
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
      isPlaying(true);
      updatePosition();
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  checkPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      var result = await Permission.storage.request();
      if (result.isGranted) {
      } else {
        checkPermission();
      }
    } else {
      checkPermission();
    }
    update();
  }
}
