//
//  ViewController.swift
//  metronome
//
//  Created by Egor on 1/10/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit
import AVFoundation

class MetronomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var stepperBPM: UIStepper!
    @IBOutlet weak var fieldBPM: UITextField!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - Public Properties
    
    var BPM: Double {
        get {
            timer.bpm / (isDoubleTime ? 2 : 1)
        }
        set {
            timer.bpm = newValue * (isDoubleTime ? 2 : 1)
        }
    }
    
    var isOn = false {
        didSet {
            if isOn {
                tickCounter = -1
                startButton.setBackgroundImage(UIImage(systemName: "pause"), for: .normal)
                timer.start()
                
                players = []
                
                for _ in 0...3 {
                    guard let player = AVAudioPlayer.createPlayerFromFile(withName: "Hi-hat") else { continue }
                    players.append(player)
                }
                
                let time = players[0].deviceCurrentTime
                for i in 0...3 {
                    players[i].play(atTime: time + timer.tickDuration * Double(i * 2))
                }
                
            } else {
                startButton.setBackgroundImage(UIImage(systemName: "play"), for: .normal)
                timer.stop()
                players = []
                tickCounter = 0
                counter.text = "1"
            }
        }
    }
    
    var beats: [[Instrument?]] =
    [
        [.bass, .hi_hat],
        [.bass],
        [.bass, .snare],
        [.bass],
    ]
    
    var notes: [[Note?]] =
    [
        [nil],
        [nil],
        [nil],
        [nil],
    ]
    
    // MARK: - Private Properties
    
    private var players: [AVAudioPlayer] = []
    private var timer = BPMTimer(bpm: 120.0)
    private var isDoubleTime = false
    private var tickCounter = -1
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegates()
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupDelegates() {
        timer.delegate = self
        fieldBPM.delegate = self
    }
    
    private func setupUI() {
        fieldBPM.text = "\(Int(timer.bpm))"
        stepperBPM.value = timer.bpm
    }
    
    // MARK: - IBActions
    
    @IBAction func doubleButtonPressed(_ sender: UIButton) {
        
        if isDoubleTime {
            isDoubleTime = false
            BPM = timer.bpm / 2
        } else {
            BPM = timer.bpm * 2
            isDoubleTime = true
        }
        
    }
    
    @IBAction func stepperChangedBPM(_ sender: UIStepper) {
        BPM = sender.value
        
        fieldBPM.text = "\(Int(BPM))"
    }
    
    @IBAction func fieldChangedBPM(_ sender: UITextField) {
        
        var bpm = Int(sender.text!) ?? Int(BPM)
        
        if bpm < 60 {
            bpm = 60
            fieldBPM.text = "60"
        } else if bpm > 240 {
            bpm = 240
            fieldBPM.text = "240"
        }
        
        BPM = Double(bpm)
        
        stepperBPM.value = timer.bpm
    }
    
    @IBAction func rhythmButtonPressed(_ sender: UIButton) {
        // some
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        isOn = !isOn
    }
    
}



// MARK: - BPMTimerDelegate
extension MetronomeViewController: BPMTimerDelegate {
    
    func bpmTimerTicked() {
        
        players.removeAll { !$0.isPlaying }
            
        tickCounter += 1
            
        if tickCounter >= beats.count {
            tickCounter = 0
        }
        
        //counter.text = "\(self.tickCounter + 1)"
        
        let data: [Data?] = beats[tickCounter] + notes[tickCounter]
        
        for i in 0..<data.count {
            
            guard let name = data[i]?.name(),
                  let player = AVAudioPlayer.createPlayerFromFile(withName: name)
            else {
                continue
            }
            
            players.append(player)
        }
        
        if players.isEmpty { return }
        
        let time = players[0].deviceCurrentTime + timer.tickDuration * 7

        for player in players {
            player.play(atTime: time)
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension MetronomeViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

extension AVAudioPlayer {
    
    static func createPlayerFromFile(withName name: String) -> AVAudioPlayer? {

        let path = Bundle.main.path(forResource: name, ofType: "wav")!
        let url = URL(fileURLWithPath: path)
            
        do {
            return try AVAudioPlayer(contentsOf: url)
        } catch {
            return nil
        }
        
    }
    
}
