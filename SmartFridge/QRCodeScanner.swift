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

    @IBOutlet weak var displayScannedItem: UILabel!
    @IBOutlet weak var videoPreview: UIView!
    
    var scannedString = String()
    
    enum error:Error
    {
        case noCameraAvailable
        case videoInputInitFail
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func startScanning(_ sender: UIButton)
    {
        print("Scan Button clicked!")
        
        do{
            try scanTheQRCode()
        }catch {
            print("Failed to scan QR/Barcode")
        }
        
        
    }
    
    func captureOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
    {
        
        if metadataObjects.count > 0 {
            let machineReadableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if machineReadableCode.type == AVMetadataObject.ObjectType.qr {
                scannedString = machineReadableCode.stringValue!
                //set label with above string
                displayScannedItem.text = scannedString
            }
        }
    
    }
    
    func scanTheQRCode()throws
    {
        print("Inside scan function!")
        let avCaptureSession = AVCaptureSession()
        
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else
        {
            print("No Camera found!")
            throw error.noCameraAvailable
            //return
        }
        
        guard let avCaptureInput = try? AVCaptureDeviceInput(device:avCaptureDevice) else
        {
        print("Failed to initiate Camera!")
            throw error.videoInputInitFail
            //return
        }
        
        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        avCaptureSession.addInput(avCaptureInput)
        avCaptureSession.addOutput(avCaptureMetadataOutput)
        
        avCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        let avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        
        avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        avCaptureVideoPreviewLayer.frame = videoPreview.bounds
        
        self.videoPreview.layer.addSublayer(avCaptureVideoPreviewLayer)
        
        avCaptureSession.startRunning()
    }
    
    
    

}
