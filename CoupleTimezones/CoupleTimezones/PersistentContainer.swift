//
//  PersistentContainer.swift
//  CoupleTimezones
//
//  Created by Ant on 22/02/2017.
//  Copyright © 2017 Ant. All rights reserved.
//

import Foundation
import CoreData

final class PersistentContainer: NSPersistentContainer {
    internal override class func defaultDirectoryURL() -> URL {
        var url = super.defaultDirectoryURL()
        if let newURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.me.chengkang.remember") {
            url = newURL
        }
        return url
    }
}
