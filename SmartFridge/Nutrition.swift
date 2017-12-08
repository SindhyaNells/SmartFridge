//
//  Nutrition.swift
//  SmartFridge
//
//  Created by Divyankitha Raghava Urs on 12/7/17.
//  Copyright © 2017 SJSU. All rights reserved.
//

import UIKit

class Nutrition: UIViewController
{
    var recipeName = String()
    //var recipeID = String()
    var recipeID = "1e5aa65869d8d215c78dd9720147f434"

    override func viewDidLoad()
    {
        super.viewDidLoad()
        getNutrition()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    func getRecipeID()
    {
        //get the recipie ID
        //call get nutrition
    }
    
    func getNutrition()
    {
        let api = RestApiUrl()
        let finalURL1 = api.nutritionAPI + recipeID
        let finalURL2 = "&app_id=" + api.appID
        let finalURL3 = "&app_key=" + api.apiKey
        let finalURL = finalURL1 + finalURL2 + finalURL3
        print(finalURL)
        
        var request = URLRequest(url: URL(string: finalURL)!)
        request.httpMethod = "GET"
        request.httpBody = try? JSONSerialization.data(withJSONObject: [] ,options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 1000.0
        sessionConfig.timeoutIntervalForResource = 1000.0
        
        let session = URLSession(configuration: sessionConfig)
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in print( response ?? "Error connecting to Rest API - GET Grocery List")
            if error != nil
            {
                print("Failed to connect to Grocery List API")
                print(error!)
            }
            else
            {
                print("Data Obtained")
                
                self.parseJSON(data!)
            }
            
            if let httpResponse = response as? HTTPURLResponse
            {
                if httpResponse.statusCode == 200
                {
                    print("Retrived grocery list")
                    
                }
                else
                {
                    print(httpResponse.statusCode)
                    print("Failed to retrive grocery list")
                }
            }
            
        })
        
        task.resume()
    }
    
    func parseJSON(_ data:Data)
    {
        
        var jsonResult = NSArray()
        
        do{
            
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            print(jsonResult)
            
        } catch let error as NSError
        {
            print(error)
        }
        
        /*
        var jsonElement = NSDictionary()
        for i in 0 ..< jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let GroceryItem = GroceryItemModel()
            
            let id = jsonElement["ListID"] as? Int
            let uid = jsonElement["UserID"] as? Int
            let name = jsonElement["FoodItemName"] as? String
            let type = jsonElement["Type"] as? String
            
            print(id ?? 0)
            
            GroceryItem.name = name
            GroceryItem.id = id
            GroceryItem.uid = uid
            GroceryItem.type = type
            
        }*/
        
    }
    

}
