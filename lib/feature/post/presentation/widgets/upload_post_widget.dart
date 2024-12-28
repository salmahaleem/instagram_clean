import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clean/core/get_it/get_it.dart' as di;
import 'package:instagram_clean/core/utils/constant.dart';
import 'package:instagram_clean/feature/post/domain/entitys/post_entity.dart';
import 'package:instagram_clean/feature/post/presentation/cubit/post_cubit.dart';
import 'package:instagram_clean/feature/user/domain/entitys/user_entity.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';

class UploadPostWidget extends StatefulWidget {
 // final UserEntity userEntity;
  const UploadPostWidget({
    Key? key,
    //required this.userEntity,
  }) : super(key: key);

  @override
  State<UploadPostWidget> createState() => _UploadPostMainWidgetState();
}

class _UploadPostMainWidgetState extends State<UploadPostWidget> {
  bool _uploading = false;
  final List<Widget> _mediaList = [];
  final List<File> _filePaths = [];
  // File? _selectedImage;
  int _currentPage = 0;
  // int? lastPage;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(
        iosAccessLevel: IosAccessLevel.readWrite,
        androidPermission: AndroidPermission(
          type: RequestType.common,
          mediaLocation: true,),
      ),
    );
    if (!ps.isAuth) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission denied!')),
      );
      PhotoManager.openSetting();
      return;
    }
      final List<AssetPathEntity> albums =
      await PhotoManager.getAssetPathList(type: RequestType.image);
      if (albums.isEmpty) return;

      final List<AssetEntity> assets =
      await albums[0].getAssetListPaged(page: _currentPage, size: 60);

      for (var asset in assets) {
        final file = await asset.file;
        if (file != null) {
          _filePaths.add(File(file.path));
          if (Constant.selectedImage == null) {
            Constant.selectedImage = _filePaths[0];
          }
        }
      }
      final List<Widget> tempMediaList = assets.map((asset) {
        return FutureBuilder(
          future: asset.thumbnailDataWithSize(ThumbnailSize(200, 200)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      }).toList();
      setState(() {
        _mediaList.addAll(tempMediaList);
        _currentPage++;
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text(
          'New Post',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: Constant.selectedImage != null
                ? () {
               context.go('/createPost');
                  }
                : null,
            child: const Text(
              'Next',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (Constant.selectedImage != null)
              SizedBox(
                height: 300.h,
                width: double.infinity,
                child: Image.file(
                  Constant.selectedImage!,
                  fit: BoxFit.cover,
                ),
              ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Recent',
                style:
                    TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: _mediaList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        Constant.selectedImage = _filePaths[index];
                      });
                    },
                    child: _mediaList[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

