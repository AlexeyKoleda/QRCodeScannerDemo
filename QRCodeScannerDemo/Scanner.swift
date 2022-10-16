//
//  Scanner.swift
//  QRCodeScannerDemo
//
//  Created by Alexey Koleda on 14.10.2022.
//

import UIKit
import AVFoundation

protocol ScannerDelegate: AnyObject {
    func cameraView() -> UIView
    func delegateViewController() -> UIViewController
    func scanCompleted(with code: String)
}

class Scanner: NSObject {
    public weak var delegate: ScannerDelegate?
    private var captureSession : AVCaptureSession?
    
    // MARK: Initialisation
    init(withDelegate delegate: ScannerDelegate) {
        self.delegate = delegate
        super.init()
        self.scannerSetup()
    }
    
    // MARK: Public methods
    public func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        self.requestCaptureSessionStopRunning()
        
        guard let metadataObject = metadataObjects.first,
            let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
            let scannedValue = readableObject.stringValue,
            let delegate = self.delegate
        else { return }
            
        delegate.scanCompleted(with: scannedValue)
    }
    
    public func requestCaptureSessionStartRunning() {
        self.toggleCaptureSessionRunningState()
    }
    
    public func requestCaptureSessionStopRunning() {
        self.toggleCaptureSessionRunningState()
    }
    
    // MARK: Private methods
    private func scannerSetup() {
        guard let captureSession = self.createCaptureSession(),
              let delegate = self.delegate
        else { return }
        
        self.captureSession = captureSession
        
        let cameraView = delegate.cameraView()
        let previewLayer = self.createPreviewLayer(with: captureSession, view: cameraView)
        cameraView.layer.addSublayer(previewLayer)
    }
    
    private func createCaptureSession() -> AVCaptureSession? {
        do {
            let captureSession = AVCaptureSession()
            guard let captureDevice = AVCaptureDevice.default(for: .video)
            else { return nil }
            
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            let metaDataOutput = AVCaptureMetadataOutput()
            
            // Add device input and metadata output
            if captureSession.canAddInput(deviceInput)
                && captureSession.canAddOutput(metaDataOutput) {
                
                captureSession.addInput(deviceInput)
                captureSession.addOutput(metaDataOutput)
                
                guard let delegate = self.delegate,
                      let viewController = delegate.delegateViewController()
                        as? AVCaptureMetadataOutputObjectsDelegate
                else { return nil }
                
                metaDataOutput.setMetadataObjectsDelegate(viewController,
                                                          queue: DispatchQueue.main)
                metaDataOutput.metadataObjectTypes = self.metaObjectTypes()
                
                return captureSession
            }
        } catch let error {
            print("failed to create capture session: \(error)")
        }
        return nil
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
    
    private func toggleCaptureSessionRunningState() {
        guard let captureSession = self.captureSession
        else { return }
        
        captureSession.isRunning ?
        captureSession.stopRunning() : captureSession.startRunning()
    }
    
    // Returns an array of all the Barcodes and QRCode that we will be able to scan
    func metaObjectTypes() -> [AVMetadataObject.ObjectType] {
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
}
