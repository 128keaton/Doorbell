//
//  AppDelegate.swift
//  Doorbell
//
//  Created by Keaton Burleson on 12/31/16.
//  Copyright © 2016 Keaton Burleson. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
    NSApp.registerForRemoteNotifications(matching: [.badge, .alert, .sound])
        // Insert code here to initialize your application
    }
    func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        NSLog(deviceTokenString)
        let setupManager = SetupManager()
        let _ = setupManager.performInitialSetup()
        UserDefaults.standard.set(deviceTokenString, forKey: "token")
        UserDefaults.standard.synchronize()
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

