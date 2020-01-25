//
//  SelectionCollectionViewController.swift
//  metronome
//
//  Created by Egor on 1/22/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class SelectionCollectionViewController<DataType: Data>: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
        // MARK: - Public Properties
    
        var selectedData: DataType? = nil
        
        // MARK: - Private Properties
        
        // MARK: - Lifecycle
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.collectionView.register(SelectionCollectionViewCell.nib, forCellWithReuseIdentifier: SelectionCollectionViewCell.reuseID)
            
            collectionView.dataSource = self
            collectionView.delegate = self

        }

        // MARK: - IBActions
        
        // MARK: UICollectionViewDataSource
        
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return DataType.all.count
        }
    
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectionCollectionViewCell.reuseID, for: indexPath) as? SelectionCollectionViewCell else {
                fatalError("Wrong cell")
            }
            
            cell.dataToDisplay = DataType.all[indexPath.row]
            cell.dataButton.addTarget(self, action: #selector(close), for: .touchUpInside)
            
            return cell
        }
    
    @objc func close(_ sender: UIButton) {
        
        guard let selectedTab = (presentingViewController as? UITabBarController)?.selectedIndex,
              let TableVC = presentingViewController?.children[selectedTab] as? EditableTable
        else {
            return
        }
        
        let cell = sender.superview?.superview as! SelectionCollectionViewCell
        selectedData = cell.dataToDisplay as? DataType
        
        let path = TableVC.indexPathToEditingCell
        TableVC.delegate?.data[path.section][path.row] = selectedData
        TableVC.delegate?.tableView?.reloadData()
        
        dismiss(animated: true)
    }
    
        // MARK: UICollectionViewDelegate

        override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
            return true
        }
    
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 100, height: 100)
        }

    }
