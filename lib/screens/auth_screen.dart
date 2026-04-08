import 'package:fl_kanban/providers/auth_mode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(authModeProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.gray,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(LucideIcons.layoutDashboard, size: 32),
        ),
        const Gap(16),
        const Text("Kanban Board").x2Large.bold,
        const Text("The editorial workspace for modern teams").small.muted,
        const Gap(16),
        switch (mode) {
          AuthMode.signIn => SignInForm(mode: mode),
          AuthMode.signUp => SignUpForm(mode: mode),
          AuthMode.forgotPassword => ForgotPasswordForm(mode: mode),
        },
      ],
    );
  }
}

class SignInForm extends ConsumerWidget {
  final AuthMode mode;

  const SignInForm({super.key, required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(authModeProvider.notifier);

    return SizedBox(
      width: 420,
      child: Column(
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("Sign In").large.semiBold,
                const Text("Welcome back to your workspace.").small.muted,
                const Gap(16),
                const FormField(
                  key: FormKey(#emailAddress),
                  label: Text("Email Address"),
                  validator: NonNullValidator(
                    message: "Please provide valid email address.",
                  ),
                  child: TextField(placeholder: Text("example@example.com")),
                ),
                const Gap(16),
                FormField(
                  key: const FormKey(#password),
                  label: const Text("Password"),
                  trailingLabel: LinkButton(
                    onPressed: () {
                      notifier.state = AuthMode.forgotPassword;
                    },
                    density: ButtonDensity.iconDense,
                    child: const Text("Forgot password?"),
                  ),
                  validator: const NonNullValidator(
                    message: "Please provide valid password.",
                  ),
                  child: const TextField(placeholder: Text("********")),
                ),
                const Gap(16),
                PrimaryButton(
                  onPressed: () {
                    context.pushNamed("projects");
                  },
                  alignment: Alignment.center,
                  child: const Text("Sign In"),
                ),
                const Gap(16),
                const Text("OR CONTINUE WITH").center().muted.semiBold,
                const Gap(16),
                OutlineButton(
                  onPressed: () {
                    context.pushNamed("projects");
                  },
                  alignment: Alignment.center,
                  child: const Text("Google"),
                ),
                const Gap(16),
                OutlineButton(
                  onPressed: () {
                    context.pushNamed("projects");
                  },
                  alignment: Alignment.center,
                  child: const Text("Github"),
                ),
              ],
            ),
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              const Gap(4),
              LinkButton(
                onPressed: () {
                  notifier.state = AuthMode.signUp;
                },
                density: ButtonDensity.iconDense,
                child: const Text("Sign Up"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SignUpForm extends ConsumerWidget {
  final AuthMode mode;

  const SignUpForm({super.key, required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(authModeProvider.notifier);

    return SizedBox(
      width: 420,
      child: Column(
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("Sign Up").large.semiBold,
                const Text("Welcome back to your workspace.").small.muted,
                const Gap(16),
                const FormField(
                  key: FormKey(#emailAddress),
                  label: Text("Email Address"),
                  validator: NonNullValidator(
                    message: "Please provide valid email address.",
                  ),
                  child: TextField(placeholder: Text("example@example.com")),
                ),
                const Gap(16),
                FormField(
                  key: const FormKey(#password),
                  label: const Text("Password"),
                  validator: const NonNullValidator(
                    message: "Please provide valid password.",
                  ),
                  child: const TextField(placeholder: Text("********")),
                ),
                const Gap(16),
                FormField(
                  key: const FormKey(#repeatPassword),
                  label: const Text("Repeat Password"),
                  validator: const NonNullValidator(
                    message: "Please provide repeat password.",
                  ),
                  child: const TextField(placeholder: Text("********")),
                ),
                const Gap(16),
                const Text(
                  "By registering, you agree to our Terms of Service and Privacy Policy",
                ).small.muted,
                const Gap(16),
                PrimaryButton(
                  onPressed: () {
                    context.pushNamed("projects");
                  },
                  alignment: Alignment.center,
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?"),
              const Gap(4),
              LinkButton(
                onPressed: () {
                  notifier.state = AuthMode.signIn;
                },
                density: ButtonDensity.iconDense,
                child: const Text("Sign In"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ForgotPasswordForm extends ConsumerWidget {
  final AuthMode mode;

  const ForgotPasswordForm({super.key, required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(authModeProvider.notifier);
    final emailController = TextEditingController();

    return SizedBox(
      width: 420,
      child: Column(
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("Forgot Password").large.semiBold,
                const Gap(16),
                FormField(
                  key: const FormKey(#emailAddress),
                  label: const Text("Email Address"),
                  validator: const NonNullValidator(
                    message: "Please provide valid email address.",
                  ),
                  child: TextField(
                    controller: emailController,
                    placeholder: const Text("example@example.com"),
                  ),
                ),
                const Gap(16),
                PrimaryButton(
                  onPressed: () {
                    showToast(
                      context: context,
                      location: ToastLocation.bottomRight,
                      builder: (context, overlay) {
                        return SurfaceCard(
                          child: Basic(
                            title: Text(
                              "Instructions send to ${emailController.text}",
                            ),
                          ),
                        );
                      },
                    );
                    notifier.state = AuthMode.signIn;
                  },
                  alignment: Alignment.center,
                  child: const Text("Send Instructions"),
                ),
              ],
            ),
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?"),
              const Gap(4),
              LinkButton(
                onPressed: () {
                  notifier.state = AuthMode.signIn;
                },
                density: ButtonDensity.iconDense,
                child: const Text("Sign In"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
