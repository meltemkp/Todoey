//
//  Item.swift
//  Todoey
//
//  Created by Mac Book on 28.10.2018.
//  Copyright © 2018 Yunsa. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool   = false
    @objc dynamic var dateCreated : Date = Date()
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
