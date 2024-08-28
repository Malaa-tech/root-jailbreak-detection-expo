//
//  FridaDetection.swift
//  RootJailbreakDetectionExpo
//
//  Created by Mohammed Alfayez on 24/02/1446 AH.
//  Sourced from Sachin Sabat [MIT]
//

import Foundation
import UIKit
import MachO

public final class FridaDetection {
    var isFridaDetected: Bool {
        return isSuspiciousLibraryLoaded() || isFridaEnvironmentVariablePresent()
    }

    private func isSuspiciousLibraryLoaded() -> Bool {
        let suspiciousLibraryPatterns = [
            "frida",
            "libinjector"
        ]
        let libraryCount = _dyld_image_count()
        for index in 0..<libraryCount {
            guard let imageName = _dyld_get_image_name(index) else {
                continue
            }
            let libraryName = String(cString: imageName)
            for pattern in suspiciousLibraryPatterns {
                if libraryName.lowercased().contains(pattern.lowercased()) {
                    return true
                }
            }
        }
        return false
    }

    private func isFridaEnvironmentVariablePresent() -> Bool {
        let environmentVariables = ["FRIDA", "FRIDA_SERVER"]
        let environment = ProcessInfo.processInfo.environment
        for variable in environmentVariables {
            if environment[variable] != nil {
                return true
            }
        }
        return false
    }
}
