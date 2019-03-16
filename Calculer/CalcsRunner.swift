//
//  CalcsRunner.swift
//  Calculer
//
//  Created by Konrad Kołakowski on 16/03/2019.
//  Copyright © 2019 One Minute Games. All rights reserved.
//

import Foundation
import Cocoa

class CalcsRunner {
    // MARK: Properties
    static let shared = CalcsRunner()
    
    private var runningCalculators: [NSRunningApplication] = []
    
    private let calculatorAppURL: URL
    
    // MARK: Initialization
    private init() {
        guard let calculatorAppPath = NSWorkspace.shared.absolutePathForApplication(withBundleIdentifier: "com.apple.calculator") else {
            fatalError("Cannot find Calculator app in the system?!")
        }

        self.calculatorAppURL = URL(fileURLWithPath: calculatorAppPath)
    }
    
    // MARK: Manage calculators
    func startNewCalculator() {
        do {
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
