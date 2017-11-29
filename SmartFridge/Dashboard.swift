//
//  Dashboard.swift
//  SmartFridge
//
//  Created by Divyankitha Raghava Urs on 11/7/17.
//  Copyright © 2017 SJSU. All rights reserved.
//

import UIKit

class Dashboard: UIViewController,UITableViewDelegate, UITableViewDataSource
{
    
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var itemTableView: UITableView!
    
    var row = 0
    var FridgeItems = Array<FridgeItemsModel>()
    var Names = Array<String>()
    var ID = Array<Int>()
    var UserId = Int()

    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        fetchItemList()

        itemTableView.delegate = self
        itemTableView.dataSource = self
        
        let preferences = UserDefaults.standard
        print(preferences.object(forKey: "UserId") ?? "no UID")
        
       /*refreshControl.addTarget(self, action: #selector(fetchItemList), for: UIControlEvents.valueChanged)
       // itemTableView.subview(refreshControl)
       itemTableView.refreshControl = refreshControl
        */
        
    }
    
   
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.itemTableView.reloadData()
        print("ID got from login")
        print(UserId)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Names.count; //retun the number of items
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = itemTableView.dequeueReusableCell(withIdentifier: "ItemDisplay") as! DashboardTableViewCell
        print(Names)
        row = Names.count
        cell.itemLabel.text = Names[indexPath.row]
        cell.itemImage.image = UIImage(named: Names[indexPath.row])
        cell.itemIDLabel.text = String(ID[indexPath.row])
        return cell
    }
    
    @objc func fetchItemList()
    {
        print("Inside fetch list")
        
        let DNS = RestApiUrl()
        
        var request = URLRequest(url: URL(string: DNS.aws + "/SmartFridgeBackend/user/fridgeItems/2")!)
        request.httpMethod = "GET"
        request.httpBody = try? JSONSerialization.data(withJSONObject: [] ,options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in print( response ?? "Error connecting to Rest API - GET Items from fridge")
            
            if error != nil
            {
                print("Failed to connect to Fetch Item API")
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
                    print("Retrived items")
                    
                }
                else
                {
                    print(httpResponse.statusCode)
                    print("Failed to retrive data")
                }
            }
        })
        
        task.resume()
        
        /*self.viewDidLoad()
        self.refreshControl.endRefreshing()*/
        
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
            
            let FridgeItem = FridgeItemsModel()
                
            let name = jsonElement["Name"] as? String
            let MfgDate = jsonElement["MFGDate"] as? Date
            let ExpDate = jsonElement["EXPDate"] as? Date
            let Quantity = jsonElement["Quantity"] as? Float
            let Price = jsonElement["Price"] as? Float
            let ItemID = jsonElement["Item_Id"] as? Int
            
            
                FridgeItem.name = name
                FridgeItem.MfgDate = MfgDate
                FridgeItem.ExpDate = ExpDate
                FridgeItem.quantity = Quantity
                FridgeItem.price = Price
                FridgeItem.ID = ItemID
            
            FridgeItems.append(FridgeItem)
            Names.append(FridgeItem.name ?? "Item")
            ID.append(FridgeItem.ID ?? 1)
            
        }
        
        /*if self.refreshControl.isRefreshing
        {
            self.refreshControl.endRefreshing()
        }*/
    }
    
    func tableView(_ tableView: UITableView, canEditRowAtindexPath indexPath: NSIndexPath!) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            //Names.remove(at: indexPath.row)
            //ID.remove(at: indexPath.row)
            print(Names[indexPath.row])
            print(ID[indexPath.row])
            itemTableView.reloadData()
        }
    }
    
    /*@objc private func refreshItemList(_ sender: Any)
    {
        fetchItemList()
    }*/
    
    
    @IBAction func Reload(_ sender: UIButton)
    {
        fetchItemList()
        itemTableView.reloadData()
    }
    
}
