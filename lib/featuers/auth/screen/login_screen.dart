import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kobo/core/helpers/constants.dart';
import 'package:kobo/core/helpers/extensions.dart';
import 'package:kobo/core/helpers/preferences_service.dart';
import 'package:kobo/core/utils/routing/routes.dart';
import 'package:kobo/featuers/auth/bloc/auth_cubit.dart';
import 'package:kobo/featuers/users/model/account.dart';
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
  void initState() {
    usernameController.text = 'omaralafa';
    passwordController.text = 'Rappelzkobo1996';
    serverUrlController.text = 'https://eu.kobotoolbox.org';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size screenSize = MediaQuery.of(context).size;

    Widget loginButton() {
      return FilledButton.icon(
        onPressed: () {
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
            strokeCap: StrokeCap.round,
            color: theme.colorScheme.onPrimary,
            strokeWidth: 2,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: TextButton.icon(
          icon: Icon(Icons.language),
          label: Text(context.tr(context.locale.languageCode)),
          onPressed: () => context.pushNamed(Routes.languagesScreen),
        ),
        // actions: const [
        //   ThemeToggleIconWidget(),
        //   SizedBox(width: 16),
        // ],
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
            padding: const EdgeInsets.all(16),
            child: AutofillGroup(
              child: ListView(
                children: [
                  SizedBox(height: 72),
                  SvgPicture.asset(
                    'assets/svg/kobo_logo.svg',
                    width: screenSize.width / 1.5,
                  ),
                  SizedBox(height: 72),

                  TextField(
                    controller: serverUrlController,
                    decoration: InputDecoration(
                      hintText: 'https://eu.kobotoolbox.org',
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      prefixIcon: const Icon(Icons.dns),
                      suffixIcon: PopupMenuButton<String>(
                        icon: const Icon(Icons.arrow_drop_down),
                        onSelected: (String value) {
                          serverUrlController.text = value;
                        },
                        itemBuilder: (BuildContext context) {
                          return Constants.koboServersList.map((String value) {
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
                  ),
                  SizedBox(height: 24),
                  TextField(
                    controller: usernameController,
                    autofillHints: const [AutofillHints.username],
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      prefixIcon: const Icon(Icons.person),
                      labelText: context.tr('username'),
                      filled: true,
                      fillColor: theme.colorScheme.onInverseSurface,
                    ),
                  ),
                  SizedBox(height: 24),
                  TextField(
                    controller: passwordController,
                    obscureText: _obscured,
                    autofillHints: const [AutofillHints.password],
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      labelText: context.tr('password'),
                      filled: true,
                      fillColor: theme.colorScheme.onInverseSurface,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscured ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          _obscured = !_obscured;
                          if (mounted) setState(() {});
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
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
                  SizedBox(height: 24),
                  state.maybeWhen(
                    loading: loadingButton,
                    success: loginSuccessButton,
                    orElse: loginButton,
                  ),

                  SizedBox(height: 12),
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
                              content: Text(context.tr('noSavedAccounts')),
                            ),
                          );
                        });
                      }
                    },
                    label: Text(context.tr('savedAccounts')),
                    icon: Icon(Icons.group),
                  ),
                  SizedBox(height: 24),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(text: "${context.tr('dontHaveAccount')}  "),
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
                  SizedBox(height: 48),

                  state.maybeWhen(
                    error:
                        (msg) => Text(
                          msg,
                          style: TextStyle(color: theme.colorScheme.error),
                          textAlign: TextAlign.center,
                        ),
                    orElse: () => SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
