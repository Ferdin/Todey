//
//  Category.swift
//  Todey
//
//  Created by newuser on 2019-01-04.
//  Copyright © 2019 Ferdin. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    
    @objc dynamic var name : String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
