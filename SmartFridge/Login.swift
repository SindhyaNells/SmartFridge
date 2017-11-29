//
//  Login.swift
//  SmartFridge
//
//  Created by Divyankitha Raghava Urs on 11/19/17.
//  Copyright © 2017 SJSU. All rights reserved.
//

import UIKit

class Login: UIViewController {

    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginButton(_ sender: UIButton)
    {
        print("From log in function" )
        print(usernameTextfield.text ?? "username Error")
        print(passwordTextfield.text ?? "password Error")
        
        let DNS = RestApiUrl ()
        
        
        /*let itemString = displayItem.text
         
         let name = itemString?.components(separatedBy: "\nQ").first
         
         let quantity = itemString?.components(separatedBy: "\nP").first
         
         let price = itemString?.components(separatedBy: "\nM").first
         
         let mfg = itemString?.components(separatedBy: "\nE").first
         
         let exp = itemString?.components(separatedBy: "\n").first
         
         print(name ?? "error")
         print(quantity ?? "error")
         print(price ?? "error")
         print(mfg ?? "error")
         print(exp ?? "error")*/
        
        let username = usernameTextfield.text
        let password = passwordTextfield.text
        
        
        //POST Request to Add items to fridge
        let params = ["Username":username, "Password":password] as! Dictionary<String,String>
        
        //print(params)
        
        var request = URLRequest(url: URL(string: DNS.aws + "/SmartFridgeBackend/fridge/addNewItem")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        print("Printing response next")
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print( response ?? "Error connecting to Rest API - Add Items to fridge")
            if error != nil
            {
                print("Failed to connect to Add Item API")
                print(error!)
            }
            else
            {
                print("Connected to Add Item API")
            }
            
            if let httpResponse = response as? HTTPURLResponse
            {
                if httpResponse.statusCode == 200
                {
                    print("Inserted!")
                    let alert = UIAlertController(title: "Smart Refrigerator", message: "Login successful", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else
                {
                    print(httpResponse.statusCode)
                    let alert = UIAlertController(title: "Smart Refrigerator", message: "Item Not Added To Refrigerator, Retry!" , preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        })
        
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "checkLogin"
        {
            var dashboardSegue = segue.destination as? Dashboard
            dashboardSegue?.id = 1
        }
    }
    

}
