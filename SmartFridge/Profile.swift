//
//  Profile.swift
//  SmartFridge
//
//  Created by Divyankitha Raghava Urs on 11/28/17.
//  Copyright © 2017 SJSU. All rights reserved.
//

import UIKit

class Profile: UIViewController {

    @IBOutlet weak var Fname: UITextField!
    @IBOutlet weak var Lname: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Contact: UITextField!
    @IBOutlet weak var Uname: UITextField!
    @IBOutlet weak var SaveButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        SaveButton.setTitleColor(UIColor.gray, for: .disabled)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func Edit(_ sender: UIButton)
    {
        Fname.isUserInteractionEnabled = true
        Fname.becomeFirstResponder()
    
        Lname.isUserInteractionEnabled = true
        Lname.becomeFirstResponder()
        
        Email.isUserInteractionEnabled = true
        Email.becomeFirstResponder()
        
        Contact.isUserInteractionEnabled = true
        Contact.becomeFirstResponder()
        
        Uname.isUserInteractionEnabled = true
        Uname.becomeFirstResponder()
        
        SaveButton.isUserInteractionEnabled = true
    }
    
    @IBAction func Save(_ sender: UIButton)
    {
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
