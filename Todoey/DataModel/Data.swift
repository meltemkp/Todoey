//
//  Data.swift
//  Todoey
//
//  Created by Mac Book on 28.10.2018.
//  Copyright © 2018 Yunsa. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
}
