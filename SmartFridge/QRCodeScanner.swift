//
//  QRCodeScanner.swift
//  SmartFridge
//
//  Created by Divyankitha Raghava Urs on 11/2/17.
//  Copyright © 2017 SJSU. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeScanner: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    var avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer();
    
    @IBOutlet var videoPreview: UIView!
    
    @IBOutlet weak var square: UIImageView!
    
    @IBOutlet weak var displayItem: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    var scannedString = String()
    
    enum error:Error
    {
        case noCameraAvailable
        case videoInputInitFail
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func startScan(_ sender: UIButton)
    {
    
        print("Scan Button clicked!")
        
       do{
            try scanTheQRCode()
        }catch {
            print("Failed to scan QR/Barcode")
        }
    }
    
    
    func scanTheQRCode()throws
    {
        
        let avCaptureSession = AVCaptureSession()
        
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else
        {
            print("No Camera found!")
            throw error.noCameraAvailable
           
        }
        
        guard let avCaptureInput = try? AVCaptureDeviceInput(device:avCaptureDevice) else
        {
        print("Failed to initiate Camera!")
            throw error.videoInputInitFail
            
        }
        
        
        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
    
        avCaptureSession.addInput(avCaptureInput)
        avCaptureSession.addOutput(avCaptureMetadataOutput)
        
        avCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avCaptureVideoPreviewLayer.frame = videoPreview.bounds
        self.videoPreview.layer.addSublayer(avCaptureVideoPreviewLayer)
        
        
        self.view.bringSubview(toFront: square)
        
        avCaptureSession.startRunning()
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
    {
        
        if metadataObjects.count > 0
        {
            print("Inside First loop")
            let machineReadableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if machineReadableCode.type == AVMetadataObject.ObjectType.qr
            {
                
                let alert = UIAlertController(title: "Item Scanned", message: machineReadableCode.stringValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                /*alert.addAction(UIAlertAction(title: "", style: .default, handler: {(nil)in UIPasteboard.general.string = machineReadableCode.stringValue
                }))*/
                present(alert, animated: true, completion: nil)
                scannedString = machineReadableCode.stringValue!
                displayItem.text = scannedString;
                print(scannedString)
                
            }
        }
        
    }
    
    @IBAction func AddToFridge(_ sender: UIButton)
    {
        //let items = FridgeItemsModel ()
        print("From add to fridge function" )
        print(displayItem.text ?? "Scan Error")
        
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
        
        let name = "Eggs"
        let quantity = "6"
        let price = "2"
        let mfg = "10/10/2017"
        let exp = "11/10/2017"
        
        //POST Request
        let params = ["userID":"3", "name":name,"quantity": quantity,"price": price, "mfgDate":mfg, "expDate":exp, "status":"ispresent"] as Dictionary<String,String>
        
        var request = URLRequest(url: URL(string: DNS.aws + "/SmartFridgeBackend/fridge/addNewItem")!) 
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response ?? "Error connecting to Rest API - Add Items to fridge")
            
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
        
    }
    
    func parseJSON(_ data:Data)
    {
        
        var jsonResult = NSArray()
        
      do{
            
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError
        {
            print(error)
        }
        
       print("Inside parse JSON")
       print(jsonResult)
        
    }
    
    
}



