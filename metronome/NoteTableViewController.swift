//
//  NoteViewController.swift
//  metronome
//
//  Created by Egor on 1/21/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

// MARK: - Main

class NoteTableViewController: EditableTable  {

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return (presenter?.getNumberOfRowInSection(withIndex: indexPath.section) ?? 0) > 1
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if (presenter?.getNumberOfRowInSection(withIndex: indexPath.section) ?? 0) > 1 {
            return UITableViewCell.EditingStyle.delete
        } else {
            return UITableViewCell.EditingStyle.none
        }
    }
    
}
