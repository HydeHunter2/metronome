//
//  InstrumentTablePresenter.swift
//  metronome
//
//  Created by Egor on 3/19/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

// MARK: - Main

class InstrumentTablePresenter: EditableTablePresenter {

  // MARK: - Initialization

  required init(view: EditableTableViewProtocol, model: TableProtocol) {
    super.init(view: view, model: model)

    dataForCollection = Instrument.all
  }

  // MARK: - Extensions

  override func openCollection(forEditingCellWithPath path: IndexPath) {
    dataForCollection = Instrument.all.filter { data in
      let instrument = data as? Instrument
      let instrumentsInSection = (table.data[path.section] as! [Instrument?])

      return !instrumentsInSection.contains(instrument) || (instrument == .none)
    }

    super.openCollection(forEditingCellWithPath: path)
  }

  override func addRow(inSection section: Int) {
    if table.data[section].count < Instrument.all.count - 1 {
      super.addRow(inSection: section)
    }
  }

  override func moveRow(from: IndexPath, to: IndexPath) {
    let instrumetToMove = table.data[from.section][from.item] as! Instrument?
    let section = table.data[to.section] as! [Instrument?]

    let sectionsAreSame = (from.section == to.section)
    let sectionHaveItem = section.contains(instrumetToMove)
    let countIsLessThanMax = (section.count < Instrument.all.count - 1)
    let itemIsNone = (instrumetToMove == .none)

    if sectionsAreSame ||
       (countIsLessThanMax && itemIsNone) ||
       (countIsLessThanMax && !sectionHaveItem) {
      super.moveRow(from: from, to: to)
      return
    }

    updateTable()
  }
}
