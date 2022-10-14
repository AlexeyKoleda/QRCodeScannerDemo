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
    private var codeOutputHandler: (_ code: String) -> Void
    
    init(
        with viewController: UIViewController,
        view: UIView,
        codeOutputHandler: @escaping (String) -> Void
    ) {
        self.viewController = viewController
        self.codeOutputHandler = codeOutputHandler
        
        super.init()
        
        if let captureSession = self.createCaptureSession() {
            self.captureSession = captureSession
            let previewLayer = self.createPreviewLayer(with: captureSession, view: view)
            view.layer.addSublayer(previewLayer)
        }
    }
    
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
    
    // Returns an array of all the Barcodes and QRCode that we will be able to scan
    private func metaObjectTypes() -> [AVMetadataObject.ObjectType] {
        return [
            .qr,
            .code128,
            .code39,
            .code39Mod43,
            .code93,
            .ean13,
            .ean8,
            .interleaved2of5,
            .itf14,
            .pdf417,
            .upce
        ]
    }
    
    private func createPreviewLayer(
        with captureSession: AVCaptureSession,
        view: UIView
    ) -> AVCaptureVideoPreviewLayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        
        return previewLayer
    }
}
