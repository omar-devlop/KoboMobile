import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/helpers/extensions/app_theme.dart';
import 'package:kobo/core/helpers/preferences_service.dart';
import 'package:kobo/core/shared/widget/page_background.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/features/auth/bloc/auth_cubit.dart';
import 'package:kobo/features/users/model/account.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController serverUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscured = true;
  bool _rememberMe = true;

  Future<void> _launchUrl() async {
    Uri url = Constants.koboSignupUrl;
    try {
      await launchUrl(url);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${context.tr('couldNotLaunch')} "$url"')),
      );
    }
    return;
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    serverUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size screenSize = MediaQuery.of(context).size;

    Widget loginButton() {
      return FilledButton.icon(
        onPressed: () {
          if (!_formKey.currentState!.validate()) return;
          BlocProvider.of<AuthCubit>(context).login(
            Account(
              username: usernameController.text,
              password: passwordController.text,
              serverUrl: serverUrlController.text,
            ),
            rememberMe: _rememberMe,
          );
        },
        label: Text(context.tr('login')),
        icon: const Icon(Icons.login),
      );
    }

    Widget loginSuccessButton() {
      return FilledButton(onPressed: null, child: Text(context.tr('loggedIn')));
    }

    Widget loadingButton(String msg) {
      return FilledButton.icon(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(
            theme.colorScheme.onSecondary,
          ),
          backgroundColor: WidgetStatePropertyAll(theme.colorScheme.secondary),
        ),
        onPressed: null,
        label: Text(context.tr(msg)),
        icon: SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(
            color: theme.colorScheme.onPrimary,
            strokeWidth: 2,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              icon: const Icon(Icons.settings),
              color: context.colors.primary,
              onPressed: () => context.pushNamed(Routes.settingsScreen),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              color: context.colors.primary,
              onPressed: () => context.pushNamed(Routes.aboutScreen),
            ),
          ],
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Success) {
            if (context.mounted) {
              context.pushReplacementNamed(Routes.homeScreen);
            }
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Stack(
              children: [
                state.maybeWhen(
                  error:
                      (error) => PageBackground(color: theme.colorScheme.error),
                  loading:
                      (msg) => const PageBackground(color: Colors.orangeAccent),
                  orElse: () => const PageBackground(),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: AutofillGroup(
                    child: ListView(
                      children: [
                        const SizedBox(height: 72),
                        SvgPicture.asset(
                          'assets/svg/kobo_logo.svg',
                          width: screenSize.width / 1.5,
                        ),
                        const SizedBox(height: 72),

                        Form(
                          key: _formKey,
                          child: Column(
                            spacing: 20.0,
                            children: [
                              TextFormField(
                                style: TextStyle(
                                  color: theme.colorScheme.secondary,
                                ),
                                controller: serverUrlController,
                                decoration: InputDecoration(
                                  hintText: 'https://eu.kobotoolbox.org',
                                  hintStyle: TextStyle(
                                    color: theme.colorScheme.outlineVariant,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.outlineVariant,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  prefixIcon: const Icon(Icons.dns),
                                  suffixIcon: PopupMenuButton<String>(
                                    icon: const Icon(Icons.arrow_drop_down),
                                    onSelected: (String value) {
                                      serverUrlController.text = value;
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return Constants.koboServersList.map((
                                        String value,
                                      ) {
                                        return PopupMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList();
                                    },
                                  ),
                                  labelText: context.tr('serverUrl'),

                                  filled: true,
                                  fillColor: theme.colorScheme.onInverseSurface,
                                ),
                                validator:
                                    (value) =>
                                        value.isNullOrEmpty()
                                            ? context.tr('required')
                                            : null,
                              ),
                              TextFormField(
                                style: TextStyle(
                                  color: theme.colorScheme.secondary,
                                ),
                                controller: usernameController,
                                autofillHints: const [AutofillHints.username],
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.outlineVariant,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  prefixIcon: const Icon(Icons.person),
                                  labelText: context.tr('username'),

                                  filled: true,
                                  fillColor: theme.colorScheme.onInverseSurface,
                                ),
                                validator:
                                    (value) =>
                                        value.isNullOrEmpty()
                                            ? context.tr('required')
                                            : null,
                              ),
                              TextFormField(
                                autocorrect: false,
                                style: TextStyle(
                                  color: theme.colorScheme.secondary,
                                ),
                                controller: passwordController,
                                obscureText: _obscured,
                                autofillHints: const [AutofillHints.password],
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.colorScheme.outlineVariant,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  prefixIcon: const Icon(Icons.lock),
                                  labelText: context.tr('password'),

                                  filled: true,
                                  fillColor: theme.colorScheme.onInverseSurface,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscured
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      _obscured = !_obscured;
                                      if (mounted) setState(() {});
                                    },
                                  ),
                                ),
                                validator:
                                    (value) =>
                                        value.isNullOrEmpty()
                                            ? context.tr('required')
                                            : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: CheckboxListTile(
                            visualDensity: VisualDensity.compact,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = !_rememberMe;
                              });
                            },
                            title: Text(context.tr("rememberMe")),
                          ),
                        ),
                        const SizedBox(height: 24),
                        state.maybeWhen(
                          loading: loadingButton,
                          success: loginSuccessButton,
                          orElse: loginButton,
                        ),

                        const SizedBox(height: 12),
                        TextButton.icon(
                          onPressed: () async {
                            int savedUsers =
                                (await PreferencesService.getStringList(
                                  Constants.koboUsersKeys,
                                )).length;
                            if (savedUsers > 0) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                context.pushNamedAndRemoveUntil(
                                  Routes.usersScreen,
                                  predicate: (Route<dynamic> route) => false,
                                );
                              });
                            } else {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      context.tr('noSavedAccounts'),
                                    ),
                                  ),
                                );
                              });
                            }
                          },
                          label: Text(context.tr('savedAccounts')),
                          icon: const Icon(Icons.group),
                        ),
                        const SizedBox(height: 24),

                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: theme.textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: "${context.tr('dontHaveAccount')}  ",
                              ),
                              TextSpan(
                                text: context.tr('signUp'),
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                                recognizer:
                                    TapGestureRecognizer()..onTap = _launchUrl,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 48),

                        state.maybeWhen(
                          error:
                              (msg) => Text(
                                msg,
                                style: TextStyle(
                                  color: theme.colorScheme.error,
                                ),
                                textAlign: TextAlign.center,
                              ),
                          orElse: () => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
