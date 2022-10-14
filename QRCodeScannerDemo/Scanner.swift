//
//  Scanner.swift
//  QRCodeScannerDemo
//
//  Created by Alexey Koleda on 14.10.2022.
//

import Foundation
import AVFoundation


class Scanner: NSObject {
    private var viewController: UIViewController
    private var captureSession: AVCaptureSession?
    private var codeOutputandler: (_ code: String) -> Void
}
