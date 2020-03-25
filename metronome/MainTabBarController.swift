//
//  MainTabBarController.swift
//  metronome
//
//  Created by Egor on 1/15/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

// MARK: - Main

class MainTabBarController: UITabBarController {
    
    // MARK: - Initialization
    
    var presenter: MainTabBarPresenterProtocol?
    
    var metronomeVC: MetronomeViewController?
    var settingsVC: SettingsViewController?
    
    var instrumentVC: InstrumentTableViewController?
    var noteVC: NoteTableViewController?
    var collectionVC: CollectionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    // MARK: - Public
    
    func setupUI() {
        guard let metronomeVC = metronomeVC,
              let instrumentVC = instrumentVC,
              let noteVC = noteVC
              else { fatalError() }
        
        instrumentVC.tabBarItem = UITabBarItem(title: "Drum", image: UIImage(systemName: "paperplane.fill"), tag: 0)
        metronomeVC.tabBarItem = UITabBarItem(title: "Metronome", image: UIImage(systemName: "paperplane.fill"), tag: 1)
        noteVC.tabBarItem = UITabBarItem(title: "Melody", image: UIImage(systemName: "paperplane.fill"), tag: 2)
        
        let tabBarList = [instrumentVC, metronomeVC, noteVC]
        viewControllers = tabBarList
        selectedIndex = 1
    }
    
}

// MARK: - Extensions

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let toVC = viewController
        guard let fromVC = selectedViewController,
                  toVC != fromVC
                  else { return false }
        
        switch fromVC {
            case instrumentVC, noteVC:
                presenter?.passDataToMetronomePresenter()
            case metronomeVC:
                presenter?.syncData()
            default: return false
        }
        
        return true
    }
    
}

extension MainTabBarController: MainTabBarControllerProtocol {
    
    func showSettings() {
        guard let settingsVC = settingsVC else { return }
        showDetailViewController(settingsVC, sender: self)
    }
    
    func showCollection() {
        guard let collectionVC = collectionVC else { return }
        showDetailViewController(collectionVC, sender: self)
    }
    
}
