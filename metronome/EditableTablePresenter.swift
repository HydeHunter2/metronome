//
//  EditableTablePresenter.swift
//  metronome
//
//  Created by Egor on 3/18/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

// MARK: - Protocols

protocol EditableTableViewProtocol: class {
  func updateTable()
  func removeTableSection(withIndex section: Int)
  func removeTableRow(withPath path: IndexPath)
}

protocol EditableTablePresenterProtocol {
  init(view: EditableTableViewProtocol, model: TableProtocol)
  func addRow(inSection section: Int)
  func addSection()
  func getNumberOfSections() -> Int
  func getNumberOfRowInSection(withIndex index: Int) -> Int
  func deleteRow(withPath path: IndexPath)
  func removeSection(withIndex index: Int)
  func moveRow(from: IndexPath, to: IndexPath)
  func getNameForCell(withPath path: IndexPath) -> String?
  func playSound(_ sound: Sound)
  func openCollection(forEditingCellWithPath path: IndexPath)
}

protocol ParentOfEditableTablePresenterProtocol {
  var soundManager: SoundManagerProtocol { get set }
  var vibrationManager: VibrationManagerProtocol { get set }
  var unwindFunctionFromCollection: ((_ data: Data?) -> Void)? { get set }
  func moveToCollection(withData data: [Data?])
}

protocol ChildEditableTablePresenterProtocol {
  var parentPresenter: ParentOfEditableTablePresenterProtocol? { get set }
  var table: TableProtocol { get set }
  func updateTable()
}

// MARK: - Main

class EditableTablePresenter: EditableTablePresenterProtocol, ChildEditableTablePresenterProtocol {

  // MARK: - Initialization

  var parentPresenter: ParentOfEditableTablePresenterProtocol?

  unowned let view: EditableTableViewProtocol
  var table: TableProtocol

  var dataForCollection: [Data?] = []

  required init(view: EditableTableViewProtocol, model: TableProtocol) {
    self.view = view
    self.table = model
  }

  // MARK: - Public

  func getNumberOfSections() -> Int {
    table.data.count
  }

  func getNameForCell(withPath path: IndexPath) -> String? {
    table.data[path.section][path.row]?.name()
  }

  func getNumberOfRowInSection(withIndex index: Int) -> Int {
    table.data[index].count
  }

  func addSection() {
    table.data += [[nil]]
    updateTable()
  }

  func removeSection(withIndex index: Int) {
    table.data.remove(at: index)
    view.removeTableSection(withIndex: index)
    updateTable()
  }

  func addRow(inSection section: Int) {
    table.data[section].append(nil)
    updateTable()
  }

  func deleteRow(withPath path: IndexPath) {
    table.data[path.section].remove(at: path.row)
    view.removeTableRow(withPath: path)
    updateTable()
    checkSectionIsEmpty(withIndex: path.section)
  }

  func moveRow(from: IndexPath, to: IndexPath) {
    let deletedRow = table.data[from.section][from.row]
    table.data[from.section].remove(at: from.row)
    table.data[to.section].insert(deletedRow, at: to.row)
    checkSectionIsEmpty(withIndex: from.section)
    updateTable()
  }

  func openCollection(forEditingCellWithPath path: IndexPath) {
    parentPresenter?.unwindFunctionFromCollection = { data in
      self.table.data[path.section][path.row] = data
      self.view.updateTable()
    }
    parentPresenter?.moveToCollection(withData: dataForCollection)
  }

  func playSound(_ sound: Sound) {
    parentPresenter?.soundManager.playSound(sound)
  }

  func updateTable() {
    view.updateTable()
    parentPresenter?.vibrationManager.selectionChanged()
  }

  // MARK: - Private

  private func checkSectionIsEmpty(withIndex section: Int) {
    if table.data[section].isEmpty {
      removeSection(withIndex: section)
    }
  }
}
