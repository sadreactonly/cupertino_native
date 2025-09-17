import Cocoa
import FlutterMacOS

public class CupertinoNativePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "cupertino_native", binaryMessenger: registrar.messenger)
    let instance = CupertinoNativePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    let sliderFactory = CupertinoSliderViewFactory(messenger: registrar.messenger)
    registrar.register(sliderFactory, withId: "CupertinoNativeSlider")

    let switchFactory = CupertinoSwitchViewFactory(messenger: registrar.messenger)
    registrar.register(switchFactory, withId: "CupertinoNativeSwitch")

    let segmentedFactory = CupertinoSegmentedControlViewFactory(messenger: registrar.messenger)
    registrar.register(segmentedFactory, withId: "CupertinoNativeSegmentedControl")

    let iconFactory = CupertinoIconViewFactory(messenger: registrar.messenger)
    registrar.register(iconFactory, withId: "CupertinoNativeIcon")

    let tabBarFactory = CupertinoTabBarViewFactory(messenger: registrar.messenger)
    registrar.register(tabBarFactory, withId: "CupertinoNativeTabBar")

    let popupMenuFactory = CupertinoPopupMenuButtonViewFactory(messenger: registrar.messenger)
    registrar.register(popupMenuFactory, withId: "CupertinoNativePopupMenuButton")

    let buttonFactory = CupertinoButtonViewFactory(messenger: registrar.messenger)
    registrar.register(buttonFactory, withId: "CupertinoNativeButton")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
    case "showAlert":
      guard let args = call.arguments as? [String: Any] else {
        result(FlutterError(code: "bad_args", message: "Expected map for showAlert", details: nil))
        return
      }
      presentAlert(with: args, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func presentAlert(with args: [String: Any], result: @escaping FlutterResult) {
    let alert = NSAlert()
    if let title = args["title"] as? String { alert.messageText = title }
    if let message = args["message"] as? String { alert.informativeText = message }
    alert.alertStyle = .informational

    var hasActions = false
    if let actions = args["actions"] as? [[String: Any]] {
      hasActions = !actions.isEmpty
      for action in actions {
        let label = (action["label"] as? String) ?? "OK"
        alert.addButton(withTitle: label)
      }
    }
    if !hasActions {
      alert.addButton(withTitle: "OK")
    }

    if let window = NSApp.keyWindow {
      alert.beginSheetModal(for: window) { response in
        // NSApplication.ModalResponse for first button is .alertFirstButtonReturn (1000)
        let base = NSApplication.ModalResponse.alertFirstButtonReturn.rawValue
        let index = Int(response.rawValue - base)
        result(index)
      }
    } else {
      let response = alert.runModal()
      let base = NSApplication.ModalResponse.alertFirstButtonReturn.rawValue
      let index = Int(response.rawValue - base)
      result(index)
    }
  }
}
