part of '../home_module.dart';

class _HomePages {
  _HomePages._();

  static List<GetPage> homePages = [
    SecureGetPage(
      name: HomeRoutes.homeStructuringRoute,
      page: () => const HomeStructuringView(),
      binding: HomeStructuringBinding(),
      transition: Transition.downToUp,
    ),
    SecureGetPage(
      name: HomeRoutes.activityDetailsRoute,
      page: () => const ActivityDetailsView(),
      binding: ActivityDetailsBinding(),
      transition: Transition.downToUp,
    ),
    SecureGetPage(
      name: HomeRoutes.bookAppointmentRoute,
      page: () => const BookAppointmentView(),
      binding: BookAppointmentBinding(),
      transition: Transition.downToUp,
    ),
    SecureGetPage(
      name: HomeRoutes.searchActivitiesRoute,
      page: () => const SearchActivitiesView(),
      binding: SearchActivitiesBinding(),
      transition: Transition.downToUp,
    ),
    SecureGetPage(
      name: HomeRoutes.favoritesRoute,
      page: () => const FavoritesView(),
      binding: FavoritesBinding(),
      transition: Transition.upToDown,
    ),
    SecureGetPage(
      name: HomeRoutes.notificationsRoute,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
      transition: Transition.upToDown,
    ),
    SecureGetPage(
      name: HomeRoutes.paymentHistoryRoute,
      page: () => const PaymentHistoryView(),
      binding: PaymentHistoryBinding(),
      transition: Transition.upToDown,
    ),
    SecureGetPage(
      name: HomeRoutes.reviewSummaryRoute,
      page: () => const ReviewSummaryView(),
      binding: ReviewSummaryBinding(),
      transition: Transition.downToUp,
    ),
    SecureGetPage(
      name: HomeRoutes.bookingResultRoute,
      page: () => const BookingResultView(),
      binding: BookingResultBinding(),
      transition: Transition.downToUp,
    ),
    SecureGetPage(
      name: HomeRoutes.editProfileRoute,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
      transition: Transition.upToDown,
    ),
    SecureGetPage(
      name: HomeRoutes.languageRoute,
      page: () => const LanguageView(),
      binding: LanguageBinding(),
      transition: Transition.upToDown,
    ),
    SecureGetPage(
      name: HomeRoutes.paymentGatewayRoute,
      page: () => const PaymentGatewayView(),
      binding: PaymentGatewayBinding(),
      transition: Transition.upToDown,
    ),
    SecureGetPage(
      name: HomeRoutes.changeEmailRoute,
      page: () => const ChangeEmailView(),
      binding: ChangeEmailBinding(),
      transition: Transition.upToDown,
    ),
    SecureGetPage(
      name: HomeRoutes.addActivityRoute,
      page: () => AddActivityView(),
      binding: AddActivityBinding(),
      transition: Transition.downToUp,
    ),
  ];
}
