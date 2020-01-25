//
//  SettingsTableViewController.swift
//  metronome
//
//  Created by Egor on 1/12/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class BeatViewController: EditableTable, EditableTableDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!

    // MARK: - Public Properties
    
    var data: [[Data?]] =
        [
            [Instrument.bass, Instrument.hi_hat],
            [Instrument.bass],
            [Instrument.bass, Instrument.snare],
            [Instrument.bass],
        ]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        delegate = self
        super.viewDidLoad()
    }
    
    func showDetail() {
        self.showDetailViewController(SelectionCollectionViewController<Instrument>(collectionViewLayout: UICollectionViewFlowLayout()), sender: self)
    }
    
}
