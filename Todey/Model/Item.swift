//
//  Item.swift
//  Todey
//
//  Created by newuser on 2019-01-04.
//  Copyright © 2019 Ferdin. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
