//
//  Scanner.swift
//  QRCodeScannerDemo
//
//  Created by Alexey Koleda on 14.10.2022.
//

import UIKit
import AVFoundation

class Scanner: NSObject {
    private var viewController: UIViewController
    private var captureSession: AVCaptureSession?
    private var codeOutputandler: (_ code: String) -> Void
    
    private func createCaptureSession() -> AVCaptureSession? {
        do {
            let captureSession = AVCaptureSession()
            
            guard let captureDevice = AVCaptureDevice.default(for: .video)
            else { return nil }
            
            // Add device input
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
            
            // Add metadata output
            let metaDataOutput = AVCaptureMetadataOutput()
            if captureSession.canAddOutput(metaDataOutput) {
                captureSession.addOutput(metaDataOutput)
                
                if let vc = self.viewController as? AVCaptureMetadataOutputObjectsDelegate {
                    metaDataOutput.setMetadataObjectsDelegate(vc, queue: DispatchQueue.main)
                    metaDataOutput.metadataObjectTypes = self.metaObjectTypes()
                } else {
                    return nil
                }
            }
        } catch {
            return nil
        }
        return captureSession
    }
}
