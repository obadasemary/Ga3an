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
    var phoneNumber = ""
    var image = ""
    var isVisited = false
    var rating = ""
    
    init(name:String, type:String, location:String, phoneNumber:String, image:String, isVisited:Bool) {
        
        self.name = name
        self.type = type
        self.location = location
        self.phoneNumber = phoneNumber
        self.image = image
        self.isVisited = isVisited
    }
}