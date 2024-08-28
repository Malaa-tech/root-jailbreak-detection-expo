import UIKit

struct ExpoDeviceType {
    let modelName: String
    let deviceYearClass: Int?
}

public extension UIDevice {
    static let modelIdentifier: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }()

    internal static let deviceInfo: ExpoDeviceType = {
        let currentYear = Calendar(identifier: .gregorian).component(.year, from: Date())
        return mapToDevice(identifier: modelIdentifier, currentYear: currentYear)
    }()

    var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }

    var isJailbroken: Bool {
        guard !isSimulator else { return false }
        return JailbreakHelper.hasCydiaInstalled() ||
               JailbreakHelper.doesSuspiciousFileExist() ||
               JailbreakHelper.canEditSystemFiles()
    }
}

private func mapToDevice(identifier: String, currentYear: Int) -> ExpoDeviceType {
    switch identifier {
    // iPhones
    case "iPhone6,1", "iPhone6,2": return ExpoDeviceType(modelName: "iPhone 5s", deviceYearClass: 2013)
    case "iPhone7,2": return ExpoDeviceType(modelName: "iPhone 6", deviceYearClass: 2014)
    case "iPhone7,1": return ExpoDeviceType(modelName: "iPhone 6 Plus", deviceYearClass: 2014)
    case "iPhone8,1": return ExpoDeviceType(modelName: "iPhone 6s", deviceYearClass: 2015)
    case "iPhone8,2": return ExpoDeviceType(modelName: "iPhone 6s Plus", deviceYearClass: 2015)
    case "iPhone9,1", "iPhone9,3": return ExpoDeviceType(modelName: "iPhone 7", deviceYearClass: 2016)
    case "iPhone9,2", "iPhone9,4": return ExpoDeviceType(modelName: "iPhone 7 Plus", deviceYearClass: 2016)
    case "iPhone10,1", "iPhone10,4": return ExpoDeviceType(modelName: "iPhone 8", deviceYearClass: 2017)
    case "iPhone10,2", "iPhone10,5": return ExpoDeviceType(modelName: "iPhone 8 Plus", deviceYearClass: 2017)
    case "iPhone10,3", "iPhone10,6": return ExpoDeviceType(modelName: "iPhone X", deviceYearClass: 2017)
    case "iPhone11,2": return ExpoDeviceType(modelName: "iPhone XS", deviceYearClass: 2018)
    case "iPhone11,4", "iPhone11,6": return ExpoDeviceType(modelName: "iPhone XS Max", deviceYearClass: 2018)
    case "iPhone11,8": return ExpoDeviceType(modelName: "iPhone XR", deviceYearClass: 2018)
    case "iPhone12,1": return ExpoDeviceType(modelName: "iPhone 11", deviceYearClass: 2019)
    case "iPhone12,3": return ExpoDeviceType(modelName: "iPhone 11 Pro", deviceYearClass: 2019)
    case "iPhone12,5": return ExpoDeviceType(modelName: "iPhone 11 Pro Max", deviceYearClass: 2019)
    case "iPhone13,1": return ExpoDeviceType(modelName: "iPhone 12 mini", deviceYearClass: 2020)
    case "iPhone13,2": return ExpoDeviceType(modelName: "iPhone 12", deviceYearClass: 2020)
    case "iPhone13,3": return ExpoDeviceType(modelName: "iPhone 12 Pro", deviceYearClass: 2020)
    case "iPhone13,4": return ExpoDeviceType(modelName: "iPhone 12 Pro Max", deviceYearClass: 2020)
    case "iPhone14,4": return ExpoDeviceType(modelName: "iPhone 13 mini", deviceYearClass: 2021)
    case "iPhone14,5": return ExpoDeviceType(modelName: "iPhone 13", deviceYearClass: 2021)
    case "iPhone14,2": return ExpoDeviceType(modelName: "iPhone 13 Pro", deviceYearClass: 2021)
    case "iPhone14,3": return ExpoDeviceType(modelName: "iPhone 13 Pro Max", deviceYearClass: 2021)
    case "iPhone14,7": return ExpoDeviceType(modelName: "iPhone 14", deviceYearClass: 2022)
    case "iPhone14,8": return ExpoDeviceType(modelName: "iPhone 14 Plus", deviceYearClass: 2022)
    case "iPhone15,2": return ExpoDeviceType(modelName: "iPhone 14 Pro", deviceYearClass: 2022)
    case "iPhone15,3": return ExpoDeviceType(modelName: "iPhone 14 Pro Max", deviceYearClass: 2022)
    case "iPhone15,4": return ExpoDeviceType(modelName: "iPhone 15", deviceYearClass: 2023)
    case "iPhone15,5": return ExpoDeviceType(modelName: "iPhone 15 Plus", deviceYearClass: 2023)
    case "iPhone16,1": return ExpoDeviceType(modelName: "iPhone 15 Pro", deviceYearClass: 2023)
    case "iPhone16,2": return ExpoDeviceType(modelName: "iPhone 15 Pro Max", deviceYearClass: 2023)
    
    // iPads
    case "iPad6,11", "iPad6,12": return ExpoDeviceType(modelName: "iPad (5th generation)", deviceYearClass: 2017)
    case "iPad7,5", "iPad7,6": return ExpoDeviceType(modelName: "iPad (6th generation)", deviceYearClass: 2018)
    case "iPad7,11", "iPad7,12": return ExpoDeviceType(modelName: "iPad (7th generation)", deviceYearClass: 2019)
    case "iPad11,6", "iPad11,7": return ExpoDeviceType(modelName: "iPad (8th generation)", deviceYearClass: 2020)
    case "iPad12,1", "iPad12,2": return ExpoDeviceType(modelName: "iPad (9th generation)", deviceYearClass: 2021)
    case "iPad13,18", "iPad13,19": return ExpoDeviceType(modelName: "iPad (10th generation)", deviceYearClass: 2022)
    
    // iPad Air
    case "iPad4,1", "iPad4,2", "iPad4,3": return ExpoDeviceType(modelName: "iPad Air", deviceYearClass: 2013)
    case "iPad5,3", "iPad5,4": return ExpoDeviceType(modelName: "iPad Air 2", deviceYearClass: 2014)
    case "iPad11,3", "iPad11,4": return ExpoDeviceType(modelName: "iPad Air (3rd generation)", deviceYearClass: 2019)
    case "iPad13,1", "iPad13,2": return ExpoDeviceType(modelName: "iPad Air (4th generation)", deviceYearClass: 2020)
    case "iPad13,16", "iPad13,17": return ExpoDeviceType(modelName: "iPad Air (5th generation)", deviceYearClass: 2022)
    
    // iPad Pro
    case "iPad6,3", "iPad6,4": return ExpoDeviceType(modelName: "iPad Pro (9.7-inch)", deviceYearClass: 2016)
    case "iPad7,3", "iPad7,4": return ExpoDeviceType(modelName: "iPad Pro (10.5-inch)", deviceYearClass: 2017)
    case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return ExpoDeviceType(modelName: "iPad Pro (11-inch) (1st generation)", deviceYearClass: 2018)
    case "iPad8,9", "iPad8,10": return ExpoDeviceType(modelName: "iPad Pro (11-inch) (2nd generation)", deviceYearClass: 2020)
    case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7": return ExpoDeviceType(modelName: "iPad Pro (11-inch) (3rd generation)", deviceYearClass: 2021)
    case "iPad14,3-A", "iPad14,3-B", "iPad14,4-A", "iPad14,4-B": return ExpoDeviceType(modelName: "iPad Pro (11-inch) (4th generation)", deviceYearClass: 2022)
    case "iPad6,7", "iPad6,8": return ExpoDeviceType(modelName: "iPad Pro (12.9-inch) (1st generation)", deviceYearClass: 2015)
    case "iPad7,1", "iPad7,2": return ExpoDeviceType(modelName: "iPad Pro (12.9-inch) (2nd generation)", deviceYearClass: 2017)
    case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return ExpoDeviceType(modelName: "iPad Pro (12.9-inch) (3rd generation)", deviceYearClass: 2018)
    case "iPad8,11", "iPad8,12": return ExpoDeviceType(modelName: "iPad Pro (12.9-inch) (4th generation)", deviceYearClass: 2020)
    case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11": return ExpoDeviceType(modelName: "iPad Pro (12.9-inch) (5th generation)", deviceYearClass: 2021)
    case "iPad14,5-A", "iPad14,5-B", "iPad14,6-A", "iPad14,6-B": return ExpoDeviceType(modelName: "iPad Pro (12.9-inch) (6th generation)", deviceYearClass: 2022)
    
    // iPod touch
    case "iPod7,1": return ExpoDeviceType(modelName: "iPod touch (6th generation)", deviceYearClass: 2015)
    case "iPod9,1": return ExpoDeviceType(modelName: "iPod touch (7th generation)", deviceYearClass: 2019)
    
    // Simulator
    case "i386", "x86_64", "arm64": return ExpoDeviceType(modelName: "Simulator iOS", deviceYearClass: currentYear)
    
    // Default case
    default: return ExpoDeviceType(modelName: identifier, deviceYearClass: currentYear)
    }
}

