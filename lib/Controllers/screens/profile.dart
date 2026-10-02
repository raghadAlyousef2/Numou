import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../Controllers/firebase_data_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<FirebaseDataController>();

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          leading: Obx(() => controller.isOnline.value
              ? const Icon(
                  Icons.wifi,
                  color: Colors.green,
                )
              : const Icon(Icons.signal_wifi_connected_no_internet_4)),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _showAvatarPopup(controller);
                },
                child: CachedNetworkImage(
                  errorWidget: (context,url,error)=>const Icon(Icons.person,size: 180,),
                  progressIndicatorBuilder:  (context,url,downlaodProgress)=>CircularProgressIndicator(value: downlaodProgress.progress,),
                  imageUrl: controller.user.value.profileImageUrl??'',
                  imageBuilder:(context,imageProvider)=> CircleAvatar(
                    radius: 150,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: imageProvider
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                controller.user.value.name,
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                controller.user.value.email,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Text(
                "Account type: ${controller.user.value.isOwner == 'true' ? 'Owner' : 'Member'}",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              if (controller.user.value.isOwner == 'true')
                Text(
                  "Member Share Code: ${controller.user.value.shareCode}",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(children: [
                  const TextSpan(text: 'Status:   ',style: TextStyle(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: controller.isOnline.value ? 'Online' : 'Offline',
                      style: TextStyle(
                        fontSize: 20,
                          color: controller.isOnline.value
                              ? Colors.green
                              : Colors.red))
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showAvatarPopup(FirebaseDataController controller) {
    Get.dialog(
      Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            controller.user.value.profileImageUrl == null
                ? const Icon(Icons.person, size: 350)
                : controller.user.value.profileImageUrl!.isEmpty
                    ? const Icon(Icons.person, size: 350)
                    : CachedNetworkImage(
                        imageUrl:
                        controller.user.value.profileImageUrl ?? '',
                        progressIndicatorBuilder:  (context,url,downloadProgress)=>  Center(child: CircularProgressIndicator(value: downloadProgress.progress,),),
                        errorWidget: (context,url,error)=>const Icon(Icons.error),
                        height: 300,
                      ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      _pickImageSource(controller); // Show image source options
                    },
                    child: const Icon(Icons.edit),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Icon(Icons.close),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      _deleteProfileImage(controller);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Icon(Icons.delete),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // New method: Show image source options (camera or gallery)
  void _pickImageSource(FirebaseDataController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back(); // Close the dialog
                _pickImageFromSource(controller, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back(); // Close the dialog
                _pickImageFromSource(controller, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Pick image from camera or gallery and upload to Firebase
  Future<void> _pickImageFromSource(
      FirebaseDataController controller, ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _showSavePopup(controller); // Show save/close popup
    }
  }

  // Show popup after selecting an image
  void _showSavePopup(FirebaseDataController controller) {
    Get.dialog(
      Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        fit: BoxFit.scaleDown,
                      )
                    : const Icon(Icons.person, size: 150),
              ),
            ),
            const SizedBox(height: 20),
            if (_isUploading)
              const CircularProgressIndicator() // Show progress indicator while uploading
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        _uploadImage(controller); // Start upload
                      },
                      child: const Text("Save"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text("Close"),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Upload image to Firebase Storage with progress indicator
  Future<void> _uploadImage(FirebaseDataController controller) async {
    setState(() {
      _isUploading = true; // Start loading
    });

    Get.dialog(
      const Center(
          child: SizedBox(
        height: 50,
        child: CircularProgressIndicator(),
      )),
    );
    try {
      String imageUrl =
          await _uploadImageToFirebase(controller.user.value.userId);
      //print( 'image url $imageUrl');
      await controller.updateProfileImageUrl(imageUrl);
      Get.back(); // Close the dialog after successful upload
      Get.snackbar('Success', 'Profile image updated');
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to upload image');
    } finally {
      setState(() {
        _isUploading = false; // Stop loading
      });
    }
  }

  // Upload image to Firebase Storage
  Future<String> _uploadImageToFirebase(String userId) async {
    try {
      Reference storageRef = _storage.ref().child('profile_images/$userId.jpg');
      print('storige regrence ${storageRef.fullPath}');
      if (_imageFile == null) {
        throw Exception('image is empty');
      }
      UploadTask uploadTask = storageRef.putFile(_imageFile!);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      // Get.snackbar('Error', 'Failed to upload image');
      rethrow;
    }
  }

  // Delete profile image
  Future<void> _deleteProfileImage(FirebaseDataController controller) async {
    try {
      Get.dialog(
        const Center(
            child: SizedBox(
          height: 50,
          child: CircularProgressIndicator(),
        )),
      );
      Reference storageRef = _storage
          .ref()
          .child('profile_images/${controller.user.value.userId}.jpg');
      await storageRef.delete();
      await controller.updateProfileImageUrl(null);
      Get.back();
      setState(() {});

      Get.snackbar('Success', 'Profile image deleted');
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to delete profile image');
    }
  }
}
