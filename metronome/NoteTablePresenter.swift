//
//  NoteTablePresenter.swift
//  metronome
//
//  Created by Egor on 3/19/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

// MARK: - Main

class NoteTablePresenter: EditableTablePresenter {

  // MARK: - Extensions

  required init(view: EditableTableViewProtocol, model: TableProtocol) {
    super.init(view: view, model: model)

    dataForCollection = Note.all
  }

  override func removeSection(withIndex index: Int) {}

  override func openCollection(forEditingCellWithPath path: IndexPath) {
    dataForCollection = Note.all.filter { data in
      let note = data as? Note
      let notesInSection = (table.data[path.section] as! [Note?])

      return !notesInSection.contains(note) || (note == .none)
    }

    super.openCollection(forEditingCellWithPath: path)
  }

  override func addRow(inSection section: Int) {
    if table.data[section].count < Note.all.count - 1 {
      super.addRow(inSection: section)
    }
  }

  override func moveRow(from: IndexPath, to: IndexPath) {
    let noteToMove = table.data[from.section][from.item] as! Note?
    let section = table.data[to.section] as! [Note?]

    let sectionsAreSame = (from.section == to.section)
    let sectionHaveItem = section.contains(noteToMove)
    let countIsLessThanMax = (section.count < Note.all.count - 1)
    let itemIsNone = (noteToMove == .none)

    if sectionsAreSame ||
       (countIsLessThanMax && itemIsNone) ||
       (countIsLessThanMax && !sectionHaveItem) {
      super.moveRow(from: from, to: to)
      return
    }

    updateTable()
  }

}
