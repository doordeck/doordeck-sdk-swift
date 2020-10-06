//
//  ButtonViewController.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import UIKit
#if canImport(CoreNFC)
import CoreNFC


protocol quickEntryDelegate {
    func lockDetected(_ UUID: String)
    func showQRCode()
}

@available(iOS 11, *)
class BottomViewController: UIViewController {
    
    @IBOutlet weak var nfcScan: UIButton!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var QRCodeImage: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    var delegate: quickEntryDelegate?
    var controlDelegate: DoordeckControl?
    var payloads = [NFCNDEFPayload]()
    var session: NFCNDEFReaderSession?
    var showNFCBool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(resetShowNFC), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(showNFC), name: .showNFCReader, object: nil)
        notificationCenter.addObserver(self, selector: #selector(resetShowNFC), name: .hideNFCReader, object: nil)
        notificationCenter.addObserver(self, selector: #selector(showNFC), name: .dismissLockUnlockScreen, object: nil)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showNFC()
        
        guard let control = self.controlDelegate else { return }
        if control.showCloseButton == true {
            closeButton.isHidden = false
            closeButton.isEnabled = true
        } else {
            closeButton.isHidden = true
            closeButton.isEnabled = false
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupUI() {
        view.backgroundColor = .doordeckPrimaryColour()
        bottomLabel.attributedText = NSAttributedString.doordeckH3Bold(AppStrings.touchNFC)
        descriptionLabel.attributedText = NSAttributedString.doordeckH4(AppStrings.touchNFCMessage)
        QRCodeImage.image = UIImage(named: "QR_Tile")
        QRCodeImage.setImageColor(color: UIColor.doordeckQuaternaryColour())
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: false) {
            SDKEvent().event(.CLOSE_NFC_VIEW)
        }
    }
    
    @objc func resetShowNFC() {
        session?.invalidate()
        showNFCBool = true
    }
    
    @IBAction func nfcScanClicked(_ sender: Any) {
        showNFCBool = true
        showNFC()
    }
    
    @objc func showNFC() {
        if showNFCBool {
            session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
            if #available(iOS 12.0, *) {
                session?.alertMessage = AppStrings.nfcString
            }
            session?.begin()
            showNFCBool = false
        }
    }
}
@available(iOS 11, *)
extension BottomViewController: NFCNDEFReaderSessionDelegate {
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        guard let readerError = error as? NFCReaderError else {
            return
        }
        switch readerError.code {
        case .readerSessionInvalidationErrorFirstNDEFTagRead :
            showNFCBool = true
            break
        case .readerSessionInvalidationErrorUserCanceled:
            showNFCBool = false
            break
        default: break
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        if let message = messages.first {
            payloads = message.records
            NFCDetected(message.records)
        }
    }
    
    func NFCDetected(_ payloads: [NFCNDEFPayload]) {
        
        
        self.session?.invalidate()
        
        for payload in payloads {
            let record = payload
            let payloadTemp = String(data: record.payload, encoding: .utf8) ?? "No payload"
            
            if payloadTemp.count == 39 {
                
                let stripped = String(payloadTemp.dropFirst(3))
                print(.NFC, object: "payload \(stripped)")
                delegate?.lockDetected(stripped)
            }
        }
        
    }
}

@available(iOS 11, *)
extension NFCNDEFPayload {
    
    var fullDescription: String {
        var description = "TNF (TypeNameFormat): \(typeDescription)\n"
        
        let payload = String(data: self.payload, encoding: .utf8) ?? "No payload"
        let type = String(data: self.type, encoding: .utf8) ?? "No type"
        let identifier = String(data: self.identifier, encoding: .utf8) ?? "No identifier"
        
        description += "Payload: \(payload)\n"
        description += "Type: \(type)\n"
        description += "Identifier: \(identifier)\n"
        
        return description.replacingOccurrences(of: "\0", with: "")
    }
    
    var typeDescription: String {
        switch typeNameFormat {
        case .nfcWellKnown:
            return String(data: type, encoding: .utf8) ?? "Invalid data"
        case .absoluteURI:
            return String(data: payload, encoding: .utf8) ?? "Invalid data"
        case .media:
            if let type = String(data: type, encoding: .utf8) {
                return "Media type: " + type
            }
            return "Invalid data"
        case .nfcExternal:
            return "NFC External type"
        case .unknown:
            return "Unknown type"
        case .unchanged:
            return "Unchanged type"
        case .empty:
            return "Invalid data"
        @unknown default:
            return "Unknown type"
        }
    }
}


#endif
