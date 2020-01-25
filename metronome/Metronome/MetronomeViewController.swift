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
                startButton.setBackgroundImage(UIImage(systemName: "pause"), for: .normal)
                timer.start()
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
    private var tickCounter = 0
    
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
        
        //counter.text = "\(Int(((self.tickCounter + 7)%8)/2) + 1)" // ???

        for i in 0..<beats[tickCounter].count {
            if beats[tickCounter][i] == nil {
                continue
            }
            
            let player: AVAudioPlayer
                
            let path = Bundle.main.path(forResource: beats[tickCounter][i]?.name(), ofType: "wav")!
            let url = URL(fileURLWithPath: path)
                
            do {
                player = try AVAudioPlayer(contentsOf: url)
                players.append(player)
            } catch {
                print("error")
            }
        }
        
        for i in 0..<notes[tickCounter].count {
            if notes[tickCounter][i] == nil {
                continue
            }
            
            let player: AVAudioPlayer
                
            let path = Bundle.main.path(forResource: notes[tickCounter][i]?.name(), ofType: "wav")!
            let url = URL(fileURLWithPath: path)
                
            do {
                player = try AVAudioPlayer(contentsOf: url)
                players.append(player)
            } catch {
                print("error")
            }
        }
        
        if players.isEmpty { return }
        
        let time = players[0].deviceCurrentTime + timer.timeToNextTick// * 4

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
