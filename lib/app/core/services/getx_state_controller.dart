import 'package:get/get.dart';

import 'request_mixin.dart';
import 'state_mixin.dart';

abstract class GetxStateController<T> extends GetxController
    with StateMixin<T>, StateProvider, RequestMixin {}
