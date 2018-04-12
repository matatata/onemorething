//
//  Executor.swift
//  OneMoreThing
//
//  Created by Matteo on 10.04.18.
//  Copyright © 2018 Infomac. All rights reserved.
//

import Foundation


protocol ExecutorDelegate {
    func fail(_ x:String)
    func println(_ x:String)
    func echo(_ x:String)
    func terminated(_ status:Int32)
    func didLaunch(_ program:String!, _ args: [String]!)
}


class Executor {
    var program:String
    var args:[String]
    var task: Process
    
    var delegate:ExecutorDelegate
    
    init?(_ program:String!, _ args: [String]!, _ delegate:ExecutorDelegate) {
        self.delegate = delegate;
        self.program=program
        self.args=args
        
        if(!FileManager.default.isExecutableFile(atPath:program)){
            delegate.fail("Not executable or does not exist: \(program!)")
            return nil;
        }
        
        self.task=Process();
        
        
    }
    
    func launch( _ modes: [RunLoopMode]?) {

        let pipe = Pipe()
        
        
        task.launchPath = program;
        task.arguments = args
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.standardInput = FileHandle.nullDevice
        
        
        
        
        let outHandle = pipe.fileHandleForReading
        outHandle.waitForDataInBackgroundAndNotify(forModes: modes)
        
        var obs1 : NSObjectProtocol!
        obs1 = NotificationCenter.default.addObserver(forName:NSNotification.Name.NSFileHandleDataAvailable,
                                                      object: outHandle, queue: nil) {  notification -> Void in
                                                        let data = outHandle.availableData
                                                        if data.count > 0 {
                                                            if let str = String(data: data, encoding: String.Encoding.utf8) {
                                                                self.delegate.echo(str);
                                                            }
                                                            outHandle.waitForDataInBackgroundAndNotify(forModes: modes)
                                                        } else {
//                                                            print("got eof")
                                                            NotificationCenter.default.removeObserver(obs1)
                                                        }
        }
        
        var obs2 : NSObjectProtocol!
        obs2 = NotificationCenter.default.addObserver(forName: Process.didTerminateNotification,
                                                      object: task, queue: nil) { notification -> Void in
//                                                        print("did terminate")
                                                        self.hookTerminated()
                                                        NotificationCenter.default.removeObserver(obs2)
        }
        
        task.launch()
        
        delegate.didLaunch(program,args);
        
    }
    
    
    
    func hookTerminated() {
        delegate.terminated(task.terminationStatus);
    }
    
    
    
}
