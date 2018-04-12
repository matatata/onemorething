//
//  OutputController.swift
//  OneMoreThing
//
//  Created by Matteo on 10.04.18.
//  Copyright © 2018 Infomac. All rights reserved.
//

import Foundation

import Cocoa


class OutputController : NSObject,ExecutorDelegate {
   
    
    
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var textView: NSTextView!
    

    func fail(_ x: String) {
        update("fail \(x)")
    }
    
    func update(_ x: String) {
        if(x.isEmpty){
            return
        }
        
        window.setIsVisible(true);
        
        
        let range = NSMakeRange (textView.string.count, 0)
        textView.replaceCharacters(in: range, with: x)
    }
    
    func terminated(_ status: Int32) {
       window.title = "terminated with \(status)"
    }
    
    
    func didLaunch(_ program: String!, _ args: [String]!) {
        window.title = "\(program!) \(args!)"
        window.setIsVisible(true)
    }
    
    

}
