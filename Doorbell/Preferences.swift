//
//  Preferences.swift
//  MenuColor
//
//  Created by Keaton Burleson on 10/8/16.
//  Copyright © 2016 Keaton Burleson. All rights reserved.
//

import Foundation
import Cocoa
class PreferencesWindow: NSWindowController, NSWindowDelegate {

    var delegate: PreferencesDelegate?
    let defaults = UserDefaults.standard

    @IBOutlet var iToken: NSTextField?
    @IBOutlet var mToken: NSTextField?
    @IBOutlet var MAC: NSTextField?

    override var windowNibName: String! {
        return "PreferencesWindow"
    }

    convenience init() {
        self.init(windowNibName: "PreferencesWindow")
    }

    func toFront() {
        NSApp.activate(ignoringOtherApps: true)
    }
    func loadJSON() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let url = appSupport.appendingPathComponent("DoorbellJS")

        print(url.absoluteString)

        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: url.relativePath, isDirectory: &isDir) {
            if isDir.boolValue {
                let file = "preferences.js" //this is the file. we will write to and read from it


                let path = url.appendingPathComponent(file)
                print(path.absoluteString)

                do {
                    let settings = try String(contentsOf: path, encoding: String.Encoding.utf8)
                    let object = self.convertToDictionary(text: settings)
                    self.setFields(data: object!)
                    print("stereted fieldsz")
                }
                catch { print(error.localizedDescription) }

            } else {
                // file exists and is not a directory
                print("not a direceter")
            }
        } else {
            // file does not exist
            print("well poop")
        }

    }
    func setFields(data: [String: Any?]) {
        if (data["iOSToken"] != nil) {
            iToken?.stringValue = data["iOSToken"] as! String
        }
        if (data["MacToken"] != nil) {
            mToken?.stringValue = data["MacToken"] as! String
        }else{
            mToken?.stringValue = UserDefaults.standard.object(forKey: "token") as! String
        }

        if (data["mac"] != nil) {
            MAC?.stringValue = data["mac"] as! String
        }


    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }


    @IBAction func saveDone(sender: NSButton) {
        let jsonObject: NSMutableDictionary = NSMutableDictionary()

        jsonObject.setValue(iToken?.stringValue, forKey: "iOSToken")
        jsonObject.setValue(mToken?.stringValue, forKey: "MacToken")
        jsonObject.setValue(MAC?.stringValue, forKey: "mac")

        let jsonData: NSData

        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as NSData
            let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue) as! String
            print("json string = \(jsonString)")
            saveToAppData(data: jsonString)
            self.window?.close()

        } catch _ {
            print ("JSON Failure")
        }
    }
    func saveToAppData(data: String) {
        if FileManager.SearchPathDirectory.applicationSupportDirectory.createSubFolder(named: "DoorbellJS") {
            print("folder successfully created")
        }

        let file = "preferences.js" //this is the file. we will write to and read from it
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let url = appSupport.appendingPathComponent("DoorbellJS")


        let path = url.appendingPathComponent(file)


        do {
            try data.write(to: path, atomically: true, encoding: String.Encoding.utf8)
        }
        catch { /* error handling here */ }


    }

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.center()
        toFront()
        loadJSON()
        print("Window loaded")

    }
}


protocol PreferencesDelegate {
    func updated()
}

class Editing: NSTextField {
    
    private let commandKey = NSEventModifierFlags.command

    override func performKeyEquivalent(with event: NSEvent) -> Bool {

        if event.type == NSEventType.keyDown {
            if (NSEventModifierFlags.deviceIndependentFlagsMask == commandKey) {
                switch event.charactersIgnoringModifiers! {
                case "x":
                    if NSApp.sendAction(#selector(NSText.cut(_:)), to:nil, from:self) { return true }
                case "c":
                    if NSApp.sendAction(#selector(NSText.copy(_:)), to:nil, from:self) { return true }
                case "v":
                    if NSApp.sendAction(#selector(NSText.paste(_:)), to:nil, from:self) { return true }
                case "z":
                    if NSApp.sendAction(Selector(("undo:")), to:nil, from:self) { return true }
                case "a":
                    if NSApp.sendAction(#selector(NSResponder.selectAll(_:)), to:nil, from:self) { return true }
                default:
                    break
                }
            }
            
            
        }
        return super.performKeyEquivalent(with: event)
    }
}



extension FileManager.SearchPathDirectory {
    func createSubFolder(named: String, withIntermediateDirectories: Bool = false) -> Bool {
        guard let url = FileManager.default.urls(for: self, in: .userDomainMask).first else { return false }
        do {
            try FileManager.default.createDirectory(at: url.appendingPathComponent(named), withIntermediateDirectories: withIntermediateDirectories, attributes: nil)
            return true
        } catch let error as NSError {
            print(error.description)
            return false
        }
    }
}

