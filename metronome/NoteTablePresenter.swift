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
    
    required init(view: EditableTableViewProtocol, model: TableProtocol) {
        super.init(view: view, model: model)
        
        dataForCollection = Note.all
    }
    
    override func removeSection(withIndex index: Int) {}
    
}
