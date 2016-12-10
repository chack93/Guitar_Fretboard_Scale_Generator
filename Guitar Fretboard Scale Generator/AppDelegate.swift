//
//  AppDelegate.swift
//  Guitar Fretboard Scale Generator
//
//  Created by Christian Hackl on 24.09.16.
//  Copyright © 2016 Christian Hackl. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if (flag) {
            return false
        } else {
            let window = NSApplication.shared().windows.first as NSWindow?
            if (window != nil) {
                window?.makeKeyAndOrderFront(self)
            }
            return true
        }
    }

}

