//
//  SelectionCollectionViewCell.swift
//  metronome
//
//  Created by Egor on 1/22/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class SelectionCollectionViewCell: UICollectionViewCell {
    static let reuseID = String(describing: SelectionCollectionViewCell.self)
    static let nib = UINib(nibName: String(describing: SelectionCollectionViewCell.self), bundle: nil)
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var dataButton: UIButton!
    
    // MARK: - Public Properties
    
    var dataToDisplay: Data? = nil {
        didSet {
            dataButton.setBackgroundImage(UIImage(named: dataToDisplay?.name() ?? "None"), for: .normal)
        }
    }
    
}
