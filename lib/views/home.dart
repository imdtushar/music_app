import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/const/colors.dart';
import 'package:music_app/const/text_style.dart';
import 'package:music_app/controller/payer_controller.dart';
import 'package:music_app/views/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends GetView<PlayerController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PlayerController());
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        backgroundColor: bgDarkColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: whiteColor,
            ),
          ),
        ],
        leading: const Icon(Icons.sort_rounded, color: whiteColor),
        title: Text(
          "Music Pro",
          style: ourStyle(
            color: whiteColor,
            size: 18,
            weight: bold,
          ),
        ),
      ),
      body: Obx(
        () => controller.hasPermission.value == false
            ? noAccessToLibraryWidget()
            : FutureBuilder<List<SongModel>>(
                future: controller.audioQuery.querySongs(
                  ignoreCase: false,
                  orderType: OrderType.ASC_OR_SMALLER,
                  sortType: null,
                  uriType: UriType.EXTERNAL,
                ),
                builder: (context, snapshot) {
                  print("Data Found ${snapshot.error}");
                  if (snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No Song Found",
                        style: ourStyle(),
                      ),
                    );
                  } else {
                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 5,
                        );
                      },
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(12.0),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor: bgColor,
                          title: Text(
                            '${snapshot.data?[index].displayNameWOExt}',
                            style: ourStyle(
                              weight: bold,
                              size: 15,
                            ),
                          ),
                          subtitle: Text(
                            '${snapshot.data?[index].artist}',
                            style: ourStyle(
                              weight: regular,
                              size: 12,
                            ),
                          ),
                          leading: QueryArtworkWidget(
                            id: snapshot.data![index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: const Icon(
                              Icons.music_note,
                              color: whiteColor,
                              size: 32,
                            ),
                          ),
                          trailing: controller.platIndex.value == index &&
                                  controller.isPlaying.value
                              ? const Icon(
                                  Icons.play_arrow,
                                  color: whiteColor,
                                  size: 26,
                                )
                              : null,
                          onTap: () {
                            Get.to(
                              () => Player(data: snapshot.data![index]),
                            );
                            controller.playSong(
                                snapshot.data![index].uri, index);
                          },
                        );
                      },
                    );
                  }
                },
              ),
      ),
    );
  }

  Widget noAccessToLibraryWidget() {
    return Material(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.redAccent.withOpacity(0.5),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Application doesn't have access to the library"),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () =>
                    controller.checkAndRequestPermissions(retry: true),
                child: const Text("Allow"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
