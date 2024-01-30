import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sport/app/core/theme/colors.dart';
import 'package:sport/app/core/utils/intl.dart';
import 'package:sport/app/core/widgets/shimmer_widget.dart';
import 'package:sport/app/core/widgets/widget_state.dart';

class ReactiveCustomTextField extends StatefulWidget {
  const ReactiveCustomTextField({
    required this.widgetState,
    required this.formControlName,
    required this.hintText,
    this.showBorder = false,
    this.maxLines = 1,
    this.minLines,
    this.onTap,
    this.onChangedFormat,
    this.inputFormatters,
    this.validationMessages,
    this.onSubmitted,
    this.textInputAction,
    this.suffixIcon,
    this.onChanged,
    this.maxLength = 40,
    Key? key,
    this.keyboardType = TextInputType.emailAddress,
    this.obscureText = false,
  }) : super(key: key);
  final WidgetState widgetState;
  final void Function()? onSubmitted;
  final void Function(String text)? onChangedFormat;
  final void Function(String text)? onChanged;
  final void Function()? onTap;
  final String formControlName;
  final String hintText;
  final Map<String, String Function(Object)>? validationMessages;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? suffixIcon;
  final int? maxLength;
  final bool showBorder;
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  @override
  State<ReactiveCustomTextField> createState() =>
      _ReactiveCustomTextFieldState();
}

class _ReactiveCustomTextFieldState extends State<ReactiveCustomTextField> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ReactiveTextField(
      key: Key(widget.formControlName),
      textInputAction: widget.textInputAction,
      formControlName: widget.formControlName,
      readOnly: widget.widgetState == WidgetState.loading,
      validationMessages: widget.validationMessages,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      textDirection:
          controller.text == "" ? null : getTextDirection(controller.text),
      inputFormatters: widget.inputFormatters,
      minLines: widget.minLines,
      onTap: (_) {
        if (controller.selection.extent.offset == 0) {
          setState(() {
            controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length));
          });
        }
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      onChanged: (control) {
        if (widget.onChanged != null) {
          widget.onChanged!(controller.text);
        }
        setState(() {});
      },
      controller: controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      onSubmitted: widget.widgetState != WidgetState.loading &&
              widget.onSubmitted != null
          ? (_) => widget.onSubmitted!()
          : null,
      style: const TextStyle(color: AppColors.font),
      cursorColor: AppColors.secondry,
      decoration: InputDecoration(
        hintStyle: const TextStyle(
          color: AppColors.fontGray,
          fontSize: 13,
        ),
        hintText: widget.hintText,
        counterText: "",
        enabledBorder: widget.showBorder
            ? const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.secondry),
              )
            : null,
        border: widget.showBorder
            ? const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.secondry),
              )
            : null,
        suffixIcon: widget.suffixIcon != null
            ? SizedBox(
                width: 40,
                height: 40,
                child: widget.suffixIcon,
              )
            : null,
      ),
    );
  }
}

class PhoneValidator extends Validator<dynamic> {
  const PhoneValidator() : super();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    return control.value == null ||
            control.value == "" ||
            true
        ? null
        : {'phone': true};
  }
}

class EmailValidator extends Validator<dynamic> {
  const EmailValidator() : super();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    return control.value == null ||
            control.value == "" ||
            emailRegExp.hasMatch(control.value)
        ? null
        : {'email': true};
  }
}

class URLValidator extends Validator<dynamic> {
  const URLValidator() : super();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    return control.value == null ||
            control.value == "" ||
            urlRegExp.hasMatch(control.value)
        ? null
        : {'url': true};
  }
}

class MustMatch extends Validator<dynamic> {
  const MustMatch(this.controlName, this.matchingControlName) : super();
  final String controlName, matchingControlName;
  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final form = control as FormGroup;

    final formControl = form.control(controlName);
    final matchingFormControl = form.control(matchingControlName);

    if (formControl.value != matchingFormControl.value) {
      matchingFormControl.setErrors({'mustMatch': true});

      // force messages to show up as soon as possible
      matchingFormControl.markAsTouched();
    } else {
      matchingFormControl.removeError('mustMatch');
    }
    return {'mustMatch': true};
  }
}

