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
    var recipeID = String()
    //var recipeID = "1e5aa65869d8d215c78dd9720147f434"
    var nutrients = [String:Double] ()
    var calories = Double()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        //getNutrition()
        getRecipeID(recipe_name: recipeName)
        print(recipeName)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    func getRecipeID(recipe_name:String)
    {
        //get the recipie ID
        //call get nutrition
        let api = RestApiUrl().aws+"/SmartFridgeBackend/recipe/"+recipe_name
        
        var request = URLRequest(url: URL(string: api)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let sessionConfig = URLSessionConfiguration.default
        //sessionConfig.timeoutIntervalForRequest = 100.0
        //sessionConfig.timeoutIntervalForResource = 100.0
        
        let session = URLSession(configuration: sessionConfig)
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in print( response ?? "Error connecting to Rest API - GET Recipe ID")
            if error != nil
            {
                print("Failed to connect")
                print(error!)
            }
            else
            {
                print("Data Obtained")
                
                //self.parseJSON(data!)
            }
            
            if let httpResponse = response as? HTTPURLResponse
            {
                if httpResponse.statusCode == 200
                {
                    var jsonResult = NSDictionary()
                    
                    do{
                        
                        jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        print(jsonResult)
                        
                    } catch let error as NSError
                    {
                        print(error)
                    }
                    
                    self.recipeID = (jsonResult["Id"] as? String)!
                    print(self.recipeID)
                    
                    DispatchQueue.main.async
                    {
                        self.getNutrition(recipe_id: self.recipeID)
                    }
                    
                    
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
    
    func getNutrition(recipe_id: String)
    {
        let api = RestApiUrl()
        let finalURL1 = api.nutritionAPI + recipe_id
        let finalURL2 = "&app_id=" + api.appID
        let finalURL3 = "&app_key=" + api.apiKey
        let finalURL = finalURL1 + finalURL2 + finalURL3
        print(finalURL)
        
        var request = URLRequest(url: URL(string: finalURL)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 100.0
        sessionConfig.timeoutIntervalForResource = 100.0
        
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
        print(data)
        
        var json: [Any]?
        do {
            json = try JSONSerialization.jsonObject(with: data) as? [Any]
            print(json ?? "error json")
             guard let item = json?.first as? [String: Any],
                let cal = item["calories"] as? Double,
                let nutrients = item["totalNutrients"] as? [String: Any],
                let fat = nutrients["FAT"] as? [String: Any],
                let fat_quantity = fat["quantity"] as? Double,
            let chole = nutrients["CHOLE"] as? [String: Any],
            let choles_quantity = chole["quantity"] as? Double,
            let carbs = nutrients["CHOCDF"] as? [String:Any],
            let carbs_quantity = carbs["quantity"] as? Double,
                let fiber = nutrients["FIBTG"] as? [String:Any],
                let fiber_quantity = fiber["quantity"] as? Double,
                let sugar = nutrients["SUGAR"] as? [String:Any],
                let sugar_quantity = sugar["quantity"] as? Double,
                let protein = nutrients["PROCNT"] as? [String:Any],
                let protein_quantity = protein["quantity"] as? Double,
                let vita = nutrients["VITA_RAE"] as? [String:Any],
                let vita_quantity = vita["quantity"] as? Double,
                let vitc = nutrients["VITC"] as? [String:Any],
                let vitc_quantity = vitc["quantity"] as? Double
                else{
            return
            }
            
            self.calories = cal
            self.nutrients["fat"] = fat_quantity
            self.nutrients["cholestrol"] = choles_quantity
            self.nutrients["carbs"] = carbs_quantity
            self.nutrients["fiber"] = fiber_quantity
            self.nutrients["sugar"] = sugar_quantity
            self.nutrients["protein"] = protein_quantity
            self.nutrients["vitamina"] = vita_quantity
            self.nutrients["vitaminc"] = vitc_quantity
            
            //loop over nutrients
            for (key, value) in self.nutrients {
                print("\(key): \(value)")
            }
            
        } catch {
            print("Error deserializing JSON: \(error)")
        }
        
    
        
    }
    

}
