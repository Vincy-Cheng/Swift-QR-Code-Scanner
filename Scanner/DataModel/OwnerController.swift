//
//  OwnerController.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/5/24.
//

import Foundation
import CoreData

class OwnerController: DataController{
    func addOwner(name:String,context: NSManagedObjectContext){
        let owner = Owner(context: context)
        
        owner.id = UUID()
        owner.name = name
        
        save(context: context)
    }
}
