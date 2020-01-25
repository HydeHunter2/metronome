//
//  BackingTrackViewController.swift
//  metronome
//
//  Created by Egor on 1/21/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class BackingTrackTableViewController: EditableTable, EditableTableDelegate  {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Public Properties
    
    var data: [[Data?]] =
        [
            [nil],
            [nil],
            [nil],
            [nil],
        ]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        delegate = self
        super.viewDidLoad()
    }
    
    override func sectionIsEmpty(withIndex section: Int) {
        data[section] = [nil]
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return data[indexPath.section].count != 1
    }
    
    func showDetail() {
        self.showDetailViewController(SelectionCollectionViewController<Note>(collectionViewLayout: UICollectionViewFlowLayout()), sender: self)
    }
    
}
