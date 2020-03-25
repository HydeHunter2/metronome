//
//  SettingsViewController.swift
//  metronome
//
//  Created by Egor on 1/27/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

// MARK: - Main

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fileTextField: UITextField!
    
    // MARK: - Initialization
    
    var presenter: SettingsPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fileTextField.text = GlobalSettings.NAME_OF_UNTITLED_PRESET
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    // MARK: - Public
    
    @IBAction func save(_ sender: UIButton) {
        presenter?.save()
    }
    
}

// MARK: - Extensions

extension SettingsViewController: SettingsViewProtocol {
    
    func getNameOfActivePreset() -> String {
        fileTextField.text ?? GlobalSettings.NAME_OF_UNTITLED_PRESET
    }
    
    func removeTableRow(withIndex index: Int) {
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
    
    func updateTable() {
        tableView?.reloadData()
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getNumberOfPresets() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed(SettingsCell.reuseID, owner: self, options: nil)?.first as! SettingsCell

        cell.titleLabel.text = presenter?.getNameOfRow(withIndex: indexPath.row) ?? GlobalSettings.NAME_OF_UNTITLED_PRESET
        cell.numberLabel.text = "\(presenter?.getNumberOfTicks(inRowWithIndex: indexPath.row) ?? 0)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.selectRow(withIndex: indexPath.row)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deleteRow(withIndex: indexPath.row)
        }
    }
    
}
