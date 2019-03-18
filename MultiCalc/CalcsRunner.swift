//
//  CalcsRunner.swift
//  MultiCalc
//
//  MIT License
//
//  Copyright (c) 2019 Konrad Kołakowski
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
