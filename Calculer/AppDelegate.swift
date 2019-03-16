//
//  AppDelegate.swift
//  Calculer
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
        statusBarItem.menu = self.menu
        statusBarItem.button?.target = self
        statusBarItem.button?.action = #selector(statusBarClicked(_:))
        
        self.statusBarItem = statusBarItem
    }
    
    // MARK: Actions
    @IBAction func statusBarClicked(_ sender: Any) {
        NSLog("Hello from status bar!")
    }
    
    @IBAction func cloaseAllCalculators(_ sender: Any) {
        
    }
}

