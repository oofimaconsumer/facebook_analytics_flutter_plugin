import Flutter
import UIKit
import FBSDKCoreKit


public class SwiftFacebookAnalyticsPlugin: NSObject, FlutterPlugin {
    
    // MARK - Public
    
    // MARK Overrides
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "facebook_analytics_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftFacebookAnalyticsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "logCustomEvent":
            handleLogEvent(with: call)
            result(nil)
        case "logCompletedRegistration":
            logCompletedRegistration()
            result(nil)
        case "logCompletedPurchase":
            logCompletedPurchase(with: call)
            result(nil)
        case "setUserData":
            setAndHash(with: call)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK - Private
    
    // MARK Log handlers
    
    fileprivate func handleLogEvent(with call: FlutterMethodCall) {
        let parameters = call.arguments as! [String:Any]
        let eventName = parameters["name"] as! String
        if var optionalParams = parameters["parameters"] as? [String:Any] {
            optionalParams = serializeParameterDict(paramDict: optionalParams)
            AppEvents.logEvent(AppEvents.Name(eventName), parameters: optionalParams)
        } else {
            AppEvents.logEvent(AppEvents.Name(eventName))
        }
    }
    
    fileprivate func logCompletedRegistration() {
        AppEvents.logEvent(AppEvents.Name.completedRegistration)
    }
    
    fileprivate func logCompletedPurchase(with call: FlutterMethodCall) {
        guard let arguments = call.arguments as? [String : Any], let parameters = arguments["parameters"] as? [String : Any], let amount = parameters["amount"] as? Double, let currency = parameters["currency"] as? String else { return }
        AppEvents.logPurchase(amount, currency: currency)
    }
    
    fileprivate func setAndHash(with call: FlutterMethodCall) {
        guard let arguments = call.arguments as? [String : [String : String]], let parameters = arguments["parameters"] else { return }
        AppEvents.setUser(email: parameters["email"], firstName: parameters["firstName"], lastName: parameters["lastName"], phone: parameters["phone"], dateOfBirth: parameters["dateOfBirth"], gender: parameters["gender"], city: parameters["city"], state: parameters["state"], zip: parameters["zip"], country: parameters["country"])
    }
    
    // MARK Helpers

    fileprivate func serializeParameterDict(paramDict: [String:Any]) -> [String:Any] {
        var convertedParams : [String :Any] = [:]
        for (key, val ) in paramDict {
            switch val {
                case let i as Int:
                    convertedParams.updateValue(NSNumber(value: i) , forKey: key)
                    break
                case let s as String:
                    convertedParams.updateValue(NSString(string: s ), forKey: key)
                    break
                case let d as Double:
                    convertedParams.updateValue(NSNumber(value: d), forKey: key)
                    break
                case let b as Bool:
                    convertedParams.updateValue(NSNumber(value: b ), forKey: key)
                    break
                default:
                    print("Type not supported: ")
                    print(type(of: val))
            }
        }
        return convertedParams
    }
}
