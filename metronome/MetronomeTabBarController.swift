//
//  MetronomeTabBarController.swift
//  metronome
//
//  Created by Egor on 1/15/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class MetronomeTabBarController: UITabBarController {

    // MARK: - Private Properties
    
    private let indexOfNotesTab = 2
    private let indexOfMetronomeTab = 1
    private let indexOfBeatTab = 0

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = indexOfMetronomeTab
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let metronomeTab = tabBar.items?[indexOfMetronomeTab]
        let beatTab = tabBar.items?[indexOfBeatTab]
        guard let metronomeVC = viewControllers?[indexOfMetronomeTab] as? MetronomeViewController else { return }
        guard let BeatVC = viewControllers?[indexOfBeatTab] as? BeatViewController else { return }
        guard let NoteVC = viewControllers?[indexOfNotesTab] as? BackingTrackTableViewController else { return }
        
        if item != metronomeTab {
            metronomeVC.isOn = false
        }
        
        if item != beatTab {
            var beats: Int { get { BeatVC.data.count } }
            var notes: Int { get { NoteVC.data.count } }
            
            if beats > notes {
                NoteVC.data += Array(repeating: [nil], count: (beats - notes))
            } else if notes > beats {
                NoteVC.data.removeLast(notes - beats)
            }
            
            NoteVC.tableView?.reloadData()
        }
        
        metronomeVC.beats = BeatVC.data as! [[Instrument?]]
        metronomeVC.notes = NoteVC.data as! [[Note?]]
        
    }
}
