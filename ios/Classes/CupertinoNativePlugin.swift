import Flutter
import UIKit

public class CupertinoNativePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "cupertino_native", binaryMessenger: registrar.messenger())
    let instance = CupertinoNativePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    // Register platform view factories
    let sliderFactory = CupertinoSliderViewFactory(messenger: registrar.messenger())
    registrar.register(sliderFactory, withId: "CupertinoNativeSlider")

    let switchFactory = CupertinoSwitchViewFactory(messenger: registrar.messenger())
    registrar.register(switchFactory, withId: "CupertinoNativeSwitch")

    // Segmented control
    let segmentedFactory = CupertinoSegmentedControlViewFactory(messenger: registrar.messenger())
    registrar.register(segmentedFactory, withId: "CupertinoNativeSegmentedControl")

    let iconFactory = CupertinoIconViewFactory(messenger: registrar.messenger())
    registrar.register(iconFactory, withId: "CupertinoNativeIcon")

    let tabBarFactory = CupertinoTabBarViewFactory(messenger: registrar.messenger())
    registrar.register(tabBarFactory, withId: "CupertinoNativeTabBar")

    let popupMenuFactory = CupertinoPopupMenuButtonViewFactory(messenger: registrar.messenger())
    registrar.register(popupMenuFactory, withId: "CupertinoNativePopupMenuButton")

    let buttonFactory = CupertinoButtonViewFactory(messenger: registrar.messenger())
    registrar.register(buttonFactory, withId: "CupertinoNativeButton")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
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

  private func topViewController(from root: UIViewController?) -> UIViewController? {
    var rootVC = root
    while let presented = rootVC?.presentedViewController {
      rootVC = presented
    }
    return rootVC
  }

  private func currentRootViewController() -> UIViewController? {
    if #available(iOS 13.0, *) {
      let windowScene = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .first { $0.activationState == .foregroundActive }
      let window = windowScene?.windows.first { $0.isKeyWindow }
      return topViewController(from: window?.rootViewController)
    } else {
      let window = UIApplication.shared.keyWindow
      return topViewController(from: window?.rootViewController)
    }
  }

  private func presentAlert(with args: [String: Any], result: @escaping FlutterResult) {
    let title = args["title"] as? String
    let message = args["message"] as? String
    let styleStr = (args["style"] as? String) ?? "alert"
    let isActionSheet = styleStr == "actionSheet"

    let alertStyle: UIAlertController.Style = isActionSheet ? .actionSheet : .alert
    let alert = UIAlertController(title: title, message: message, preferredStyle: alertStyle)

    var resultSent = false
    func sendResult(_ index: Int?) {
      guard !resultSent else { return }
      resultSent = true
      result(index)
    }

    if let actions = args["actions"] as? [[String: Any]] {
      for (idx, actionDict) in actions.enumerated() {
        let label = (actionDict["label"] as? String) ?? "OK"
        let styleStr = (actionDict["style"] as? String) ?? "default"
        let style: UIAlertAction.Style
        switch styleStr {
        case "cancel": style = .cancel
        case "destructive": style = .destructive
        default: style = .default
        }
        let action = UIAlertAction(title: label, style: style) { _ in
          sendResult(idx)
        }
        alert.addAction(action)
      }
    } else {
      alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in sendResult(0) })
    }

    guard let presenter = currentRootViewController() else {
      result(FlutterError(code: "no_root_vc", message: "Unable to find root view controller", details: nil))
      return
    }

    if let popover = alert.popoverPresentationController, alert.preferredStyle == .actionSheet {
      popover.sourceView = presenter.view
      popover.sourceRect = CGRect(x: presenter.view.bounds.midX, y: presenter.view.bounds.midY, width: 0, height: 0)
      popover.permittedArrowDirections = []
    }

    presenter.present(alert, animated: true, completion: nil)
  }
}
 
