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
    var delegate: DoordeckMultiLock!
    
    init(_ locks: [LockDevice], delegate: DoordeckMultiLock) {
        
        self.locks = locks
        self.delegate = delegate
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            delegate.failedToPick()
        }
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
        locksCollection.backgroundColor = UIColor.doordeckPrimaryColour()
    }
    
    func setupHeaderAndTitleLabel() {
        // Initialize views and add them to the ViewController's view
        headerView = UIView()
        headerView.backgroundColor = UIColor.doorDarkGrey()
        self.view.addSubview(headerView)
        
        titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString.doordeckH1Bold(AppStrings.pickOne)
        titleLabel.textAlignment = .center
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 25, left: 15, bottom: 0, right: 5)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        delegate.pickedALock(lock: locks[indexPath.row])
    }
}

extension MultiDoorUnlockViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 300.0, height: 100.0)
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
        
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        
        label = UILabel(frame: contentView.frame)
        contentView.addSubview(label)
        label.textAlignment = .center
        label.isHidden = true
        label.numberOfLines = 0
        
        guard let lockTemp = lock else { return }
        
        self.label.attributedText = NSAttributedString.doordeckH3(lockTemp.name)
        self.label.isHidden = false
        self.label?.backgroundColor = lockTemp.colour
        self.contentView.backgroundColor = lockTemp.colour
    }
}
