part of '../auth_module.dart';

class _AuthPages {
  _AuthPages._();

  static List<GetPage> authPages = [
    SecureGetPage(
      name: AuthRoutes.wrapperRoute,
      page: () => const WrapperView(),
      binding: WrapperBinding(),
      transition: Transition.fade,
    ),
    SecureGetPage(
      name: AuthRoutes.loginRoute,
      page: () => LoginView(),
      binding: LoginBinding(),
      transition: Transition.downToUp,
    ),
    SecureGetPage(
      name: AuthRoutes.checkCodeRoute,
      page: () => const CheckCodeView(),
      binding: CheckCodeBinding(),
      transition: Transition.rightToLeft,
    ),
    SecureGetPage(
      name: AuthRoutes.registerRoute,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.rightToLeft,
    ),
    SecureGetPage(
      name: AuthRoutes.blockedRoute,
      page: () => const BlockedView(),
      binding: BlockedBinding(),
      transition: Transition.fade,
    ),
    SecureGetPage(
      name: AuthRoutes.onBoardingRoute,
      page: () => const OnBoardingView(),
      binding: OnBoardingBinding(),
      transition: Transition.fade,
    ),
    SecureGetPage(
      name: AuthRoutes.forgotPasswordRoute,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
      transition: Transition.fade,
    ),
    SecureGetPage(
      name: AuthRoutes.preRegisterRoute,
      page: () => const PreRegisterView(),
      binding: PreRegisterBinding(),
      transition: Transition.fade,
    ),
  ];
}
