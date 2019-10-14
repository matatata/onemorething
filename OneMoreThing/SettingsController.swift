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
    
    
    @IBOutlet weak var outputController: OutputController!
    
    @IBOutlet weak var filename_start: NSTextField!
    @IBOutlet weak var filename_stop: NSTextField!
    
    
    @IBAction func browseStartFile(sender: AnyObject) {
        browseExecutableFile(sender: sender, textField: filename_start, title: "Select file to be run when the application starts")
    }
    
    @IBAction func browseStopFile(sender: AnyObject) {
        browseExecutableFile(sender: sender, textField: filename_stop, title: "Select file to be run when the application quits")
    }
    
    func browseExecutableFile(sender: AnyObject, textField: NSTextField!, title: String) {
        
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
            }
        } else {
            // User clicked on "Cancel"
            return
        }
        
    }
    
    
    @IBAction func testStart(sender: AnyObject) {
        if let e = Executor(filename_start.stringValue,["start"],SimpleExecutorDelegate(outputController)){
                             e.launch([RunLoopMode.modalPanelRunLoopMode])
                  }
    }
    
    @IBAction func testQuit(sender: AnyObject) {
        if let e = Executor(filename_stop.stringValue,["quit"],SimpleExecutorDelegate(outputController)){
                       e.launch([RunLoopMode.modalPanelRunLoopMode])
            }
    }
}
