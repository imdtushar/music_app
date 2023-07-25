import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/const/colors.dart';
import 'package:music_app/const/text_style.dart';
import 'package:music_app/controller/payer_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends GetView<PlayerController> {
  final SongModel data;

  const Player({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    Get.put(PlayerController());
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                alignment: Alignment.center,
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: QueryArtworkWidget(
                  id: data.id,
                  type: ArtworkType.AUDIO,
                  artworkHeight: double.infinity,
                  artworkWidth: double.infinity,
                  nullArtworkWidget: const Icon(
                    Icons.music_note,
                    size: 48,
                    color: whiteColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  color: Colors.yellow,
                ),
                child: Column(
                  children: [
                    Text(
                      data.displayNameWOExt,
                      style: ourStyle(
                        color: bgDarkColor,
                        weight: bold,
                        size: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      data.artist.toString(),
                      style: ourStyle(
                        color: bgDarkColor,
                        weight: regular,
                        size: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Obx(
                      () => Row(
                        children: [
                          Text(
                            controller.position.value,
                            style: ourStyle(color: bgDarkColor),
                          ),
                          Expanded(
                            child: Slider(
                              thumbColor: sliderColor,
                              activeColor: sliderColor,
                              inactiveColor: bgColor,
                              value: 0.0,
                              onChanged: (newValue) {},
                            ),
                          ),
                          Text(
                            controller.duration.value,
                            style: ourStyle(color: bgDarkColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.skip_previous_rounded,
                            size: 40,
                            color: bgDarkColor,
                          ),
                        ),
                        Obx(()=>
                           CircleAvatar(
                            radius: 35,
                            backgroundColor: bgDarkColor,
                            child: Transform.scale(
                              scale: 2.5,
                              child: IconButton(
                                onPressed: () {
                                  if(controller.isPlaying.value){
                                    controller.audioPlayer.pause();
                                    controller.isPlaying(false);
                                  }else{
                                    controller.audioPlayer.play();
                                    controller.isPlaying(true);
                                  }
                                },
                                icon: controller.isPlaying.value
                                    ? const Icon(
                                        Icons.pause,
                                        color: whiteColor,
                                      )
                                    : const Icon(
                                        Icons.play_arrow_rounded,
                                        color: whiteColor,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.skip_next_rounded,
                            size: 40,
                            color: bgDarkColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
