//
//  GroceryList.swift
//  SmartFridge
//
//  Created by Divyankitha Raghava Urs on 11/27/17.
//  Copyright © 2017 SJSU. All rights reserved.
//

import UIKit

class GroceryList: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet weak var GroceryTable: UITableView!
    
    var row = 0
    
    var Names = Array<String>()
    var ID = Array<Int>()
    
    var GroceryItems = Array<GroceryItemModel>()
    
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        fetchGroceryList()
        GroceryTable.delegate = self
        GroceryTable.dataSource = self
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.GroceryTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return row; //retun the number of items
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = GroceryTable.dequeueReusableCell(withIdentifier: "GroceryListCell") as! GroceryListTableViewCell
        print(Names)
        cell.GroceryLabel.text = Names[indexPath.row]
        cell.GroceryID.text = String(ID[indexPath.row])
        return cell
    }
    
    func fetchGroceryList()
    {
        print("Inside fetch grocery")
        
        let DNS = RestApiUrl()
        
        var request = URLRequest(url: URL(string: DNS.aws + "/SmartFridgeBackend/groceryList/1")!)
        request.httpMethod = "GET"
        request.httpBody = try? JSONSerialization.data(withJSONObject: [] ,options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
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
        
        
        var jsonElement = NSDictionary()
        
        
        row = jsonResult.count
        
        
        for i in 0 ..< jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let GroceryItem = GroceryItemModel()
            
            let id = jsonElement["ListID"] as? Int
            let uid = jsonElement["UserID"] as? Int
            let name = jsonElement["FoodItemName"] as? String
            let count = jsonElement["Count"] as? Int
            
            print(id ?? 0)
            
            GroceryItem.name = name
            GroceryItem.id = id
            GroceryItem.uid = uid
            GroceryItem.count = count
            
            GroceryItems.append(GroceryItem)
            Names.append(GroceryItem.name ?? "Item")
            ID.append(GroceryItem.id ?? 1)
            
        }
        print(Names)
        print(ID)
    }
    


}
