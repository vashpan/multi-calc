//
//  CalcsRunner.swift
//  Calculer
//
//  Created by Konrad Kołakowski on 16/03/2019.
//  Copyright © 2019 One Minute Games. All rights reserved.
//

import Foundation
import CoreFoundation
import Cocoa

class CalcsRunner {
    // MARK: Properties
    static let shared = CalcsRunner()
    
    private var runningCalculators: [NSRunningApplication] = []
    
    private let calculatorAppURL: URL
    private static let calculatorAppBundleId = "com.apple.calculator"
    
    private var realHomeDirectoryForCurrentUser: URL {
        let pw = getpwuid(getuid())
        let home = pw?.pointee.pw_dir
        let homePath = FileManager.default.string(withFileSystemRepresentation: home!, length: Int(strlen(home)))
        
        return URL(fileURLWithPath: homePath, isDirectory: true)
    }
    
    // MARK: Initialization
    private init() {
        guard let calculatorAppPath = NSWorkspace.shared.absolutePathForApplication(withBundleIdentifier: CalcsRunner.calculatorAppBundleId) else {
            fatalError("Cannot find Calculator app in the system?!")
        }

        self.calculatorAppURL = URL(fileURLWithPath: calculatorAppPath)
    }
    
    // MARK: Helpers
    private func moveRecentCalculatorWindowABit() {
        let calculatorPlistFilePath = self.realHomeDirectoryForCurrentUser.appendingPathComponent("Library/Containers/\(CalcsRunner.calculatorAppBundleId)/Data/Library/Preferences/\(CalcsRunner.calculatorAppBundleId).plist").path as CFString
        let windowPositionPropertyKey = "NSWindow Frame Calc_Main_Window" as CFString
        
        // get initial value
        guard let oldValue = CFPreferencesCopyAppValue(windowPositionPropertyKey, calculatorPlistFilePath) else {
            NSLog("Can't get last calculator window position!")
            return
        }
        let oldValueCFString = oldValue as! CFString
        let oldValueString = oldValueCFString as String
        
        
        // parse old position
        let oldValueSplitted = oldValueString.split(separator: " ")
        var windowPositions = oldValueSplitted.compactMap {
            return Int($0)
        }
        
        // move a bit down from initial position
        if windowPositions.count >= 2 {
            windowPositions[0] += 50
            windowPositions[1] -= 50
        }
        
        // convert back to string
        let newValueSplitted = windowPositions.map {
            return "\($0)"
        }
        let newValueString = newValueSplitted.joined(separator: " ")
        let newValueCFString = newValueString as CFString
        
        // save new value
        CFPreferencesSetAppValue(windowPositionPropertyKey, newValueCFString, calculatorPlistFilePath)
        CFPreferencesAppSynchronize(calculatorPlistFilePath)
    }
    
    // MARK: Manage calculators
    func startNewCalculator() {
        do {
            self.moveRecentCalculatorWindowABit()
            
            let newCalculatorApp = try NSWorkspace.shared.launchApplication(at: self.calculatorAppURL,
                                                                            options: [.newInstance, .withoutAddingToRecents],
                                                                            configuration: [:])
            
            self.runningCalculators.append(newCalculatorApp)
        } catch(let error) {
            NSLog("Cannot start new Calculator: %@", error.localizedDescription)
        }
    }
    
    func closeAllRunningCalculators() {
        for runningCalculator in self.runningCalculators {
            runningCalculator.terminate()
        }

        self.runningCalculators.removeAll()
    }
}
