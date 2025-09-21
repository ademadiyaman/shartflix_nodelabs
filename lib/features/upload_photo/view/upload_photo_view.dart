import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:jr_case_boilerplate/core/constants/app_colors.dart';
import 'package:jr_case_boilerplate/core/constants/app_strings.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';
import 'package:jr_case_boilerplate/core/constants/app_paddings.dart';
import 'package:jr_case_boilerplate/core/constants/app_radius.dart';
import 'package:jr_case_boilerplate/core/constants/app_sizes.dart';
import 'package:jr_case_boilerplate/core/provider/photo_provider.dart';
import 'package:jr_case_boilerplate/core/services/api_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class UploadPhotoView extends StatefulWidget {
  const UploadPhotoView({super.key});

  @override
  State<UploadPhotoView> createState() => _UploadPhotoViewState();
}

class _UploadPhotoViewState extends State<UploadPhotoView> {
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
     SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _pickImage() async {
    final status = await Permission.photos.request(); // iOS & Android 13+
    if (status.isDenied) return;

    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  void _removeImage() => setState(() => _selectedImage = null);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient (arka plan)
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A0000), Color(0xFF000000)],
              ),
            ),
          ),
          // Shine Effect
          Positioned(
            top: -21,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/images/shine_effect.png",
              width: 310.w, // Figma Width: 310 px
              height: 208.h, // Figma Height: 208 px
              fit: BoxFit.fitHeight,
            ),
          ),

          // SafeArea
          SafeArea(
            child: Padding(
              padding: AppPaddings.page,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Üst bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: AppSizes.backBtnBox,
                          height: AppSizes.backBtnBox,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: AppRadius.br16,
                            border: Border.all(color: AppColors.white24, width: 1),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back,
                              size: AppSizes.backIcon,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'profdetay'.tr(),
                        style: AppTextStyles.profdetay,
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                  AppGaps.vh(context, 0.05),
                  Padding(
                    padding: EdgeInsets.only(top: 70.h),
                    child: Center(
                      child: Container(
                        width: AppSizes.profileBox,
                        height: AppSizes.profileBox,
                        decoration: BoxDecoration(
                          color: const Color(0xFF000000).withOpacity(0.4),
                          borderRadius: AppRadius.br24,
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/icons/profile_pic.png",
                          width: AppSizes.profileIconW,
                          height: AppSizes.profileIconH,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  AppGaps.h12,
                  Text('fotografyukle', style: AppTextStyles.yukle).tr(),
                  AppGaps.h6,
                  Text(
                    'yuklemebilgi',
                    style: AppTextStyles.yuklebilgi,
                    textAlign: TextAlign.center,
                  ).tr(),
                  AppGaps.vh(context, 0.05),
                  GestureDetector(
                    onTap: _pickImage,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(32),
                      dashPattern: const [4, 4],
                      strokeWidth: 1,
                      color: AppColors.white24,
                      child: ClipRRect(
                        borderRadius: AppRadius.br32,
                        child: Container(
                          width: AppSizes.uploadBox,
                          height: AppSizes.uploadBox,
                          padding: AppPaddings.p10,
                          decoration: const BoxDecoration(
                            color: Color(0x4D000000),
                          ),
                          child: _selectedImage == null
                              ? const Center(
                                  child: Icon(
                                    Icons.add,
                                    size: AppSizes.uploadIcon,
                                    color: Colors.white70,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: AppRadius.br24,
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),

                  if (_selectedImage != null) ...[
                    AppGaps.h10,
                    GestureDetector(
                      onTap: _removeImage,
                      child: Container(
                        width: AppSizes.closeBtn,
                        height: AppSizes.closeBtn,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 1),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/icons/xvector.png",
                            width: AppSizes.closeBtn,
                            height: AppSizes.closeBtn,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  SizedBox(
                    width: AppPaddings.uploadButtonWidth,
                    height: 56.h,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                              if (states.contains(MaterialState.disabled)) {
                                return const Color(
                                  0xFFE50914,
                                );
                              }
                              return AppColors.redButton;
                            }),
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                              if (states.contains(MaterialState.disabled)) {
                                return Colors.white.withOpacity(
                                  0.6,
                                );
                              }
                              return Colors.white;
                            }),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 32.w, vertical: 8.h),
                        ),
                      ),
                      onPressed: _selectedImage == null
                          ? null
                          : () async {
                              final api = ApiService();
                              final photoUrl = await api.uploadPhoto(
                                _selectedImage!,
                              );
                              if (photoUrl != null && mounted) {
                                context.read<PhotoProvider>().setPhoto(
                                  photoUrl,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                    content: Text(
                                      'fotografyuklendi',
                                    ).tr(),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            },
                      child: Text(
                        'devamet',
                        style: AppTextStyles.tumjetonlar.copyWith(
                          color: _selectedImage == null
                              ? Colors.white.withOpacity(
                                  0.6,
                                )
                              : AppColors.white,
                        ),
                      ).tr(),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'atla',
                      style: TextStyle(fontSize: 15, color: AppColors.white70),
                    ).tr(),
                  ),
                  AppGaps.h12,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
