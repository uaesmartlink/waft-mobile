import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sport/app/core/helpers/data_helper.dart';
import 'package:sport/app/core/localization/language_key.dart';
import 'package:sport/app/core/models/user_model.dart';
import 'package:sport/app/core/repositories/constants_repository.dart';
import 'package:sport/app/core/repositories/user_repository.dart';
import 'package:sport/app/core/widgets/app_messenger.dart';
import 'package:sport/app/core/widgets/input_fields.dart' hide EmailValidator;
import 'package:sport/app/modules/main_feature/home/home_controller.dart';
import 'package:sport/app/modules/main_feature/profile/profile_controller.dart';

import '../../../core/services/getx_state_controller.dart';
import '../../../core/services/request_mixin.dart';

class EditProfileController extends GetxStateController {
  final UserRepository userRepository;
  final ConstantsRepository constantsRepository;
  late final FormGroup editProfileForm;
  File? profileImage;

  EditProfileController({
    required this.userRepository,
    required this.constantsRepository,
  });

  Future<void> updateProfile({
    required String? fullName,
    required String? phoneNumber,
    required int? gender,
    required DateTime? birthday,
  }) async {
    await requestMethod(
      ids: ["EditProfileView"],
      loadedMessage: LanguageKey.profileUpdatedSuccessfully.tr,
      requestType: RequestType.getData,
      function: () async {
        User user = await userRepository.updateProfile(
          fullName: fullName,
          phoneNumber: phoneNumber,
          gender: gender,
          birthday: birthday,
          image: profileImage,
          token: DataHelper.user!.token,
          expiresInDate: DataHelper.user!.expiresInDate,
          browsingMode: DataHelper.user!.browsingTypeName,
          role: DataHelper.user!.roleName,
        );
        DataHelper.user = user;
        try {
          Get.find<ProfileController>().update(["Profile"]);
          Get.find<HomeController>().update(["hi"]);
        } catch (_) {}
        Get.back();
        return null;
      },
    );
  }

  Future<void> pickImageGallery() async {
    try {
      final pick = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pick != null) {
        profileImage = File(pick.path);
        int sizeInBytes = File(pick.path).lengthSync();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        if (sizeInMb > 2) {
          AppMessenger.message(LanguageKey.imageSize.tr);
          return;
        }
      }
      update(["profile"]);
    } catch (_) {}
  }

  @override
  void onInit() {
    editProfileForm = FormGroup(
      {
        "email": FormControl<String>(
          validators: [
            Validators.maxLength(40),
            const EmailValidator(),
          ],
          value: DataHelper.user?.email,
        ),
        "name": FormControl<String>(
          validators: [
            Validators.maxLength(40),
            Validators.minLength(3),
          ],
          value: DataHelper.user?.name,
        ),
        "phone": FormControl<String>(
          validators: [
            const PhoneValidator(),
          ],
          value: DataHelper.user?.phone?.replaceAll("+971", "0"),
        ),
        "gender": FormControl<int?>(
          value: DataHelper.user?.getGenderString,
        ),
        "birthday": FormControl<DateTime>(
          value: DataHelper.user?.birthday,
        ),
      },
    );
    super.onInit();
  }
}
