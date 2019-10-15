//
//  Settings.swift
//  OneMoreThing
//
//  Created by Matteo on 14.10.19.
//  Copyright © 2019 Infomac. All rights reserved.
//

import Foundation
import Cocoa


class SettingsController: NSWindowController {
    
    static let startProgramPathKey = "startProgramPath"
    static let quitProgramPathKey = "quitProgramPath"
    static let useEnvVarToPassEventIdKey = "useEnvVarToPassEventId"
      
    
    @IBOutlet weak var outputController: OutputController!
    
    @IBOutlet weak var filename_start: NSTextField!
    @IBOutlet weak var filename_stop: NSTextField!
    @IBOutlet weak var use_env_variable: NSButton!
    
    @IBAction func browseStartFile(sender: AnyObject) {
        browseExecutableFile(sender: sender, textField: filename_start, title: "Select file to be run when the application starts",userDefaultsKey: SettingsController.startProgramPathKey)
    }
    
    @IBAction func browseStopFile(sender: AnyObject) {
        browseExecutableFile(sender: sender, textField: filename_stop, title: "Select file to be run when the application quits",userDefaultsKey: SettingsController.quitProgramPathKey)
    }
    
    func browseExecutableFile(sender: AnyObject, textField: NSTextField!, title: String!, userDefaultsKey: String! ) {
        
        let dialog: NSOpenPanel = NSOpenPanel();
        
        dialog.title                   = title
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = true
        dialog.canChooseDirectories    = false
        dialog.canCreateDirectories    = true
        dialog.allowsMultipleSelection = false

        
        if(!filename_start.stringValue.isEmpty){
            dialog.directoryURL = URL(fileURLWithPath: filename_start.stringValue)
        }

        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                
                if(!FileManager.default.isExecutableFile(atPath: path)){
                    if(!StdAlert.dialogOKCancel(title: "\(path) is not executable.", text: "Use anyway?")){
                        return
                    }
                }
                textField.stringValue = path
                UserDefaults.standard.set(path, forKey: userDefaultsKey)
            }
        } else {
            // User clicked on "Cancel"
            return
        }
        
    }
    
    
    @IBAction func testStart(sender: AnyObject) {
        if let e = OneMoreThingExecutor.forStartScript(self,SimpleExecutorDelegate(outputController)){
                             e.launch()
                  }
    }
    
    @IBAction func testQuit(sender: AnyObject) {
        if let e = OneMoreThingExecutor.forQuitScript(self,"quit",SimpleExecutorDelegate(outputController)){
                       e.launch()
            }
    }
    
    func startupScript() -> String? {
        return UserDefaults.standard.string(forKey: SettingsController.startProgramPathKey)
    }
    
    func quitScript() -> String? {
        return UserDefaults.standard.string(forKey: SettingsController.quitProgramPathKey)
    }
    
    func useEnvVarToPassEventId() -> Bool! {
        return UserDefaults.standard.bool(forKey: SettingsController.useEnvVarToPassEventIdKey)
    }
}
