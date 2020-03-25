//
//  EditableTableViewController.swift
//  metronome
//
//  Created by Egor on 1/24/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Main

class EditableTable: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Initialization
    
    var presenter: EditableTablePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
    }
    
    // MARK: - Public
    
    @IBAction func addSection(_ sender: UIButton) {
        presenter?.addSection()
    }
    
    @objc private func addRow(sender: UIButton!) {
        let footer = sender.superview?.superview as? FooterView // ref
        
        presenter?.addRow(inSection: footer!.section)
    }
    
    @objc private func openCollection(_ sender: UIButton) {
        let cell = sender.superview?.superview?.superview as! UITableViewCell // ref

        presenter?.openCollection(forEditingCellWithPath: tableView.indexPath(for: cell)!) // ref
    }
    
    @objc func playSound(_ sender: UIButton) {
        let cell = sender.superview?.superview?.superview as! UITableViewCell // ref
        guard let soundName = presenter?.getNameForCell(withPath: tableView.indexPath(for: cell)!) else { return } // ref
        
        presenter?.playSound(Sound(name: soundName))
    }
    
    // MARK: - Private
    
    private func setupTable() {
        tableView.register(EditableTableCell.nib, forCellReuseIdentifier: EditableTableCell.reuseID)
        tableView.isEditing = true
        tableView.delegate = self
        tableView.dataSource = self
    }
        
}

// MARK: - Extensions

extension EditableTable: EditableTableViewProtocol {
    func removeTableSection(withIndex section: Int) {
        tableView.deleteSections([section], with: .fade)
    }
    func removeTableRow(withPath path: IndexPath) {
        tableView.deleteRows(at: [path], with: .fade)
    }
    func updateTable() {
        tableView?.reloadData()
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
        footerView.addButton.addTarget(self, action: #selector(addRow), for: .touchUpInside)
        
        return footerView
    }
    
}

extension EditableTable: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed(EditableTableCell.reuseID, owner: self, options: nil)?.first as! EditableTableCell
        
        let name = presenter?.getNameForCell(withPath: indexPath) ?? GlobalSettings.STRING_OF_NILDATA
        
        cell.indexPath = indexPath
        cell.selectButton.setTitle(name, for: .normal)
        cell.selectButton.addTarget(self, action: #selector(openCollection), for: .touchUpInside)
        cell.soundButton.setBackgroundImage(UIImage(named: name), for: .normal)
        cell.soundButton.addTarget(self, action: #selector(playSound), for: .touchUpInside)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.getNumberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getNumberOfRowInSection(withIndex: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deleteRow(withPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        presenter?.moveRow(from: fromIndexPath, to: to)
    }
    
}
