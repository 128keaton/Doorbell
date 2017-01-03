//
//  MenuController.swift
//  MenuColor
//
//  Created by Keaton Burleson on 10/10/16.
//  Copyright © 2016 Keaton Burleson. All rights reserved.
//

import Foundation
import Cocoa
class MenuController: NSObject, PreferencesDelegate {
    internal func updated() {
        print("settings updated")
    }


    @IBOutlet var statusMenu: NSMenu!
    var preferencesWindow: PreferencesWindow!

    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)



    override func awakeFromNib() {
        preferencesWindow = PreferencesWindow()
        preferencesWindow.delegate = self

        statusItem.menu = statusMenu
        statusItem.image = NSImage(named: "16.png")
        statusItem.image?.isTemplate = true


    }
    @IBAction func settings(_ sender: AnyObject) {
        print("open settings")
        preferencesWindow.window?.makeKeyAndOrderFront(self)
        preferencesWindow.toFront()
    }


    @IBAction func didClickQuit(_ sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }
}


