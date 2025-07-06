import Flutter
import UIKit
import Photos

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let galleryChannel = FlutterMethodChannel(name: "gallery_saver",
                                              binaryMessenger: controller.binaryMessenger)
    galleryChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "saveImageToGallery":
        if let args = call.arguments as? [String: Any],
           let imagePath = args["imagePath"] as? String {
          self.saveImageToGallery(imagePath: imagePath, result: result)
        } else {
          result(FlutterError(code: "INVALID_ARGUMENT",
                             message: "Image path is null",
                             details: nil))
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func saveImageToGallery(imagePath: String, result: @escaping FlutterResult) {
    let status = PHPhotoLibrary.authorizationStatus()
    
    switch status {
    case .authorized:
      saveImageToGalleryInternal(imagePath: imagePath, result: result)
    case .limited:
      if #available(iOS 14, *) {
        saveImageToGalleryInternal(imagePath: imagePath, result: result)
      } else {

        result(false)
      }
    case .notDetermined:
      PHPhotoLibrary.requestAuthorization { [weak self] newStatus in
        DispatchQueue.main.async {
          if newStatus == .authorized {
            self?.saveImageToGalleryInternal(imagePath: imagePath, result: result)
          } else if #available(iOS 14, *), newStatus == .limited {
            self?.saveImageToGalleryInternal(imagePath: imagePath, result: result)
          } else {
            result(false)
          }
        }
      }
    case .denied, .restricted:
      result(false)
    @unknown default:
      result(false)
    }
  }
  
  private func saveImageToGalleryInternal(imagePath: String, result: @escaping FlutterResult) {
    guard let image = UIImage(contentsOfFile: imagePath) else {
      result(false)
      return
    }
    
    PHPhotoLibrary.shared().performChanges({
      PHAssetChangeRequest.creationRequestForAsset(from: image)
    }) { success, error in
      DispatchQueue.main.async {
        if success {
          result(true)
        } else {
          print("Error saving image to gallery: \(error?.localizedDescription ?? "Unknown error")")
          result(false)
        }
      }
    }
  }
}
