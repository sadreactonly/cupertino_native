import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Presentation styles for native alerts.
enum CNAlertPresentationStyle {
  /// Standard alert dialog.
  alert,

  /// Action sheet (bottom sheet style on iOS).
  actionSheet,
}

/// Action style for alert buttons.
enum CNAlertActionStyle {
  /// Default action.
  normal,
  /// Cancel action (dismisses the dialog).
  cancel,
  /// Destructive action (renders in red where supported).
  destructive,
}

/// Describes an action in a [CNAlertDialog].
class CNAlertAction {
  const CNAlertAction({required this.label, this.style = CNAlertActionStyle.normal});

  final String label;
  final CNAlertActionStyle style;
}

/// Native Cupertino alert and action sheet presentation.
class CNAlertDialog {
  static const MethodChannel _channel = MethodChannel('cupertino_native');

  /// Shows a native alert or action sheet and returns the selected index.
  /// Returns null if dismissed without selecting an explicit action.
  static Future<int?> show({
    required BuildContext context,
    String? title,
    String? message,
    required List<CNAlertAction> actions,
    CNAlertPresentationStyle style = CNAlertPresentationStyle.alert,
  }) async {
    assert(actions.isNotEmpty, 'At least one action is required');
    final args = <String, dynamic>{
      if (title != null) 'title': title,
      if (message != null) 'message': message,
      'style': style == CNAlertPresentationStyle.alert ? 'alert' : 'actionSheet',
      'actions': actions.map((a) {
        String styleStr = 'default';
        switch (a.style) {
          case CNAlertActionStyle.normal:
            styleStr = 'default';
            break;
          case CNAlertActionStyle.cancel:
            styleStr = 'cancel';
            break;
          case CNAlertActionStyle.destructive:
            styleStr = 'destructive';
            break;
        }
        return {'label': a.label, 'style': styleStr};
      }).toList(),
    };

    final int? index = await _channel.invokeMethod<int>('showAlert', args);
    return index;
  }
}
