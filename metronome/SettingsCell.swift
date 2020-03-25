//
//  SettingsCell.swift
//  metronome
//
//  Created by Egor on 3/25/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

// MARK: - Main

class SettingsCell: UITableViewCell {
    static let reuseID = String(describing: SettingsCell.self) + "View"
    static let nib = UINib(nibName: reuseID, bundle: nil)

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
}
