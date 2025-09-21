import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:jr_case_boilerplate/core/constants/app_colors.dart';
import 'package:jr_case_boilerplate/core/constants/app_strings.dart';
import 'package:jr_case_boilerplate/core/constants/app_text_styles.dart';
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

  Future<void> _pickImage() async {
    // iOS & Android 13+
    final status = await Permission.photos.request();
    if (status.isDenied) return;

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A0000),
              Color(0xFF000000),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // ✨ Shine Effect
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
                child: Image.asset(
                  "assets/images/shine_effect.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 220,
                ),
              ),

              // 🔴 Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
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
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white24, width: 1),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_back,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                         Text(
                          AppStrings.profdetay,
                          style: AppTextStyles.profdetay,
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),

                    SizedBox(height: size.height * 0.05),

                    // Profile Pic Container (Figma: 76x76, radius 24)
                    Center(
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: const Color(0xFF000000).withOpacity(0.4),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/icons/profile_pic.png",
                          width: 32,
                          height: 40,
                          fit: BoxFit.contain,
                          // color: Colors.white, // PNG'i beyaza boyamak istemiyorsan yorumda bırak
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                     Text(
                      AppStrings.yukle,
                      style: AppTextStyles.yukle,
                    ),
                    const SizedBox(height: 6),
                     Text(
                      AppStrings.yuklemebilgi,
                      style: AppTextStyles.yuklebilgi,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: size.height * 0.05),

                    // Fotoğraf yükleme kutusu — Figma ile birebir:
                    // Width: 176, Height: 176, Radius: 32, Border: 1px Dashed (4,4), Padding: 10
                    GestureDetector(
                      onTap: _pickImage,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(32),
                        dashPattern: const [4, 4],
                        strokeWidth: 1,
                        color: Colors.white24,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Container(
                            width: 176,
                            height: 176,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.30),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: _selectedImage == null
                                ? const Center(
                              child: Icon(Icons.add, size: 40, color: Colors.white70),
                            )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ❌ X kapatma butonu (sadece fotoğraf seçilmişse)
                    if (_selectedImage != null) ...[
                      const SizedBox(height: 10), // Figma gap: 10px
                      GestureDetector(
                        onTap: _removeImage,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: Center(
                            child: Image.asset(
                              "assets/icons/xvector.png",
                              width: 16,
                              height: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],

                    const Spacer(),

                    // Devam Et butonu
                    SizedBox(
                      width: size.width * 0.90,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          _selectedImage == null ? Colors.grey : AppColors.redButton,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _selectedImage == null
                            ? null
                            : () async {
                          final api = ApiService();
                          final photoUrl = await api.uploadPhoto(_selectedImage!);

                          if (photoUrl != null && mounted) {
                            context.read<PhotoProvider>().setPhoto(photoUrl);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Fotoğraf başarıyla yüklendi")),
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "Devam Et",
                          style: AppTextStyles.tumjetonlar,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Atla
                    GestureDetector(
                      onTap: () {
                        // TODO: atla → diğer sayfaya geç
                      },
                      child: const Text(
                        "Atla",
                        style: TextStyle(fontSize: 15, color: Colors.white70),
                      ),
                    ),

                    SizedBox(height: size.height * 0.04),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
