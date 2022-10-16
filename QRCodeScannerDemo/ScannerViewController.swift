//
//  ViewController.swift
//  QRCodeScannerDemo
//
//  Created by Alexey Koleda on 14.10.2022.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController {
    
    var scanner: Scanner?
    
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scanner = Scanner(withDelegate: self)
        
        guard let scanner = self.scanner
        else { return }

        scanner.requestCaptureSessionStartRunning()
    }
}

// MARK: AVCaptureMetadataOutputObjectsDelegate
extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let scanner = self.scanner
        else { return }
        
        scanner.metadataOutput(
            output,
            didOutput: metadataObjects,
            from: connection
        )
    }
}

// MARK: ScannerDelegate
extension ScannerViewController: ScannerDelegate {
    func cameraView() -> UIView {
        return self.view
    }
    
    func delegateViewController() -> UIViewController {
        return self
    }
    
    func scanCompleted(withCode code: String) {
        print(code)
    }
}
