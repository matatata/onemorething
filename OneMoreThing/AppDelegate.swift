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
    @IBOutlet weak var settingsController: SettingsController!
  
    var reason:String=""
    
    override init() {
        //UserDefaults.standard.register(defaults: [ quitProgramPathKey : NSHomeDirectory() + "/.onemorething/onemorething.sh"])
    }
    
   
   

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if(settingsController.startupScript() == nil) {
            outputController.println("No start program defined")
            return
        }
        
        if let e = OneMoreThingExecutor.forStartScript(settingsController,SimpleExecutorDelegate(outputController)){
                   e.launch()
        }
        
    }
    

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        
        reason = quitReason()
        
        let script = settingsController.quitScript();
        
        if(script == nil) {
            outputController.println("No quit program defined")
            return NSApplication.TerminateReply.terminateNow
        }
        
        
        
        if let e = OneMoreThingExecutor.forQuitScript(settingsController,reason,self){
            e.launch([RunLoopMode.modalPanelRunLoopMode])
        }
        else {
            
            if(StdAlert.dialogOKCancel(title: "Failed to call '\(script!)'", text: "quit anyway?")){
                return NSApplication.TerminateReply.terminateNow
            }
            else {
                return NSApplication.TerminateReply.terminateCancel
            }
        }
        
        return NSApplication.TerminateReply.terminateLater
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
       
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
            reply = StdAlert.dialogOKCancel(title: "Program exited with \(status)", text: "\(reason) anyway?")
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