private struct JailbreakHelper {
    static func hasCydiaInstalled() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "cydia://")!)
    }

    static func doesSuspiciousFileExist() -> Bool {
        return suspiciousFiles.contains { FileManager.default.fileExists(atPath: $0) }
    }

    static func canEditSystemFiles() -> Bool {
        let jailbreakText = "Developer Insider"
        do {
            try jailbreakText.write(toFile: "/private/jailbreak.txt", atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: "/private/jailbreak.txt")
            return true
        } catch {
            return false
        }
    }

    private static let suspiciousFiles: [String] = [
        "/Applications/Cydia.app",
        "/Library/MobileSubstrate/MobileSubstrate.dylib",
        "/bin/bash",
        "/usr/sbin/sshd",
        "/etc/apt",
        "/private/var/lib/apt/",
        "/private/var/lib/cydia",
        "/private/var/stash",
        "/usr/libexec/cydia/",
        "/usr/sbin/frida-server",
        "/usr/bin/cycript",
        "/usr/local/bin/cycript",
        "/usr/lib/libcycript.dylib",
        "/var/cache/apt/",
        "/var/lib/cydia",
        "/var/log/syslog",
        "/bin/sh",
        "/etc/ssh/sshd_config",
        "/usr/libexec/ssh-keysign",
        "/etc/apt/sources.list.d/cydia.list",
        "/private/var/mobileLibrary/SBSettingsThemes/",
        "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
        "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
        "/.installed_unc0ver",
        "/.bootstrapped_electra",
        "/usr/lib/libjailbreak.dylib",
        "/jb/lzma",
        "/.cydia_no_stash",
        "/var/lib/dpkg/info/mobilesubstrate.md5sums",
    ]
}
