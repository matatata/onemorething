//
//  StdAlert.swift
//  OneMoreThing
//
//  Created by Matteo on 11.04.18.
//  Copyright © 2018 Infomac. All rights reserved.
//

import Cocoa

class StdAlert {
    static  func dialogOKCancel(title: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        return alert.runModal() == .alertFirstButtonReturn
    }
}
