//
//  OutputController.swift
//  OneMoreThing
//
//  Created by Matteo on 10.04.18.
//  Copyright © 2018 Infomac. All rights reserved.
//

import Foundation

import Cocoa


class OutputController : NSWindowController,ExecutorDelegate {
   
    
    @IBOutlet weak var textView: NSTextView!
    @IBOutlet weak var outputView: NSTextView!
    @IBOutlet weak var menuVisibilityToggle: NSMenuItem!
    
    func fail(_ x: String) {
        println(x)
    }
    
    func echo(_ x: String) {
       output(x,outputView)
    }
    
    func println(_ x: String) {
        output(x + "\n", textView)
    }
    
    func output(_ x: String, _ view: NSTextView!) {
        if(x.isEmpty){
            return
        }
        
        window!.setIsVisible(true);
        
        
        let range = NSMakeRange (view.string.count, 0)
        view.replaceCharacters(in: range, with: x)
        
        view.scrollPageDown(self)
    }
    
    func terminated(_ status: Int32) {
        let msg = "Terminated with \(status)"
        println(msg)
    }
    
    
    func didLaunch(_ program: String!, _ args: [String]!) {
        let msg = "Calling \(program!) \(args!)"
        window!.setIsVisible(true)
        println(msg)
    }
    
    
    @IBAction func toggleWindowVisibility(sender: AnyObject) {
        let isVisible = window!.isVisible
        window?.setIsVisible(!isVisible)
    }
    
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        if menuItem == menuVisibilityToggle {
            let isVisible = window!.isVisible
            if isVisible {
                menuVisibilityToggle.title = "Hide Main Window"
            }
            else {
                menuVisibilityToggle.title = "Show Main Window"
            }
            return true
        }
        
        return super.validateMenuItem(menuItem)
    }
    

}
