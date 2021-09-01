//
//  MultiDoorUnlockViewController.swift
//  Doordeck
//
//  Copyright © 2021 Doordeck. All rights reserved.
//

import Foundation
import UIKit

class MultiDoorUnlockViewController: UIViewController, UICollectionViewDelegate {
    var locks: [LockDevice]!
    var headerView: UIView!
    var titleLabel: UILabel!
    var locksCollection: UICollectionView!
    
    init(_ locks: [LockDevice]) {
        
        self.locks = locks
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderAndTitleLabel()
        setupCollection()
    }
    
    func setupCollection() {
        let frame = self.view.frame
        let layout = UICollectionViewFlowLayout()
        locksCollection = UICollectionView(frame: frame, collectionViewLayout: layout)
        self.view.addSubview(locksCollection)
        
        locksCollection.translatesAutoresizingMaskIntoConstraints = false
        locksCollection.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        locksCollection.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        locksCollection.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        locksCollection.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true

        locksCollection.register(LockCollectionViewCell.self, forCellWithReuseIdentifier: "myCell")
        locksCollection.delegate = self
        locksCollection.dataSource = self
    }
    
    func setupHeaderAndTitleLabel() {
            // Initialize views and add them to the ViewController's view
            headerView = UIView()
            headerView.backgroundColor = .red
            self.view.addSubview(headerView)
            
            titleLabel = UILabel()
            titleLabel.text = "Please pick a lock to unlock"
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 20)
            headerView.addSubview(titleLabel)
            
            // Set position of views using constraints
            headerView.translatesAutoresizingMaskIntoConstraints = false
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            headerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
            headerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
            titleLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.4).isActive = true
            titleLabel.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 0.5).isActive = true
        }
}

extension MultiDoorUnlockViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! LockCollectionViewCell
        cell.lock = locks[indexPath.row]
        cell.commonInit()
        return cell
    }
}


class LockCollectionViewCell: UICollectionViewCell {
    
    var label: UILabel!
    var lock: LockDevice!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func commonInit() {
        label = UILabel(frame: contentView.frame)
        contentView.addSubview(label)
        label.textAlignment = .center
        label.font = UIFont(name: label.font.fontName, size: 12)
        label.isHidden = true
        
        guard let lockTemp = lock else { return }
        lockTemp.deviceConnect { json, error in
                
            } progress: { Progress in
                
            } currentLockStatus: { [weak self]  currentStatus in
                if currentStatus == .lockInfoRetrieved {
                    self?.label?.text = self?.lock.name
                    self?.label?.isHidden = true
                } else if currentStatus == .lockInfoRetrievalFailed {
                    
                }
            } reset: {
                
            }
        self.contentView.backgroundColor = .white
    }
}