RegExp phoneRegExp = RegExp(
    r'(^(\+97[\s]{0,1}[\-]{0,1}[\s]{0,1}1|0)50[\s]{0,1}[\-]{0,1}[\s]{0,1}[1-9]{1}[0-9]{6}$)');
final RegExp emailRegExp =
    RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
RegExp urlRegExp = RegExp(r'^(https?|ftp):\/\/([^\s\/$.?#].[^\s]*)$');

class HeaderTextField extends StatelessWidget {
  const HeaderTextField({
    required this.widgetState,
    required this.formControlName,
    required this.hintText,
    required this.header,
    this.showBorder = false,
    this.maxLines = 1,
    this.minLines,
    this.inputFormatters,
    this.onChangedFormat,
    this.onSubmitted,
    this.suffixIcon,
    this.maxLength = 40,
    this.validationMessages,
    this.onChanged,
    this.textInputAction,
    this.onTap,
    Key? key,
    this.keyboardType = TextInputType.emailAddress,
    this.obscureText = false,
  }) : super(key: key);
  final WidgetState widgetState;
  final void Function()? onSubmitted;
  final void Function()? onTap;
  final String formControlName;
  final String hintText;
  final String header;
  final Map<String, String Function(Object)>? validationMessages;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? suffixIcon;
  final int? maxLength;
  final bool showBorder;
  final int? maxLines;
  final void Function(String text)? onChangedFormat;
  final void Function(String text)? onChanged;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.fontGray,
          ),
        ),
        const SizedBox(height: 10),
        ReactiveCustomTextField(
            obscureText: obscureText,
            showBorder: showBorder,
            onChanged: onChanged,
            inputFormatters: inputFormatters,
            maxLines: maxLines,
            onChangedFormat: onChangedFormat,
            onTap: onTap,
            minLines: minLines,
            validationMessages: validationMessages,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            suffixIcon: suffixIcon,
            maxLength: maxLength,
            widgetState: widgetState,
            onSubmitted: onSubmitted,
            formControlName: formControlName,
            hintText: hintText),
      ],
    );
  }
}

class TextFieldModel {
  const TextFieldModel({
    required this.onSubmitted,
    required this.formControlName,
    required this.hintText,
    required this.header,
    this.validationMessages,
    Key? key,
    this.keyboardType = TextInputType.emailAddress,
  });
  final void Function() onSubmitted;
  final String formControlName;
  final String hintText;
  final String header;
  final Map<String, String Function(Object)>? validationMessages;
  final TextInputType keyboardType;
}

class ReactiveCustomDropdownField<T> extends StatelessWidget {
  const ReactiveCustomDropdownField({
    required this.widgetState,
    required this.formControlName,
    required this.hintText,
    required this.items,
    this.showBorder = false,
    this.validationMessages,
    this.onChanged,
    Key? key,
  }) : super(key: key);
  final Map<String, String Function(Object)>? validationMessages;
  final WidgetState widgetState;
  final String formControlName;
  final String hintText;
  final void Function(FormControl<T>)? onChanged;
  final List<DropdownMenuItem<T>> items;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return ReactiveDropdownField<T>(
      formControlName: formControlName,
      readOnly: widgetState == WidgetState.loading,
      borderRadius: BorderRadius.circular(15),
      menuMaxHeight: 400,
      decoration: InputDecoration(
        enabledBorder: showBorder
            ? const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              )
            : null,
        border: showBorder
            ? const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              )
            : null,
      ),
      validationMessages: validationMessages,
      dropdownColor: AppColors.codeInput.withOpacity(0.9),
      iconEnabledColor: Colors.black,
      isExpanded: true,
      icon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).primaryColor,
      ),
      items: items,
      hint: Text(hintText,
          style: const TextStyle(
            color: AppColors.font,
            fontSize: 13,
          )),
      onTap: (_) {
        FocusScope.of(context).unfocus();
      },
      onChanged: onChanged,
    );
  }
}

