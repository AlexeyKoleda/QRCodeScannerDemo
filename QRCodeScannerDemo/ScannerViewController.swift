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

    // UI initialisation in controller just for demo, should be in different class
    private(set) lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupMessageLabelView() {
        messageLabel.text = "NO QR code data"
        self.view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            messageLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            messageLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 100.0)
        ])
    }
    
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scanner = Scanner(withDelegate: self)
        
        guard let scanner = self.scanner
        else { return }

        scanner.requestCaptureSessionStartRunning()
        setupMessageLabelView()
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
    
    func scanCompleted(with code: String) {
        messageLabel.text = code
    }
}
