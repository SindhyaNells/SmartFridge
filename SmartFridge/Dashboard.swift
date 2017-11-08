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
    
    var row = 6
    var FridgeItems = Array<FridgeItemsModel>()
    var Names = Array<String>()
    
    let elements = ["apple", "milk", "cheese", "carrot", "strawberry", "eggs"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        itemTableView.delegate = self
        itemTableView.dataSource = self
        
        //fetchItemList()
        
        /*refreshControl.addTarget(self, action: #selector(refreshItemList(_:)), for: .valueChanged)
        itemTableView.refreshControl = refreshControl*/
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return row; //retun the number of items
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = itemTableView.dequeueReusableCell(withIdentifier: "ItemDisplay") as! DashboardTableViewCell
        for FridgeItem in FridgeItems
        {
            self.Names.append(FridgeItem.name!)
        }
        //cell.itemLabel.text = Names[indexPath.row]
        cell.itemLabel.text = "test"
        cell.itemImage.image = UIImage(named: elements[indexPath.row])
        return cell
    }
    
    func fetchItemList()
    {
        
        let DNS = RestApiUrl()
        //let params = ["username":"Divya"] as Dictionary<String,String>
        //let params = ()
        
        var request = URLRequest(url: URL(string: DNS.aws + "/SmartFridgeBackend/user/fridgeItems/3")!) 
        request.httpMethod = "GET"
        //request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.httpBody = try? JSONSerialization.data(withJSONObject: [], options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in print(response!)
            
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data Obtained")
                self.parseJSON(data!)
            }
            /*do {
             let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
             print(json)
             } catch {
             print("error")
             }*/
        })
        
        task.resume()
        
        /*self.viewDidLoad()
        self.refreshControl.endRefreshing()*/
        
    }
    
    func parseJSON(_ data:Data)
    {
        print("Inside parse JSON of dashboard")
        var jsonResult = NSArray()
        
        do{
            
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
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
            
            
            if let name = jsonElement["Name"] as? String,
                let MfgDate = jsonElement["MfgDate"] as? Date,
                let ExpDate = jsonElement["ExpDate"] as? Date,
                let Quantity = jsonElement["Quantity"] as? Float,
                let Price = jsonElement["Price"] as? Float
            {
                
                FridgeItem.name = name
                FridgeItem.MfgDate = MfgDate
                FridgeItem.ExpDate = ExpDate
                FridgeItem.quantity = Quantity
                FridgeItem.price = Price
                
            }
            
            FridgeItems.append(FridgeItem)
            
        }
        
    }
    
    
    /*@objc private func refreshItemList(_ sender: Any)
    {
        fetchItemList()
    }*/
    
    
    
}
