//
//  OneMOreThingExecutor.swift
//  OneMoreThing
//
//  Created by mceruti on 15.10.19.
//  Copyright © 2019 Infomac. All rights reserved.
//

import Foundation

class OneMoreThingExecutor : Executor {
    
    private init?(_ program:String!, _ eventId:String!, _ passEventIdAsEnvVar:Bool,_ delegate:ExecutorDelegate) {
        super.init(program,passEventIdAsEnvVar ? []:[eventId],delegate,passEventIdAsEnvVar ? ["ONEMORETHING_EVENT":eventId] : nil)
    }
    
    static func forStartScript(_ settings:SettingsController!, _ delegate:ExecutorDelegate) ->  OneMoreThingExecutor? {
        let passEventIdAsEnvVar = settings.useEnvVarToPassEventId()
        return OneMoreThingExecutor(settings.startupScript(),"start",passEventIdAsEnvVar!,delegate)
    }
    
    static func forQuitScript(_ settings:SettingsController!, _ eventId:String!, _ delegate:ExecutorDelegate) ->  OneMoreThingExecutor? {
        let passEventIdAsEnvVar = settings.useEnvVarToPassEventId()
        return OneMoreThingExecutor(settings.quitScript(),eventId,passEventIdAsEnvVar!,delegate)
    }
}
