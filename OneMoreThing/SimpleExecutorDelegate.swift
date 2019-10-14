//
//  SimpleExecutor.swift
//  OneMoreThing
//
//  Created by Matteo on 15.10.19.
//  Copyright © 2019 Infomac. All rights reserved.
//

import Foundation

class SimpleExecutorDelegate: ExecutorDelegate {
    
    var outputController : OutputController
    
    init(_ outputController:OutputController!) {
        self.outputController = outputController
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
    }
    
}
