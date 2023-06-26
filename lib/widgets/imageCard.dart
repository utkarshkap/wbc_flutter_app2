import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:sizer/sizer.dart';
import 'package:wbc_connect_app/resources/colors.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({Key? key, required this.file, required this.deleteCallback})
      : super(key: key);

  final ImageFile file;
  final Function(ImageFile file) deleteCallback;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      children: [
        Positioned.fill(
          child: Container(
            height: 10.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: !file.hasPath
                  ? Image.memory(
                      file.bytes!,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Text('No Preview'));
                      },
                    )
                  : Image.file(
                      File(file.path!),
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: InkWell(
            excludeFromSemantics: true,
            onLongPress: () {},
            child: Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: colorWhite, borderRadius: BorderRadius.circular(8)),
                child: Icon(
                  Icons.close,
                  size: 4.w,
                  color: colorText7070,
                )),
            onTap: () {
              deleteCallback(file);
            },
          ),
        ),
      ],
    );
  }
}
