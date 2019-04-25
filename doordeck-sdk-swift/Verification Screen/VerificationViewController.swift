//
//  VerificationViewController.swift
//  doordeck-sdk-swift-sample
//
//  Created by Marwan on 23/04/2019.
//  Copyright © 2019 Doordeck. All rights reserved.
//

import UIKit

class VerificationViewController: UIViewController {
    
    var apiClient: APIClient!
    var sodium: SodiumHelper!
    var delegate: DoordeckProtocol?
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var hiddenTextField: UITextField!
    @IBOutlet weak var verificationCode1: UILabel!
    @IBOutlet weak var verificationCode2: UILabel!
    @IBOutlet weak var verificationCode3: UILabel!
    @IBOutlet weak var verificationCode4: UILabel!
    @IBOutlet weak var verificationCode5: UILabel!
    @IBOutlet weak var verificationCode6: UILabel!
    @IBOutlet weak var verificationCodeCentre: UILabel!
    
    init(_ apiClient: APIClient, sodium: SodiumHelper) {
        self.apiClient = apiClient
        self.sodium = sodium
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        sendVerificationRequest()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenTextField.becomeFirstResponder()
        hiddenTextField.delegate = self
    }
    
    func sendVerificationRequest()  {
        guard let publicKey = sodium.getPublicKey() else {
            return
        }
        
        apiClient.startVerificationProcess(publicKey) { (json, error) in
            
        }
    }
    
    func setUpUI() {
        topLabel.attributedText = NSAttributedString.doordeckH3(AppStrings.verification)
        hiddenTextField.isHidden = true
        
        if #available(iOS 12.0, *) {
            hiddenTextField.textContentType = UITextContentType.oneTimeCode
        }
        
        hiddenTextField.keyboardType = UIKeyboardType.numberPad
    }
    @IBAction func textFieldEdited(_ textField: UITextField) {
        fillOutCode(textField.text ?? "")
    }
    
    func fillOutCode(_ code: String)  {
        var characters = Array(code)
        if characters.indices.contains(0) {
            verificationCode1.text = String(characters[0])
        } else {
            verificationCode1.text = ""
        }
        
        if characters.indices.contains(1) {
            verificationCode2.text = String(characters[1])
        } else {
            verificationCode2.text = ""
        }
        
        if characters.indices.contains(2) {
            verificationCode3.text = String(characters[2])
        } else {
            verificationCode3.text = ""
        }
        
        if characters.indices.contains(3) {
            verificationCode4.text = String(characters[3])
        } else {
            verificationCode4.text = ""
        }
        
        if characters.indices.contains(4) {
            verificationCode5.text = String(characters[4])
        } else {
            verificationCode5.text = ""
        }
        
        if characters.indices.contains(5) {
            verificationCode6.text = String(characters[5])
        } else {
            verificationCode6.text = ""
        }
    }
}

extension VerificationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        else if(textField.text!.count <= 6 ) {
            return true
        } else {
            return false
        }
    }
}
