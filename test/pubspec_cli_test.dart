import 'package:test/test.dart';

void main() {
  test('calculate', () {
    String oriString = """name: apollo
description: A new Flutter project.
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.6 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.6
  package_info_plus: ^4.1.0
  flutter_easyloading: ^3.0.5
  common_utils: ^2.1.0
  sp_util: ^2.0.3
  easy_localization: ^3.0.3
  shared_preferences: ^2.2.1
  lottie: ^2.6.0
  url_launcher: ^6.1.14
  open_filex: ^4.3.4
  crypto: ^3.0.3
  lifecycle: ^0.8.0
  http: ^1.1.0
  camera: ^0.10.5+5
  app_settings: ^5.1.1
  images_picker: ^1.2.11
  flutter_html: ^3.0.0-beta.2
  reorderable_grid_view: ^2.2.7
  connectivity_plus: ^5.0.1
  truncate: ^3.0.1
  path_provider: ^2.1.1
  permission_handler: ^11.0.1
  flutter_app_badger: ^1.5.0
  tuple: ^2.0.2
  fluttertoast: ^8.2.4
  keyboard_actions: ^4.2.0
  modal_bottom_sheet: ^3.0.0-pre
  flutter_cupertino_date_picker_fork: ^1.0.7
  uuid: ^4.2.1
  firebase_core: ^2.23.0
  google_sign_in: ^6.1.6
  fbroadcast: ^2.0.0
  firebase_messaging: ^14.7.6
  flutter_local_notifications: ^16.2.0
  geolocator: ^10.1.0
  flutter_swipe_action_cell: ^3.1.3
  aad_oauth: ^1.0.0
  auto_size_text: ^3.0.0
  webview_flutter: ^4.4.2
  flutter_inappwebview: ^6.0.0
  webview_flutter_wkwebview: ^3.10.1
  qr_code_scanner: ^1.0.1
  amplify_api: ^1.6.2
  amplify_auth_cognito: ^1.6.1
  amplify_authenticator: ^1.5.2
  amplify_flutter: ^1.6.1
  table_calendar: ^3.0.9
  pubspec_helper: ^1.0.3

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^2.0.0

flutter:

  uses-material-design: true

  assets:
    - assets/images/
    - assets/images/app_bar/
    - assets/images/icon/
    - assets/images/PeopleSearch/
    - assets/images/mydata/
    - assets/images/announcement/
    - assets/images/post_note/
    - assets/images/home/
    - assets/images/home/icon/
    - assets/images/punch/
    - assets/images/punch_photo/
    - assets/i18n/
    - assets/html/
""";

    bool isStart = false;
    List<String> rtn = [];
    for (int i = 0; i < oriString.split("\n").length; i++) {
      if (oriString.split("\n")[i].trim().startsWith("dependencies")) {
        isStart = true;
        continue;
      }
      if (isStart &&
          oriString.split("\n")[i].trim().split(":").length == 2 &&
          oriString.split("\n")[i].trim().split(":")[1].contains(".")) {
        rtn.add(oriString.split("\n")[i].trim().split(":")[0].trim());
      }

      if (isStart &&
          oriString.split("\n")[i] != "" &&
          !oriString.split("\n")[i].startsWith("  ")) {
        isStart = false;
      }
    }

    for (String e in rtn) {
      if (e.trim().startsWith("#") || e.trim().isEmpty) {
        continue;
      }
      print(e.split(":")[0].trim());
      print("\n");
    }
  });
}
