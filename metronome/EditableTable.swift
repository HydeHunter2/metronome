//
//  EditableTable.swift
//  metronome
//
//  Created by Egor on 1/24/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit

protocol EditableTableDelegate: class {
    
    var tableView: UITableView! { get set }
    var addButton: UIButton! { get set }
    var data: [[Data?]] { get set }
    
    func showDetail()
    
}

extension EditableTableDelegate {
    var addButton: UIButton! { get { return UIButton() } set {} }
}

class EditableTable: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate?.addButton.addTarget(self, action: #selector(addSection), for: .touchUpInside)
        
        delegate?.tableView.isEditing = true
        delegate?.tableView.delegate = self
        delegate?.tableView.dataSource = self
    }
    
    weak var delegate: EditableTableDelegate?
    
    private var data: [[Data?]] {
        get {
            guard let unwrappedDataSource = delegate else { return [] }
            
            return unwrappedDataSource.data
        }
        
        set {
            delegate?.data = newValue
        }
    }
    
    var indexPathToEditingCell = IndexPath(row: 0, section: 0)
    
    private let reuseIdentifier = "InstrumentTableCell"
 
    @objc private func addRow(sender: UIButton!) {
        
        let footer = sender.superview?.superview as? FooterView
        
        data[footer!.section].append(nil)
        delegate?.tableView.reloadData()
        
    }
    
    @objc private func openSelectionView(_ sender: UIButton) {
        let cell = sender.superview?.superview?.superview as! UITableViewCell
        indexPathToEditingCell = (delegate?.tableView.indexPath(for: cell))!
        
        delegate?.showDetail()
    }
    
    @objc private func addSection(_ sender: UIButton) {
        data += [[nil]]
        delegate?.tableView.reloadData()
    }
    
    func sectionIsEmpty(withIndex section: Int) {
        data.remove(at: section)
        delegate?.tableView.deleteSections([section], with: .fade)
    }
    
}

extension EditableTable: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as! HeaderView
        
        headerView.title.text = "\(section + 1)"
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 33
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = Bundle.main.loadNibNamed("FooterView", owner: self, options: nil)?.first as! FooterView
        
        footerView.section = section
        footerView.addInstrumentButton.addTarget(self, action: #selector(addRow), for: .touchUpInside)
        
        return footerView
    }
    
}

extension EditableTable: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("EditableTableViewCell", owner: self, options: nil)?.first as! EditableTableViewCell
        
        cell.dataToDisplay = data[indexPath.section][indexPath.row]
        cell.indexPath = indexPath
        
        cell.titleButton.addTarget(self, action: #selector(openSelectionView), for: .touchUpInside)

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            data[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if data[indexPath.section].isEmpty {
                sectionIsEmpty(withIndex: indexPath.section)
            }
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        data[to.section].insert(data[fromIndexPath.section].remove(at: fromIndexPath.row), at: to.row)
        
        if data[fromIndexPath.section].isEmpty {
            sectionIsEmpty(withIndex: fromIndexPath.section)
        }
        
        tableView.reloadData()
    }
    
}
