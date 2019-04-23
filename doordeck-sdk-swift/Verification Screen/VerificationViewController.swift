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
    var delegate: DoordeckProtocol?
    
    init(_ apiClient: APIClient) {
        self.apiClient = apiClient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
