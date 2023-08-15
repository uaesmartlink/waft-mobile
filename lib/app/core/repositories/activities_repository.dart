import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:sport/app/core/constants/request_routes.dart';
import 'package:sport/app/core/models/activity_model.dart';
import 'package:sport/app/core/models/available_time_mode.dart';
import 'package:sport/app/core/models/banner_model.dart';
import 'package:sport/app/core/models/booking_model.dart';
import 'package:sport/app/core/models/notification_model.dart';
import 'package:sport/app/core/models/package_model.dart';
import 'package:sport/app/core/models/review_model.dart';
import 'package:sport/app/core/models/statistics_model.dart';
import 'package:sport/app/core/models/transaction_model.dart';
import 'package:sport/app/core/utils/exceptions.dart';

import 'repository_interface.dart';

class ActivitiesRepository extends RepositoryInterface {
  Future<List<BannerModel>> getBanners({required String displayFor}) async {
    try {
      final Response response = await dio.get(RequestRoutes.banners,
          queryParameters: {"display_for": displayFor});
      return BannerModel.banners(response.data);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<List<Activity>> getActivities({
    required CancelToken cancelToken,
    int? page,
    String? name,
    int? activityTypeId,
    double? minRating,
    int? cityId,
    int? regionId,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        "name": name,
        "activity_id": activityTypeId,
        "min_rating": minRating,
        "city_id": cityId,
        "region_id": regionId,
        "page": page,
        "per_page": 30,
      };
      queryParameters.removeWhere(
          (key, value) => value == null || value == "null" || value == "");
      final Response response = await dio.get(
        RequestRoutes.searchStadia,
        cancelToken: cancelToken,
        queryParameters: queryParameters,
      );
      return Activity.activities(response.data["data"]);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<List<Activity>> getMostBooked({
    int? activityTypeId,
    int? page,
    int perPage = 30,
    required CancelToken cancelToken,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        "per_page": perPage,
        "page": page,
        "activity_id": activityTypeId,
      };
      queryParameters.removeWhere(
          (key, value) => value == null || value == "null" || value == "");
      final Response response = await dio.get(
        RequestRoutes.mostBooked,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return Activity.activities(response.data["data"]);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<int> addToFavorites({
    required int stadiumId,
  }) async {
    try {
      Response response = await dio.post(
        RequestRoutes.favorites,
        data: {
          "stadium_id": stadiumId,
        },
      );
      return response.data["id"];
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> removeFromFavorites({
    required int favoriteId,
  }) async {
    try {
      await dio.delete(
        "${RequestRoutes.favorites}/$favoriteId",
      );
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<Activity> getStadia({required int id}) async {
    try {
      final Response response = await dio.get(
        "${RequestRoutes.stadia}/$id",
      );
      return Activity.fromMap(response.data);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<List<AvailableTime>> getAvailableTimes({
    required int stadiumId,
    required int packageId,
    required DateTime date,
    required CancelToken cancelToken,
  }) async {
    try {
      final Response response = await dio.get(
        RequestRoutes.availableTimes,
        cancelToken: cancelToken,
        queryParameters: {
          "stadium_id": stadiumId,
          "package_id": packageId,
          "date": DateFormat("yyyy-MM-dd", "en").format(date),
        },
      );
      return AvailableTime.availableTimes(response.data);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<List<Review>> stadiumReviews({
    required int page,
    required int stadiumId,
  }) async {
    try {
      final Response response = await dio.get(
        "${RequestRoutes.stadium}/$stadiumId/reviews",
        queryParameters: {
          "page": page,
          "perPage": 30,
        },
      );
      return Review.reviews(response.data);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<List<Activity>> getFavoriteStadiums({int? page}) async {
    try {
      Map<String, dynamic> queryParameters = {
        "page": page,
        "per_page": 30,
      };
      queryParameters.removeWhere(
          (key, value) => value == null || value == "null" || value == "");
      final Response response = await dio.get(
        RequestRoutes.myFavoriteStadiums,
        queryParameters: queryParameters,
      );
      return Activity.activities(response.data["data"]);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<List<NotificationModel>> getNotifications({int? page}) async {
    try {
      Map<String, dynamic> queryParameters = {
        "page": page,
        "per_page": 30,
      };
      queryParameters.removeWhere(
          (key, value) => value == null || value == "null" || value == "");
      final Response response = await dio.get(
        RequestRoutes.notifications,
        queryParameters: queryParameters,
      );
      return NotificationModel.notifications(response.data["data"]);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<List<Review>> getReviews({
    required int stadiumId,
    int perPage = 30,
    int? page,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        "page": page,
        "perPage": perPage,
      };
      queryParameters.removeWhere(
          (key, value) => value == null || value == "null" || value == "");
      final Response response = await dio.get(
        "${RequestRoutes.stadium}/$stadiumId/reviews",
        queryParameters: queryParameters,
      );
      return Review.reviews(response.data["data"]);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<String> bookStadium({
    required int stadiumId,
    required Package package,
    required int userId,
    required DateTime startTime,
  }) async {
    try {
      Response response = await dio.post(
        RequestRoutes.bookings,
        data: {
          "stadium_id": stadiumId,
          "package_id": package.id,
          "user_id": userId,
          "start_time": startTime.toIso8601String(),
          "end_time":
              startTime.add(Duration(minutes: package.slot)).toIso8601String(),
          "type": package.getPackageTypeString,
        },
      );
      return await paymentCharge(bookingId: response.data["id"]);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<String> paymentCharge({required int bookingId}) async {
    try {
      Response response = await dio.post(
        RequestRoutes.paymentCharge,
        data: {
          "booking_id": bookingId,
          "currency": "AED",
          "description": "Test Description",
          "metadata": {"udf1": "Metadata 1"},
          "reference": {"transaction": "txn_01", "order": "ord_01"}
        },
      );
      return response.data["data"]["transaction"]["url"];
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<List<Booking>> getUserBookings({
    required String filter,
    required String type,
    required CancelToken cancelToken,
    int? page,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        "page": page,
        "perPage": 30,
        "type": type,
      };
      queryParameters.removeWhere(
          (key, value) => value == null || value == "null" || value == "");
      final Response response = await dio.get(
        filter,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return Booking.bookings(response.data["data"]);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> cancelBooking({required int bookingId}) async {
    try {
      await dio.post(
        "/booking/$bookingId/cancel",
        data: {"reason": ""},
      );
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<Review> addReview({
    required int stadiumId,
    required int rating,
    required String comment,
  }) async {
    try {
      Response response = await dio.post(
        RequestRoutes.reviews,
        data: {
          "stadium_id": stadiumId,
          "rating": rating,
          "comment": comment,
        },
      );
      return Review.fromMap(response.data);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<bool> paymentCallback({
    required String id,
    required int bookingId,
  }) async {
    try {
      Response response = await dio.post(
        RequestRoutes.paymentCallback,
        data: {
          "booking_id": bookingId,
          "currency": "AED",
          "description": "Test Description",
          "metadata": {"udf1": "Metadata 1"},
          "reference": {"transaction": "txn_01", "order": "ord_01"}
        },
        queryParameters: {"id": id},
      );
      return response.data["data"]["status"] == "CAPTURED";
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<List<Transaction>> getPaymentHistory({
    int perPage = 30,
    int? page,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        "page": page,
        "perPage": perPage,
      };
      queryParameters.removeWhere(
          (key, value) => value == null || value == "null" || value == "");
      final Response response = await dio.get(
        RequestRoutes.paymentHistory,
        queryParameters: queryParameters,
      );
      return Transaction.transactions(response.data["data"]);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<bool> checkBooking({
    required int stadiumId,
  }) async {
    try {
      final Response response = await dio.get(
        "/stadium/$stadiumId/check-booking",
      );
      return response.data["has_booked"];
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<Statistics> getStatistics({
    required String timePeriod,
  }) async {
    try {
      final Response response = await dio.get(
        RequestRoutes.statistics,
        queryParameters: {"time_period": timePeriod},
      );
      return Statistics.fromMap(response.data);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<List<Activity>> getManagerActivity() async {
    try {
      final Response response = await dio.get(
        RequestRoutes.myStadiums,
      );
      return Activity.activities(response.data);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> addActivity({
    required String nameEn,
    required String nameAr,
    required int regionId,
    required int activityId,
    required String mapUrl,
    required String descriptionEn,
    required String descriptionAr,
    required String addressAr,
    required String addressEn,
    required String phone,
    required String email,
    required String website,
    required File image,
  }) async {
    try {
      Map<String, dynamic> data = {
        "name_en": nameEn,
        "name_ar": nameAr,
        "region_id": regionId,
        "activity_id": activityId,
        "map_url": mapUrl,
        "description_en": descriptionEn,
        "description_ar": descriptionAr,
        "address_ar": addressAr,
        "address_en": addressEn,
        "phone": phone,
        "email": email,
        "website": website,
        "image": await MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last),
      };
      final FormData formData = FormData.fromMap(data);
      await dio.post(
        RequestRoutes.stadia,
        data: formData,
      );
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> updateActivity({
    required int stadiaId,
    required String nameEn,
    required String nameAr,
    required int regionId,
    required int activityId,
    required String mapUrl,
    required String descriptionEn,
    required String descriptionAr,
    required String addressAr,
    required String addressEn,
    required String phone,
    required String email,
    required String website,
    required File? image,
  }) async {
    try {
      Map<String, dynamic> data = {
        "name_en": nameEn,
        "name_ar": nameAr,
        "region_id": regionId,
        "activity_id": activityId,
        "map_url": mapUrl,
        "description_en": descriptionEn,
        "description_ar": descriptionAr,
        "address_ar": addressAr,
        "address_en": addressEn,
        "phone": phone,
        "email": email,
        "website": website,
        "image": image == null
            ? null
            : await MultipartFile.fromFile(image.path,
                filename: image.path.split('/').last),
      };
      data.removeWhere(
          (key, value) => value == null || value == "null" || value == "");
      final FormData formData = FormData.fromMap(data);
      await dio.put(
        "${RequestRoutes.stadia}/$stadiaId",
        data: image == null ? data : formData,
      );
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> addStadiumPackage({
    required int stadiumId,
    required int userId,
    required int price,
    required int slot,
    required String nameEn,
    required String nameAr,
    required String type,
    required String slotType,
  }) async {
    try {
      await dio.post(
        RequestRoutes.packages,
        data: {
          "stadium_id": stadiumId,
          "user_id": userId,
          "name_en": nameEn,
          "name_ar": nameAr,
          "price": price,
          "slot": slot,
          "type": type,
          "slot_type": slotType,
        },
      );
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> updateStadiumPackage({
    required int packageId,
    required int price,
    required int slot,
    required String nameEn,
    required String nameAr,
    required String type,
    required String slotType,
  }) async {
    try {
      await dio.put(
        "${RequestRoutes.packages}/$packageId",
        data: {
          "name_en": nameEn,
          "name_ar": nameAr,
          "price": price,
          "slot": slot,
          "type": type,
          "slot_type": slotType,
        },
      );
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> deleteStadiumPackage({
    required int packageId,
  }) async {
    try {
      await dio.delete("${RequestRoutes.packages}/$packageId");
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> addImageToGallery({
    required int stadiumId,
    required File image,
  }) async {
    try {
      Map<String, dynamic> data = {
        "images[]": await MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last),
      };
      final FormData formData = FormData.fromMap(data);
      await dio.post(
        "${RequestRoutes.stadia}/$stadiumId/images",
        data: formData,
      );
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> deleteImage({
    required int stadiumId,
    required int imageId,
  }) async {
    try {
      await dio.delete(
        "${RequestRoutes.stadia}/$stadiumId/images/$imageId",
      );
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> addWorkTime({
    required int stadiumId,
    required String day,
    required String startTime,
    required String endTime,
  }) async {
    try {
      await dio.post(
        RequestRoutes.workTimes,
        data: {
          "stadium_id": stadiumId,
          "day": day,
          "start_time": startTime,
          "end_time": endTime,
        },
      );
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> updateWorkTime({
    required int stadiumId,
    required int workTimeId,
    required String day,
    required String startTime,
    required String endTime,
  }) async {
    try {
      await dio.put(
        "${RequestRoutes.workTimes}/$workTimeId",
        data: {
          "stadium_id": stadiumId,
          "day": day,
          "start_time": startTime,
          "end_time": endTime,
        },
      );
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<void> deleteWorkTime({
    required int workTimeId,
  }) async {
    try {
      await dio.delete(
        "${RequestRoutes.workTimes}/$workTimeId",
      );
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }

  Future<List<Booking>> getManagerBookings({
    required CancelToken cancelToken,
    required String type,
    String? status,
    int? stadiumId,
    int? page,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        "page": page,
        "perPage": 30,
        "type": type,
        "status": status,
        "stadiumId": stadiumId,
      };
      queryParameters.removeWhere(
          (key, value) => value == null || value == "null" || value == "");
      final Response response = await dio.get(
        RequestRoutes.managerBookings,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return Booking.bookings(response.data["data"]);
    } catch (error) {
      throw ExceptionHandler(error);
    }
  }
}
