import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../blocs/fetchingData/fetching_data_bloc.dart';
import '../../resources/resource.dart';
import '../../widgets/appbarButton.dart';
import '../../widgets/video_player/youtubeView.dart';

class MunafeKiClassScreen extends StatefulWidget {
  static const route = '/Munafe-Ki-Class';

  const MunafeKiClassScreen({Key? key}) : super(key: key);

  @override
  State<MunafeKiClassScreen> createState() => _MunafeKiClassScreenState();
}

class _MunafeKiClassScreenState extends State<MunafeKiClassScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: colorBG,
        appBar: AppBar(
          toolbarHeight: 8.h,
          backgroundColor: colorWhite,
          elevation: 6,
          shadowColor: colorTextBCBC.withOpacity(0.3),
          leadingWidth: 15.w,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Image.asset(icBack, color: colorRed, width: 6.w)),
          titleSpacing: 0,
          title: Text('Munafe ki Class', style: textStyle14Bold(colorBlack)),
          actions: [
            AppBarButton(
                splashColor: colorWhite,
                bgColor: colorF3F3,
                icon: icNotification,
                iconColor: colorText7070,
                onClick: () {}),
            SizedBox(width: 5.w)
          ],
        ),
        body: BlocConsumer<FetchingDataBloc, FetchingDataState>(
          listener: (context, state) {
            if (state is MunafeKiClassErrorState) {
              AwesomeDialog(
                btnCancelColor: colorRed,
                padding: EdgeInsets.zero,
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.rightSlide,
                headerAnimationLoop: false,
                title: 'Something Went Wrong',
                btnOkOnPress: () {},
                btnOkColor: Colors.red,
              ).show();
            }
          },
          builder: (context, state) {
            if (state is MunafeKiClassInitial) {
              return Center(
                child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                        color: colorRed, strokeWidth: 0.7.w)),
              );
            } else if (state is MunafeKiClassLoadedState) {
              return state.munafeKiClass.list.isEmpty
                  ? Center(
                  child: Text('No Data Available',
                      style: textStyle13Medium(colorBlack)))
                  : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 0),
                    child: Column(
                      children: List.generate(
                        state.munafeKiClass.list.length,
                            (index) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          child: Container(
                            decoration: decoration(),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 27.h,
                                  width: 90.w,
                                  child: ClipRRect(
                                    borderRadius:
                                    const BorderRadius.vertical(
                                        top: Radius.circular(10)),
                                    child: YoutubeVideoPlayer(
                                      key: ObjectKey(state.munafeKiClass
                                          .list[index].video),
                                      controller: YoutubePlayerController(
                                          initialVideoId: state
                                              .munafeKiClass
                                              .list[index]
                                              .video,
                                          flags: const YoutubePlayerFlags(
                                              autoPlay: false,
                                              enableCaption: false,
                                              showLiveFullscreenButton:
                                              false)),
                                      bufferIndicator: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child:
                                          CircularProgressIndicator(
                                              color: colorRed,
                                              strokeWidth: 0.7.w)),
                                      bottomActions: [
                                        CurrentPosition(),
                                        SizedBox(width: 2.w),
                                        ProgressBar(
                                            isExpanded: true,
                                            colors: ProgressBarColors(
                                                backgroundColor:
                                                colorWhite,
                                                bufferedColor: colorRed
                                                    .withOpacity(0.5))),
                                        SizedBox(width: 2.w),
                                        RemainingDuration(),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 2.h),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          state.munafeKiClass.list[index]
                                              .title,
                                          style: textStyle11Bold(
                                              colorBlack)),
                                      const SizedBox(height: 5),
                                      Text(
                                          state.munafeKiClass.list[index]
                                              .description,
                                          style: textStyle9(colorText7070)
                                              .copyWith(height: 1.2)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ));
            }
            return Center(
              child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                      color: colorRed, strokeWidth: 0.7.w)),
            );
          },
        ),
      ),
    );
  }

  BoxDecoration decoration() {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: colorTextBCBC.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 6))
        ]);
  }
}
