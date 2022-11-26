// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:scale_button/scale_button.dart' as scl;
import 'package:url_launcher/url_launcher.dart' as url_launcher;

void showSnackBar(BuildContext context, String message) {
  final snackbar = SnackBar(
    content: Text(message),
    behavior: SnackBarBehavior.fixed,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

class CircularButton extends StatelessWidget {
  final Widget icon;
  final void Function() onPressed;
  final double? radius;
  final Color? backgroundColor;

  const CircularButton(
      {Key? key,
      required this.icon,
      required this.onPressed,
      this.radius,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return scl.ScaleButton(
      bound: 0.07,
      duration: const Duration(milliseconds: 150),
      child: CircleAvatar(
        radius: radius ?? 30,
        backgroundColor: backgroundColor ?? const Color.fromARGB(12, 0, 0, 0),
        child: SizedBox(
          width: radius != null ? radius! * 2 : 60,
          height: radius != null ? radius! * 2 : 60,
          child: IconButton(
            color: Theme.of(context).primaryColor,
            icon: icon,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}

class ScalingButton extends StatelessWidget {
  final Widget child;
  final Function? onPressed;
  const ScalingButton({super.key, required this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return scl.ScaleButton(
      bound: 0.07,
      onTap: () {
        if (onPressed != null) {
          onPressed!();
        }
      },
      duration: const Duration(milliseconds: 150),
      child: child,
    );
  }
}

class DragHandlePill extends StatelessWidget {
  final Color? color;
  final double? height;
  final double? width;
  const DragHandlePill({
    Key? key,
    this.color,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 4,
      width: width ?? 30,
      decoration: BoxDecoration(
          color: color ?? Colors.grey[400],
          borderRadius: BorderRadius.circular(2.5)),
    );
  }
}

class MyOutlineButton extends StatelessWidget {
  final Widget child;
  final Widget? icon;
  final Color? color;
  final Color? borderColor;
  final Function onPressed;
  const MyOutlineButton({
    Key? key,
    required this.child,
    this.icon,
    this.color,
    required this.onPressed,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return OutlinedButton.icon(
          onPressed: () {
            onPressed();
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: borderColor ?? Theme.of(context).primaryColorLight,
              style: BorderStyle.solid,
            ),
          ),
          icon: icon!,
          label: child);
    }
    return OutlinedButton(
      onPressed: () {
        onPressed();
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: borderColor ?? Theme.of(context).primaryColorLight,
          style: BorderStyle.solid,
        ),
      ),
      child: child,
    );
  }
}

Future<dynamic> showMyBottomDialog(
    BuildContext context, List<Widget> children, Key formKey) {
  return showModalBottomSheet(
      constraints: BoxConstraints(
          maxWidth: 700, maxHeight: MediaQuery.of(context).size.height * 0.8),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        return SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 17, 20, 20),
              child: Form(
                key: formKey,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const DragHandlePill(),
                  const SizedBox(
                    height: 20,
                  ),
                  ...children
                ]),
              ),
            ));
      });
}

Future<void> openIntent(BuildContext context, String _url) async {
  if (!await url_launcher.launchUrl(Uri.parse(_url))) {
    showSnackBar(context, 'შეცდომა!');
    throw 'Could not launch $_url';
  }
}

Future<void> launchWebUrl(BuildContext context, String url) async {
  final theme = Theme.of(context);
  try {
    await launch(
      url,
      customTabsOption: CustomTabsOption(
        enableInstantApps: true,
        toolbarColor: theme.primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        extraCustomTabs: const <String>[
          // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
          'org.mozilla.firefox',
          // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
          'com.microsoft.emmx',
        ],
      ),
      safariVCOption: SafariViewControllerOption(
        preferredBarTintColor: theme.primaryColor,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
  }
}
