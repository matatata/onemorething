//
//  AppDelegate.swift
//  OneMoreThing
//
//  Created by Matteo on 10.04.18.
//  Copyright © 2018 Infomac. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, ExecutorDelegate {
    
   
    @IBOutlet weak var outputController: OutputController!
    
    var reason:String=""

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        
    }
    
   

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        
        reason = quitReason()
        
        if let e = Executor("/Users/matteo/.hooker/default.sh",[reason],self){
            e.launch([RunLoopMode.modalPanelRunLoopMode])
        }
        else {
            
            if(StdAlert.dialogOKCancel(question: "Could not call one more thing", text: "quit anyway?")){
                return NSApplication.TerminateReply.terminateNow
            }
            else {
                return NSApplication.TerminateReply.terminateCancel
            }
        }
        
        return NSApplication.TerminateReply.terminateLater
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func didLaunch(_ program: String!, _ args: [String]!) {
        outputController.didLaunch(program,args)
    }
    
    func println(_ x: String) {
        outputController.println(x)
    }
    
    func fail(_ x: String) {
        outputController.fail(x)
    }
    
    func echo(_ x: String) {
        outputController.echo(x)
    }
    
    func terminated(_ status: Int32) {
        outputController.terminated(status)
        var reply = true
        
        if(status != 0){
            reply = StdAlert.dialogOKCancel(question: "Program exited with \(status)", text: "\(reason) anyway?")
        }
        
        NSApp.reply(toApplicationShouldTerminate: reply)
    }
    
    func quitReason() -> String {
        let appleEventDesc = NSAppleEventManager.shared().currentAppleEvent
        
        let whyDesc = appleEventDesc?.attributeDescriptor(forKeyword: kAEQuitReason)
        let why = whyDesc?.typeCodeValue
        
        var reasonKey = "quit"
        
        if (why != nil){
            switch why {
            case kAELogOut,kAEReallyLogOut:
                // log out
                reasonKey = "logout"
                break
            case kAEShowRestartDialog, kAERestart:
                // system restart
                reasonKey = "restart"
                break
            case kAEShowShutdownDialog, kAEShutDown:
                // system shutdown
                reasonKey = "shutdown"
                break
            default:
                // ordinary quit
                reasonKey = "quit"
                break;
            }
        }
        return reasonKey
    }


}

