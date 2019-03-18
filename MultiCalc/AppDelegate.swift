//
//  AppDelegate.swift
//  MultiCalc
//
//  Created by Konrad Kołakowski on 16/03/2019.
//  Copyright © 2019 One Minute Games. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    // MARK: Properties & outlets
    @IBOutlet private weak var menu: NSMenu!
    
    private var statusBarItem: NSStatusItem?
    
    // MARK: NSApplicationDelegate implementation
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusBarItem.button?.image = NSImage(imageLiteralResourceName: "StatusBarIcon")
        statusBarItem.button?.target = self
        statusBarItem.button?.action = #selector(statusBarClicked(_:))
        statusBarItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
        
        self.statusBarItem = statusBarItem
    }
    
    // MARK: Actions
    @IBAction func statusBarClicked(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else {
            return
        }
        
        if event.type == .rightMouseUp {
            // FIXME: Replace with something that's not deprecated
            // Unfortunately advice in deprecation is not really,
            self.statusBarItem?.popUpMenu(self.menu)
        } else {
            CalcsRunner.shared.startNewCalculator()
        }
    }
    
    @IBAction func cloaseAllCalculators(_ sender: Any) {
        CalcsRunner.shared.closeAllRunningCalculators()
    }
}

