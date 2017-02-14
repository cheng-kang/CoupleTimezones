//
//  UserService.swift
//  CoupleTimezones
//
//  Created by Ant on 13/02/2017.
//  Copyright © 2017 Ant. All rights reserved.
//

import UIKit
import CoreData

class UserService: NSObject {
    
    static let shared = UserService()
    
    fileprivate var currentUser: User? = nil
    fileprivate var shouldRefresh: Bool = false
    
    var context: NSManagedObjectContext!{
        return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }
    
    func get() -> User? {
        if currentUser != nil && !shouldRefresh {
            return currentUser
        }
        
        return refresh()
    }
    
    @discardableResult
    func refresh() -> User? {
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        userFetch.fetchLimit = 1
        do {
            let fetchedUsers = try context.fetch(userFetch) as! [User]
            print(fetchedUsers)
            if fetchedUsers.count == 0 {
                return nil
            }
            
            self.currentUser = fetchedUsers[0]
            
            shouldRefresh = false
            
            return self.currentUser
        } catch {
            fatalError("Can't fetch user data.")
        }
    }
    
    // Use this method to create a new User object
    // Note that you must call insert() to save this object to CoreData
    func new() -> User {
        return User(context: context)
    }
    
    func save() {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        shouldRefresh = true
    }
    
    func insert() {
        save()
    }
    
    // Delete an object by passin
    func delete(object: User) {
        context.delete(object)
        save()
    }
}
