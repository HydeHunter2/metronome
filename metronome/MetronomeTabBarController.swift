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
        let noteTab = tabBar.items?[indexOfNotesTab]
        
        guard let metronomeVC = viewControllers?[indexOfMetronomeTab] as? MetronomeViewController,
              let BeatVC = viewControllers?[indexOfBeatTab] as? BeatViewController,
              let NoteVC = viewControllers?[indexOfNotesTab] as? BackingTrackTableViewController,
              let preiousVC = selectedViewController
            else { return }
        
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
        
        if item != metronomeTab && preiousVC == metronomeVC {
            metronomeVC.isOn = false
            
            BeatVC.data = metronomeVC.beats
            NoteVC.data = metronomeVC.notes
            
            BeatVC.tableView?.reloadData()
            NoteVC.tableView?.reloadData()
            
        }
        
        if item == metronomeTab {
            metronomeVC.beats = BeatVC.data as! [[Instrument?]]
            metronomeVC.notes = NoteVC.data as! [[Note?]]
        }
        
    }
}
