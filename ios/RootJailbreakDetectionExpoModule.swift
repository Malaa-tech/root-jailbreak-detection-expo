import ExpoModulesCore
import Foundation

public class RootJailbreakDetectionExpoModule: Module {

    public func definition() -> ModuleDefinition {

        Name("RootJailbreakDetectionExpo")

        AsyncFunction("detectJailbreak") { (promise:Promise) in
            let isJailbroken = UIDevice.current.isJailbroken
            promise.resolve(isJailbroken)
            return UIDevice.current.isJailbroken
        }
    }

}
