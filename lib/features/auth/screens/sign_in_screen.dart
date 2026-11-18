import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wekala_waiter/core/extensions/build_context_extension.dart';
import 'package:wekala_waiter/core/widgets/custom_text_buttom.dart';
import 'package:wekala_waiter/core/widgets/custom_text_field.dart';
import 'package:wekala_waiter/features/auth/controllers/auth_controller.dart';
import 'package:wekala_waiter/helper/validate_check.dart';
import 'package:wekala_waiter/util/dimensions.dart';
import 'package:wekala_waiter/util/images.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    final authController = Get.find<AuthController>();
    _usernameController.text = authController.getUserName();
    _passwordController.text = authController.getUserPassword();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: GetBuilder<AuthController>(
              builder: (authController) {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.asset(
                        Get.isDarkMode ? Images.logoRemovebg : Images.logo,
                        width: context.screenWidth * 0.2,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'welcome_back'.tr,
                        style: TextStyle(
                          fontSize: context.largeFont,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'login_to_your_wekala_account'.tr,
                        style: TextStyle(
                          fontSize: context.mediumFont,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                      SizedBox(height: 25),
                      CustomTextField(
                        hint: 'username'.tr,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icons.person_outline_rounded,
                        controller: _usernameController,
                        focusNode: _usernameFocus,
                        required: true,
                        validator: (value) =>
                            ValidateCheck.validateUsername(value),
                      ),
                      SizedBox(height: 15),
                      CustomTextField(
                        hint: 'password'.tr,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        prefixIcon: Icons.lock_outline_rounded,
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        required: true,
                        validator: (value) =>
                            ValidateCheck.validatePassword(value, null),
                      ),
                      SizedBox(height: 10),

                      ListTile(
                        onTap: () => authController.toggleRememberMe(),
                        leading: Checkbox(
                          activeColor: Theme.of(context).primaryColor,
                          value: authController.isRememberMe,
                          onChanged: (value) =>
                              authController.toggleRememberMe(),
                        ),
                        title: Text('remember_me'.tr),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        horizontalTitleGap: 0,
                      ),

                      CustomButtonWidget(
                        isLoading: authController.isLoading,
                        buttonText: 'login'.tr,
                        width: context.screenWidth / 1.1,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            authController.login(
                              username: _usernameController.text.trim(),
                              password: _passwordController.text.trim(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
