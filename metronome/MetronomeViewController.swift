//
//  ViewController.swift
//  metronome
//
//  Created by Egor on 1/10/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

// MARK: - Main

class MetronomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var powerButton: UIButton!
    @IBOutlet weak var pickerBPM: UIPickerView!
    
    // MARK: - Initialization
    
    var presenter: MetronomePresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegates()
        setupUI()
    }
    
    // MARK: - Public
    
    @IBAction func powerButtonTapped(_ sender: UIButton) {
        presenter?.togglePower()
    }
    
    @IBAction func tempoButtonTapped(_ sender: UIButton) {
        UIDevice.vibrate(heavy: false)
        presenter?.tempoTap()
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GlobalSettings" {
            if let SettingsVC = segue.destination as? SettingsViewController {
                isOn = false
                //SettingsVC.presetToSave = Preset(title: Settings.STRING_OF_NILDATA, beats: beats, notes: notes, BPM: BPM)
            }
        }
    }
    @IBAction func openSettings(_ unwindSegue: UIStoryboardSegue) { //rename*
        
        guard let SettingsVC = unwindSegue.source as? SettingsViewController,
              let preset = SettingsVC.presetToUnwind
        else{ return }
        
        //beats = preset.beats
        //notes = preset.notes
        //BPM = preset.BPM
        
        //
    }
    */
    @IBAction func openSettings(_ sender: UIButton) {
        presenter?.openSettings()
    }
    
    // MARK: - Private
    
    private func setupDelegates() {
        pickerBPM.delegate = self
        pickerBPM.dataSource = self
    }
    
    private func setupUI() {
        pickerBPM.selectRow(0, inComponent: 0, animated: false)
        pickerBPM.transform = CGAffineTransform(rotationAngle: -90 * (.pi/180))
        pickerBPM.frame = CGRect(x: -100, y: 93, width: view.frame.width+200, height: 100)
    }
    
}

// MARK: - Extensions

extension MetronomeViewController: MetronomeViewProtocol {
    
    func setValueOnPicker(to bpm: Int) {
        pickerBPM.selectRow(bpm - GlobalSettings.MIN_BPM, inComponent: 0, animated: true)
    }
    
    func putPauseImageOnPowerButton() {
        powerButton.setBackgroundImage(UIImage(systemName: "pause"), for: .normal)
    }
    
    func putPlayImageOnPowerButton() {
        powerButton.setBackgroundImage(UIImage(systemName: "play"), for: .normal)
    }
    
    func disableIdleTimer() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func enableIdleTimer() {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
}

extension MetronomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (GlobalSettings.MAX_BPM - GlobalSettings.MIN_BPM + 1)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let rect = CGRect(x: 0, y: 0, width: 50, height: 50)
        let view = UIView(frame: rect)
        let label = UILabel(frame: rect)
        label.text = "\(row + GlobalSettings.MIN_BPM)"
        label.textAlignment = .center;
        label.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        
        view.addSubview(label)
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        presenter?.changeBPM(to: row + GlobalSettings.MIN_BPM)
    }
}

extension UIDevice {
    static func vibrate(heavy: Bool) {
        var style: UIImpactFeedbackGenerator.FeedbackStyle
        
        if heavy {
            style = .heavy
        } else if #available(iOS 13.0, *) {
            style = .soft
        } else {
            style = .light
        }
        
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
