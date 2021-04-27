//
//  CollectionCell.swift
//  metronome
//
//  Created by Egor on 1/22/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

// MARK: - Main

class CollectionCell: UICollectionViewCell {
  static let reuseID = String(describing: CollectionCell.self) + "View"
  static let nib = UINib(nibName: reuseID, bundle: nil)

  @IBOutlet weak var soundButton: UIButton!

  var index = 0
}
