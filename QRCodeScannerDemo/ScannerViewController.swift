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
        
        self.scanner = Scanner(with: self, view: self.view, codeOutputHandler: self.handleCode)
        if let scanner = self.scanner {
            scanner.requestCaptureSessionStartRunning()
        }
    }

    // MARK: Public methods
    func handleCode(_ code: String) {
        // Mock functional with scanned code
        print(code)
    }

}

// MARK: AVCaptureMetadataOutputObjectsDelegate
extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        self.scanner?.scannerDelegate(output, didOutput: metadataObjects, from: connection)
    }
}

