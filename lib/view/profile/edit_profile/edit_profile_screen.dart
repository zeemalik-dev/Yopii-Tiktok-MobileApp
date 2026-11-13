import 'dart:developer';
import 'dart:io';

import 'package:createex_task_application/controller/providers/user_provider.dart';
import 'package:createex_task_application/cors/utils/bottom_sheet_service.dart';
import 'package:createex_task_application/model/user_model.dart';
import 'package:createex_task_application/view/profile/widgets/custom_field.dart';
import 'package:createex_task_application/widgets/custom_button.dart';
import 'package:createex_task_application/widgets/file_circle_avatar.dart';
import 'package:createex_task_application/widgets/image_picker_sheet.dart';
import 'package:createex_task_application/widgets/network_circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../cors/theme/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  final User userProfile;
  const EditProfileScreen({super.key, required this.userProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contentTypeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String profileImage = "";
  final formKey = GlobalKey<FormState>();

  File? imageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<UserProvider>();
    nameController.text = widget.userProfile.fullName;
    contentTypeController.text = widget.userProfile.contentType ?? "";
    descriptionController.text = widget.userProfile.description ?? "";
    profileImage = widget.userProfile.profileImageUrl ?? "";

    log(profileImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundScaffold,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryWhite,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 40),
        child: Builder(builder: (context) {
          var pro = context.watch<UserProvider>();
          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    spacing: 19,
                    children: [
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            imageFile == null
                                ? NetworkCircleAvatar(
                                    imageUrl: profileImage,
                                  )
                                : FileCircleAvatar(
                                    imageFile: imageFile!,
                                  ),
                            Positioned(
                              bottom: 10,
                              right: -10,
                              child: GestureDetector(
                                onTap: () async {
                                  final profileImage =
                                      await BottomSheetService.instance.show(
                                          context: context,
                                          child: ProfileImagePickerSheet());
                                  if (profileImage != null) {
                                    setState(() {
                                      imageFile = profileImage;
                                    });
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: AppColors.darkOrage,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomField(
                        label: 'Name',
                        hint: "Island Queen",
                        grow: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Name can't be empty";
                          }
                          return null;
                        },
                        controller: nameController,
                      ),
                      CustomField(
                        label: 'Content Types',
                        hint: 'influencer',
                        grow: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Content Type can't be empty";
                          }
                          return null;
                        },
                        controller: contentTypeController,
                      ),
                      CustomField(
                        label: 'Description',
                        hint:
                            "Feel free to contact me for business inquiries:   [Phone Number/Contact Details].",
                        grow: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Description can't be empty";
                          }
                          return null;
                        },
                        controller: descriptionController,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomButton(
                        text: "Save",
                        callback: () async {
                          if (formKey.currentState!.validate()) {
                            await pro.updateUserProfile(context,
                                fullName: nameController.text.trim(),
                                contentType: contentTypeController.text.trim(),
                                description: descriptionController.text.trim(),
                                profileImageUrl: profileImage,
                                imageFile: imageFile);
                          }
                        },
                        isLoading: pro.isUpdating,
                        flag: true),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
