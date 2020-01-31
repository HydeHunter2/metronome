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
            
            if newValue > 240 {
                timer.bpm = 240 * (isDoubleTime ? 2 : 1)
            } else if newValue < 60 {
                timer.bpm = 60 * (isDoubleTime ? 2 : 1)
            } else {
                timer.bpm = newValue * (isDoubleTime ? 2 : 1)
            }
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
    private var tapTempo = TapTempo()
    private var isDoubleTime = false
    private var tickCounter = -1
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegates()
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Settings" {
            if let SettingsVC = segue.destination as? SettingsViewController {
                isOn = false
                SettingsVC.presetToSave = Preset(title: "None", beats: beats, notes: notes, BPM: BPM)
            }
        }
    }
    
    @IBAction func getSettings(_ unwindSegue: UIStoryboardSegue) {
        
        guard let SettingsVC = unwindSegue.source as? SettingsViewController,
              let preset = SettingsVC.presetToUnwind
        else{ return }
        
        beats = preset.beats
        notes = preset.notes
        BPM = preset.BPM
        
        pickerBPM.selectRow(Int(BPM - 60), inComponent: 0, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func setupDelegates() {
        timer.delegate = self
        tapTempo.delegate = self
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
        UIDevice.vibrate(heavy: false)
        tapTempo.tap()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        isOn = !isOn
    }
    
}

struct Tap {
    var time: Double
}

class TapTempo {
    
    private let minTaps = 3
    private let maxTaps = 6
    private let discardTimeout = 1.5
    private var taps = [Tap]()
    
    var delegate: TapTempoDelegate?
    
    func tap() {
        taps.append(Tap(time: CACurrentMediaTime()))
        
        if taps.count < 2 { return }
        
        if (taps[taps.count-1].time - taps[taps.count-2].time >= discardTimeout) {
            taps = [taps[taps.count-1]]
        }
        
        if taps.count < minTaps { return }
        
        if taps.count > maxTaps { taps.remove(at: 0) }
        
        var timeIntervals = [Double]()
        
        for i in 1..<taps.count {
            timeIntervals.append(taps[i].time - taps[i - 1].time)
        }
        
        let bpm = 60.0 / (timeIntervals.reduce(0, +) / Double(timeIntervals.count))
        
        delegate?.BPMChanged(to: bpm)
    }
}

protocol TapTempoDelegate {
    func BPMChanged(to bpm: Double)
}

// MARK: - TapTempoDelegate

extension MetronomeViewController: TapTempoDelegate {
    
    func BPMChanged(to bpm: Double) {
        isOn = false
        BPM = bpm
        
        pickerBPM.selectRow(Int(BPM - 60), inComponent: 0, animated: true)
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

extension UIDevice {
    static func vibrate(heavy: Bool) {
        if heavy {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        } else {
            if #available(iOS 13.0, *) {
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.impactOccurred()
            } else {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }
        }
    }
}
