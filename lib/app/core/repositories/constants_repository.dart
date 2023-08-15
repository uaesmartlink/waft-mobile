import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sport/app/core/constants/request_routes.dart';
import 'package:sport/app/core/models/activity_type_model.dart';
import 'package:sport/app/core/models/city_model.dart';
import 'package:sport/app/core/models/constants_model.dart';
import 'package:sport/app/core/models/region_model.dart';
import 'package:sport/app/core/models/service_model.dart';
import 'package:sport/app/core/services/user_config.dart';
import 'package:sport/app/core/utils/exceptions.dart';

import 'repository_interface.dart';

class ConstantsRepository extends RepositoryInterface {
  Future<Constants> getConstants({
    Function(Constants constants)? onUpdate,
  }) async {
    try {
      Constants? constants = await UserConfig.getConstants();
      if (constants == null) {
        final Response response = await dio.get(
          RequestRoutes.settings,
        );
        constants = Constants.fromMap(response.data[0]);
        await UserConfig.setConstants(constants);
      } else {
        dio
            .get(
          RequestRoutes.settings,
        )
            .then((value) {
          Constants updatedConstants = Constants.fromMap(value.data[0]);
          UserConfig.setConstants(updatedConstants);
          if (onUpdate != null) {
            onUpdate(updatedConstants);
          }
        });
      }
      return constants;
    } catch (e) {
      throw ExceptionHandler(e);
    }
  }

  Future<String> uploadFile({
    required File file,
    required Function(int progress) onSendProgress,
  }) async {
    try {
      int fakeCounter = 0;
      final FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path,
            filename: file.path.split('/').last),
      });
      final Response response = await dio.post(
        RequestRoutes.uploadImages,
        data: formData,
        onSendProgress: (int send, int total) {
          int progress = (send / total * 100).toInt();
          fakeCounter = fakeCounter > 100 ? 100 : fakeCounter++;
          progress = progress > 100
              ? 100
              : progress < 0
                  ? fakeCounter
                  : progress;
          onSendProgress(progress);
        },
      );
      return response.data['urls'][0];
    } catch (e) {
      throw ExceptionHandler(e);
    }
  }

  Future<List<City>> getCities() async {
    try {
      final Response response = await dio.get(
        RequestRoutes.cities,
      );
      return City.cities(response.data);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<List<ActivityType>> getActivityTypes() async {
    try {
      final Response response = await dio.get(
        RequestRoutes.activityTypes,
      );
      return ActivityType.activityTypes(response.data);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<List<ServiceModel>> getServices() async {
    try {
      final Response response = await dio.get(
        RequestRoutes.services,
      );
      return ServiceModel.services(response.data);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> addStadiumServices({
    required int stadiumId,
    required int serviceId,
  }) async {
    try {
      await dio.post(
        RequestRoutes.stadiumServices,
        data: {
          "stadium_id": stadiumId,
          "service_id": serviceId,
          "description": "",
          "price": 0,
        },
      );
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> deleteStadiumServices({
    required int serviceId,
  }) async {
    try {
      await dio.delete("${RequestRoutes.stadiumServices}/$serviceId");
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<List<Region>> getRegions({required int cityId}) async {
    try {
      final Response response = await dio.get(
        "${RequestRoutes.cities}/$cityId",
      );
      return Region.regions(response.data["regions"]);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }
}
