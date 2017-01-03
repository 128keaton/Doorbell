//
//  SetupManager.swift
//  Doorbell
//
//  Created by Keaton Burleson on 1/1/17.
//  Copyright © 2017 Keaton Burleson. All rights reserved.
//

import Foundation


class SetupManager: NSObject {


    func performInitialSetup() -> Bool {
        if !moveNodeToAGoodPlace() {
            return false
        }
        if !copyKey() {
            return false
        }
        startDaemon()

        return true
    }

    // Initial Setup Task(s)

    func moveNodeToAGoodPlace() -> Bool {
        let fileManager = FileManager.default

        let pathToBinary = Bundle.main.path(forResource: "doorbell", ofType: "js")
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        var url = appSupport.appendingPathComponent("DoorbellJS")
        url = url.appendingPathComponent("doorbell.js")
        print("URL: \(url)")
        do {
            try fileManager.copyItem(atPath: pathToBinary!, toPath: url.path)
        } catch let error as NSError {
            print(error.localizedDescription)
            print("Trying to manually update node")
            let returnedError = updateNode()
            if returnedError == nil {
                print("Update worked")
                return true
            } else {
                print(returnedError?.localizedDescription ?? "Something went wrong")
                return false
            }

        }


        return true
    }
    func copyKey() -> Bool {
        let fileManager = FileManager.default

        let pathToBinary = Bundle.main.path(forResource: "key", ofType: "p8")
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        var url = appSupport.appendingPathComponent("DoorbellJS")
        url = url.appendingPathComponent("key.p8")
        print("URL: \(url)")
        do {
            try fileManager.copyItem(atPath: pathToBinary!, toPath: url.path)
        } catch let error as NSError {
            print(error.localizedDescription)

            print("The key wasn't copied, but it shouldn't cause an issue, since this issue is thrown if it already exists. If I wasn't ACTUALLY lazy, I could prevent this error from happening")
        }
        return true
    }

    func updateNode() -> NSError? {
        let fileManager = FileManager.default
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        var url = appSupport.appendingPathComponent("DoorbellJS")
        url = url.appendingPathComponent("doorbell.js")

        do {
            try fileManager.removeItem(atPath: url.path)


        } catch let error as NSError {
            return error
        }
        if moveNodeToAGoodPlace() {
            return nil
        } else {
            return NSError(domain: "com.128keaton.Button", code: 1, userInfo: ["NSLocalizedDescriptionKey": "Manually updating the node failed"])
        }

    }

    func startDaemon() {

        DispatchQueue.global(qos: .background).async {
            var errorDict: NSDictionary? = nil

            let script = "sudo /usr/local/bin/node \(NSHomeDirectory())/Library/Application\\\\ Support/DoorbellJS/doorbell.js"
            NSAppleScript(source: "do shell script \"\(script)\" with administrator privileges")!.executeAndReturnError(&errorDict)
            if errorDict != nil {
                print(errorDict ?? "Something shat itself")

            }



        }



    }



}
