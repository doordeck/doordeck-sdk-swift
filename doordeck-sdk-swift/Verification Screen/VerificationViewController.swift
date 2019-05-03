//
//  VerificationViewController.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import UIKit

class VerificationViewController: UIViewController {
    
    var apiClient: APIClient!
    var sodium: SodiumHelper!
    var delegate: DoordeckInternalProtocol?
    let notifier = NotificationCenter.default
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hiddenTextField: UITextField!
    @IBOutlet weak var verificationCode1: UILabel!
    @IBOutlet weak var verificationCode2: UILabel!
    @IBOutlet weak var verificationCode3: UILabel!
    @IBOutlet weak var verificationCode4: UILabel!
    @IBOutlet weak var verificationCode5: UILabel!
    @IBOutlet weak var verificationCode6: UILabel!
    @IBOutlet weak var verificationCodeCentre: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
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
        registerKeybaord()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenTextField.becomeFirstResponder()
        hiddenTextField.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeKeyboard()
        super.viewDidDisappear(animated)
    }
    
    func sendVerificationRequest()  {
        guard let publicKey = sodium.getPublicKey() else {
            return
        }
        
        apiClient.startVerificationProcess(publicKey) { (json, error) in
            
        }
    }
    
    @IBAction func resendVerificationCode(_ sender: Any) {
        sendVerificationRequest()
    }
    
    func setUpUI() {
        view.backgroundColor = .doordeckPrimaryColour()
        resendButton.doordeckStandardButton(AppStrings.resendCode, backgroundColour: UIColor.clear)
        sendButton.doordeckStandardButton(AppStrings.send)
        titleLabel.attributedText = NSAttributedString.doordeckH1Bold(AppStrings.verificationTitle)
        topLabel.attributedText = NSAttributedString.doordeckH3(AppStrings.verification)
        hiddenTextField.isHidden = true
        
        if #available(iOS 12.0, *) {
            hiddenTextField.textContentType = UITextContentType.oneTimeCode
        }
        
        hiddenTextField.keyboardType = UIKeyboardType.numberPad
        
        verificationCodeCentre.attributedText = NSAttributedString.doordeckH3Bold("-")
        
        verificationCode1.doordeckLabel()
        verificationCode2.doordeckLabel()
        verificationCode3.doordeckLabel()
        verificationCode4.doordeckLabel()
        verificationCode5.doordeckLabel()
        verificationCode6.doordeckLabel()
    }
    
    @IBAction func sendCodeToServer(_ sender: Any) {
        guard let signature = sodium.signVerificationCode(hiddenTextField.text!) else {return}
        apiClient.checkVerificationProcess(signature) { [weak self](certificateChain, error) in
            if error == nil {
                guard let certificateChainTemp = certificateChain else {
                    self?.delegate?.verificationUnsuccessful()
                    return
                }
                
                self?.dismiss(animated: false, completion: {
                    SDKEvent().event(.CODE_VERIFICATION_SUCCESS)
                    self?.delegate?.verificationSuccessful(CertificateChainClass(certificateChainTemp))
                })
            } else {
                SDKEvent().event(.CODE_VERIFICATION_FAILED)
                self?.delegate?.verificationUnsuccessful()
            }
        }
    }
    
    
    @IBAction func textFieldEdited(_ textField: UITextField) {
        fillOutCode(textField.text ?? "")
    }
    
    func fillOutCode(_ code: String)  {
        var characters = Array(code)
        verificationCodeCentre.attributedText = NSAttributedString.doordeckH3Bold("-")
        if characters.indices.contains(0) {
            verificationCode1.attributedText = NSAttributedString.doordeckH3Bold(String(characters[0]))
        } else {
            verificationCode1.text = ""
        }
        
        if characters.indices.contains(1) {
            verificationCode2.attributedText = NSAttributedString.doordeckH3Bold(String(characters[1]))
        } else {
            verificationCode2.text = ""
        }
        
        if characters.indices.contains(2) {
            verificationCode3.attributedText = NSAttributedString.doordeckH3Bold(String(characters[2]))
        } else {
            verificationCode3.text = ""
        }
        
        if characters.indices.contains(3) {
            verificationCode4.attributedText = NSAttributedString.doordeckH3Bold(String(characters[3]))
        } else {
            verificationCode4.text = ""
        }
        
        if characters.indices.contains(4) {
            verificationCode5.attributedText = NSAttributedString.doordeckH3Bold(String(characters[4]))
        } else {
            verificationCode5.text = ""
        }
        
        if characters.indices.contains(5) {
            verificationCode6.attributedText = NSAttributedString.doordeckH3Bold(String(characters[5]))
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

extension VerificationViewController {
    func registerKeybaord() {
        notifier.addObserver(self,
                             selector: #selector(keyboardWillShow(_:)),
                             name: UIWindow.keyboardWillShowNotification,
                             object: nil)
        notifier.addObserver(self,
                             selector: #selector(keyboardWillHide(_:)),
                             name: UIWindow.keyboardWillHideNotification,
                             object: nil)
    }
    
    func removeKeyboard() {
        notifier.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        animateContraintChange(duration, contraint: bottomConstraint, endPosition: Double(targetFrame.height))
        
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification){
        animateContraintChange(0.25, contraint: bottomConstraint, endPosition: 0)
    }
    
    func animateContraintChange(_ time: Double, contraint:NSLayoutConstraint, endPosition: Double) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: time, animations: {
            contraint.constant = CGFloat(endPosition)
            self.view.layoutIfNeeded()
        })
    }
}

