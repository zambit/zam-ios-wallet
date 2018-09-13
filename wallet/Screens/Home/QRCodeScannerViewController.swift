//
//  QRCodeScannerViewController.swift
//  wallet
//
//  Created by Alexander Ponomarev on 31/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

protocol QRCodeScannerViewControllerDelegate: class {

    func qrCodeScannerViewController(_ qrCodeScannerViewController: QRCodeScannerViewController, didFindCode: String)

    func qrCodeScannerViewControllerDidntFindCode(_ qrCodeScannerViewController: QRCodeScannerViewController)

}

class QRCodeScannerViewController: FlowViewController, WalletNavigable {

    weak var delegate: QRCodeScannerViewControllerDelegate?

    var onClose: ((WalletNavigable) -> Void)?

    var captureSession = AVCaptureSession()

    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?

    private let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupOverlayView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        migratingNavigationController?.custom.addBackButton(for: self, target: self, action: #selector(closeButtonTouchUpInsideEvent(_:)))

        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device")
            return
        }

        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)

            // Set the input device on the capture session.
            captureSession.addInput(input)

            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)

            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]

        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }

        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)

        // Start video capture.
        captureSession.startRunning()

        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()

        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupOverlayView() {
        let overlay = OverlayView(frame: view.frame)
        overlay.innerFrame = CGRect(x: view.frame.width * (1 / 6), y: (view.frame.height - view.frame.width / 1.5) / 2, width: view.frame.width / 1.5, height: view.frame.width / 1.5)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.2)


        view.addSubview(overlay)
    }

    @objc
    private func closeButtonTouchUpInsideEvent(_ sender: UIButton) {
        onClose?(self)
    }
}

extension QRCodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            delegate?.qrCodeScannerViewControllerDidntFindCode(self)
            return
        }

        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds

            if let result = metadataObj.stringValue {
                //launchApp(decodedURL: result)
                print(result)
                delegate?.qrCodeScannerViewController(self, didFindCode: result)
                Interactions.vibrateSuccess()
                onClose?(self)
                //messageLabel.text = metadataObj.stringValue
            }
        }
    }
}

class OverlayView: UIView {

    var innerFrame: CGRect?

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let innerFrame = innerFrame else {
            return
        }

        self.backgroundColor?.setFill()
        UIRectFill(rect)

        let layer = CAShapeLayer()
        let path = CGMutablePath()

        path.addRect(innerFrame)
        path.addRect(bounds)

        layer.path = path
        layer.fillRule = kCAFillRuleEvenOdd
        self.layer.mask = layer
    }
}
