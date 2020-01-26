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
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pickerBPM: UIPickerView!
    
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
                UIApplication.shared.isIdleTimerDisabled = true
                
                players = []
                tickCounter = -1
                timer.start()
                
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
                UIApplication.shared.isIdleTimerDisabled = false
                
                timer.stop()
                tickCounter = 0
                players = []
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
        pickerBPM.delegate = self
        pickerBPM.dataSource = self
    }
    
    private func setupUI() {
        pickerBPM.selectRow(120-60, inComponent: 0, animated: false)
        pickerBPM.transform = CGAffineTransform(rotationAngle: -90 * (.pi/180))
        pickerBPM.frame = CGRect(x: -100, y: 93, width: view.frame.width+200, height: 100)
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
    
    @IBAction func rhythmButtonPressed(_ sender: UIButton) {
        // some
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        isOn = !isOn
    }
    
}

extension MetronomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (240-60+1)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let r = CGRect(x: 0, y: 0, width: 50, height: 50)
        let v = UIView(frame: r)
        let l = UILabel(frame: r)
        l.text = "\(row + 60)"
        l.textAlignment = .center;
        l.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        
        v.addSubview(l)
        
        return v
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        isOn = false
        BPM = Double(row + 60)
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
