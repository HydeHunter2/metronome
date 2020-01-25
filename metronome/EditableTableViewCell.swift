//
//  InstrumentTableViewCell.swift
//  metronome
//
//  Created by Egor on 1/12/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit
import AVFoundation



final class EditableTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var buttonWithSound: UIButton!
    @IBOutlet weak var titleButton: UIButton!
    
    // MARK: - Public Properties
    
    
    var indexPath = IndexPath(row: 0, section: 0)
    var dataToDisplay: Data? {
        didSet {
            let name = dataToDisplay?.name() ?? "None"
            
            titleButton.setTitle(name, for: .normal)
            buttonWithSound.setBackgroundImage(UIImage(named: name), for: .normal)
            buttonWithSound.addTarget(self, action: #selector(playSound(_:)), for: .touchUpInside)
        }
    }
    
    // MARK: - Private Properties
    
    private var players: [AVAudioPlayer] = []
    
    // MARK: - Lifecycle
    
    
    
    // MARK: - Public Methods
    
    
    
    // MARK: - Private Methods
    
    
    
    // MARK: - IBActions

    @objc func playSound(_ sender: UIButton) {
    
        guard let data = dataToDisplay else { return }
        
        self.players.removeAll { !$0.isPlaying }
        
        let player: AVAudioPlayer
            
        let path = Bundle.main.path(forResource: data.name(), ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            
            self.players.append(player)
            player.play()
        
            
        } catch {
            print("error")
        }
    }
    
}
