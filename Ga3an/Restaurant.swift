//
//  Restaurant.swift
//  Ga3an
//
//  Created by Abdelrahman Mohamed on 4/11/16.
//  Copyright © 2016 Abdelrahman Mohamed. All rights reserved.
//

import Foundation

class Restaurant {
    
    var name = ""
    var type = ""
    var location = ""
    var image = ""
    var isVisited = false
    
    init(name:String, type:String, location:String, image:String, isVisited:Bool) {
        
        self.name = name
        self.type = type
        self.location = location
        self.image = image
        self.isVisited = isVisited
    }
}