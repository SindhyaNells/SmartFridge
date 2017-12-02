//
//  GroceryPlaces.swift
//  SmartFridge
//
//  Created by sindhya on 12/1/17.
//  Copyright © 2017 SJSU. All rights reserved.
//

import Foundation

class GroceryPlaces: NSObject {
    
    //properties
    
    var name: String?
    var latitude: String?
    var longitude: String?
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with parameters
    
    init(name: String, latitude: String, longitude: String)
    {
        
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    
}
