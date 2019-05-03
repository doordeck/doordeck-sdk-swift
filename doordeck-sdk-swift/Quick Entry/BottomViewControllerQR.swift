//
//  BottomViewControllerQR.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.


import Foundation
import UIKit
import AVFoundation
import QRCodeReader

class BottomViewControllerQR: UIViewController {
    var delegate: quickEntryDelegate?
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroundQRcodeImage: UIImageView!
    @IBOutlet weak var backgroundQRcodeImageCrossHair: UIImageView!
    @IBOutlet weak var QRCodeImage: UIImageView!
    
    lazy var reader = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
        $0.reader          = QRCodeReader(metadataObjectTypes: [AVMetadataObject.ObjectType.qr])
        $0.showTorchButton = false
        $0.showCancelButton = false
        $0.showSwitchCameraButton = false
    })
    
    var QRsetup = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if QRsetup == false {
            self.setUpQR()
        } else {
            reader.startScanning()
        }
    }
    
    func setupUI() {
        view.backgroundColor = .doordeckPrimaryColour()
        backgroundQRcodeImage.image = UIImage(named: "Qr_Background_Back_Light")
        backgroundQRcodeImage.setImageColor(color: UIColor.doordeckPrimaryColour())
        backgroundQRcodeImage.contentMode = .scaleAspectFill
        
        QRCodeImage.image = UIImage(named: "QR_Tile")
        QRCodeImage.setImageColor(color: UIColor.doordeckQuaternaryColour())
        
        backgroundQRcodeImageCrossHair.image = UIImage(named: "Qr_Background_Front_Light")
        backgroundQRcodeImageCrossHair.contentMode = .scaleAspectFill
        
        bottomLabel.attributedText = NSAttributedString.doordeckH3Bold(AppStrings.touchQR)
        descriptionLabel.attributedText = NSAttributedString.doordeckH4(AppStrings.touchQRMessage)
    }
    
}

extension BottomViewControllerQR: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
    }
    
    fileprivate func setUpQR() {
        
        
        do {
            if try QRCodeReader.supportsMetadataObjectTypes() {
                reader.modalPresentationStyle = .none
                reader.delegate = self
                
                reader.completionBlock = { (result: QRCodeReaderResult?) in
                    if let result = result {
                        guard let QRCode: String = result.value as String? else {
                            //To-Do error message
                        }
                        
                        guard let QRCodeURL = URL(string: QRCode)?.pathComponents else {return}
                        for comp in QRCodeURL {
                            if let lockUUID = UUID(uuidString: comp) {
                                
                                self.delegate?.lockDetected(lockUUID.uuidString)
                            }
                        }
                    }
                }
                reader.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
                view.addSubview(reader.view)
                view.sendSubviewToBack(reader.view)
                QRsetup = true
            }
        } catch {
            let alert = UIAlertController(title: AppStrings.error, message: AppStrings.readerNotSupported, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: AppStrings.ok, style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }
}
