//
//  CollectionPresenter.swift
//  metronome
//
//  Created by Egor on 3/18/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

// MARK: - Protocols

protocol CollectionViewProtocol: class {
    func updateCollection()
}

protocol CollectionPresenterProtocol {
    init(view: CollectionViewProtocol, model: Collection, vibrationManager: VibrationManagerProtocol)
    func getNumberOfCells() -> Int
    func selectCell(withIndex index: Int)
    func getImageName(forIndex index: Int) -> String
}

protocol ParentOfCollectionPresenterProtocol {
    func unwindFromCollection(data: Data?)
}

protocol ChildCollectionPresenterProtocol {
    var parentPresenter: ParentOfCollectionPresenterProtocol? { get set }
    var collection: Collection { get set }
    func updateCollection()
}

// MARK: - Main

class CollectionPresenter: CollectionPresenterProtocol, ChildCollectionPresenterProtocol {

    // MARK: - Initialization
    
    var parentPresenter: ParentOfCollectionPresenterProtocol?
    
    unowned let view: CollectionViewProtocol
    var collection: Collection
    var vibrationManager: VibrationManagerProtocol
    
    required init(view: CollectionViewProtocol, model: Collection, vibrationManager: VibrationManagerProtocol) {
        self.view = view
        self.collection = model
        self.vibrationManager = vibrationManager
    }
    
    // MARK: - Public Properties
    
    func getNumberOfCells() -> Int {
        collection.data.count
    }
    
    func getImageName(forIndex index: Int) -> String {
        collection.data[index]?.name() ?? GlobalSettings.STRING_OF_NILDATA
    }
    
    func selectCell(withIndex index: Int) {
        parentPresenter?.unwindFromCollection(data: collection.data[index])
        vibrationManager.selectionChanged()
    }
    
    func updateCollection() {
        view.updateCollection()
    }
    
}
