// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

void showSnackBar(BuildContext context, String message) {
  final snackbar = SnackBar(
    content: Text(message),
    behavior: SnackBarBehavior.fixed,
    duration: const Duration(seconds: 4),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

class AdvertisementImage extends StatelessWidget {
  final String imageUrl;
  const AdvertisementImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const SizedBox.shrink();
    }
    if (imageUrl != '/i/pix.gif') {
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Image.network(
          'https://jobs.ge$imageUrl',
          fit: BoxFit.fitWidth,
          width: 60,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
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
      width: width ?? 32,
      decoration: BoxDecoration(
          color: color ??
              Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
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
          maxWidth: 700, maxHeight: MediaQuery.of(context).size.height * 0.9),
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      context: context,
      builder: (context) {
        return SingleChildScrollView(
            child: Container(
          padding: MediaQuery.of(context).viewPadding +
              MediaQuery.of(context).viewInsets +
              const EdgeInsets.fromLTRB(20, 17, 20, 0),
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

Future<void> sendEmail(
    String subject, String recipient, String attachment) async {
  final Email email = Email(
    subject: subject,
    recipients: [recipient],
    attachmentPaths: attachment != '' ? [attachment] : [],
  );

  await FlutterEmailSender.send(email);
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
