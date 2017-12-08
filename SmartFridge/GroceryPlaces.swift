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
    var latitude: Float?
    var longitude: Float?
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with parameters
    
    init(name: String, latitude: Float, longitude: Float)
    {
        
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    
}