class HeaderDropdownField<T> extends StatelessWidget {
  const HeaderDropdownField({
    required this.widgetState,
    required this.formControlName,
    required this.hintText,
    required this.items,
    required this.header,
    this.showBorder = false,
    this.validationMessages,
    this.onChanged,
    Key? key,
  }) : super(key: key);
  final Map<String, String Function(Object)>? validationMessages;
  final WidgetState widgetState;
  final String formControlName;
  final String hintText;
  final void Function(FormControl<T>)? onChanged;
  final List<DropdownMenuItem<T>> items;
  final String header;
  final bool showBorder;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.fontGray,
          ),
        ),
        const SizedBox(height: 10),
        ReactiveCustomDropdownField(
          widgetState: widgetState,
          showBorder: showBorder,
          formControlName: formControlName,
          hintText: hintText,
          onChanged: onChanged,
          validationMessages: validationMessages,
          items: items,
        ),
      ],
    );
  }
}

class StateHeaderDropdownField<T> extends StatelessWidget {
  const StateHeaderDropdownField({
    required this.widgetState,
    required this.formControlName,
    required this.hintText,
    required this.items,
    required this.header,
    required this.onRetry,
    this.showBorder = false,
    this.fieldState,
    this.validationMessages,
    this.onChanged,
    Key? key,
  }) : super(key: key);
  final Map<String, String Function(Object)>? validationMessages;
  final WidgetState widgetState;
  final WidgetState? fieldState;
  final String formControlName;
  final String hintText;
  final void Function(FormControl<T>)? onChanged;
  final List<DropdownMenuItem<T>> items;
  final String header;
  final bool showBorder;
  final void Function() onRetry;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      switch (fieldState) {
        case WidgetState.loading:
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                header,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 9),
              ShimmerWidget(
                baseColor: AppColors.codeInput,
                highlightColor: AppColors.fontGray,
                shapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                height: 65,
                width: double.infinity,
              )
            ],
          );
        case WidgetState.error:
          return SizedBox(
            height: 98,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  header,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Center(
                  child: IconButton(
                    onPressed: onRetry,
                    icon: const Icon(
                      Icons.refresh,
                      color: AppColors.font,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
        default:
          return HeaderDropdownField<T>(
            widgetState: widgetState,
            header: header,
            showBorder: showBorder,
            formControlName: formControlName,
            hintText: hintText,
            onChanged: onChanged,
            validationMessages: validationMessages,
            items: items,
          );
      }
    });
  }
}

class StateDropdownField<T> extends StatelessWidget {
  const StateDropdownField({
    required this.widgetState,
    required this.formControlName,
    required this.hintText,
    required this.items,
    required this.header,
    required this.onRetry,
    this.showBorder = false,
    this.fieldState,
    this.validationMessages,
    this.onChanged,
    Key? key,
  }) : super(key: key);
  final Map<String, String Function(Object)>? validationMessages;
  final WidgetState widgetState;
  final WidgetState? fieldState;
  final String formControlName;
  final String hintText;
  final void Function(FormControl<T>)? onChanged;
  final List<DropdownMenuItem<T>> items;
  final String header;
  final bool showBorder;
  final void Function() onRetry;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      switch (fieldState) {
        case WidgetState.loading:
          return ShimmerWidget(
            baseColor: AppColors.codeInput,
            highlightColor: AppColors.fontGray,
            shapeBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            height: 65,
            width: double.infinity,
          );
        case WidgetState.error:
          return SizedBox(
            height: 65,
            child: Center(
              child: IconButton(
                onPressed: onRetry,
                icon: const Icon(
                  Icons.refresh,
                  color: AppColors.font,
                ),
              ),
            ),
          );
        default:
          return ReactiveCustomDropdownField<T>(
            widgetState: widgetState,
            showBorder: showBorder,
            formControlName: formControlName,
            hintText: hintText,
            onChanged: onChanged,
            validationMessages: validationMessages,
            items: items,
          );
      }
    });
  }
}
