import ExpoModulesCore
import Foundation

public class RootJailbreakDetectionExpoModule: Module {

    public func definition() -> ModuleDefinition {

        Name("RootJailbreakDetectionExpo")

        AsyncFunction("detectJailbreak") { (promise:Promise) in
            let isUIDeviceJailbroken = UIDevice.current.isJailbroken
            let isFridaJailbroken = FridaDetection.init().isFridaDetected
            promise.resolve(isUIDeviceJailbroken || isFridaJailbroken)
            return isUIDeviceJailbroken || isFridaJailbroken
        }
    }

}
