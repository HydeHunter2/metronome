//
//  SettingsViewController.swift
//  metronome
//
//  Created by Egor on 1/27/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var presets = [Preset]()
    var presetToUnwind: Preset?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presets.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presetToUnwind = presets[indexPath.row]
        self.performSegue(withIdentifier: "GetSettings", sender: self)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            presets.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: presets), forKey: "presets")
            userDefaults.synchronize()
        }
        tableView.reloadData()
    }
    
    var presetToSave: Preset?
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "loadCell", for: indexPath) as UITableViewCell

        cell.textLabel?.text = presets[indexPath.row].title
        cell.detailTextLabel?.text = "\(presets[indexPath.row].beats.count)"

        return cell
    }
    
    @IBOutlet weak var fileTextField: UITextField!
    
    @IBAction func save(_ sender: UIButton) {
        
        let title = fileTextField.text
        // do some checks
        
        if presets.map({ $0.title }).contains(title) {
            //do some warning
            return
        }
        
        presetToSave?.title = title!
        presets.append(presetToSave!)
        
        userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: presets), forKey: "presets")
        userDefaults.synchronize()
        
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fileTextField.text = "Untitled"
        tableView.delegate = self
        tableView.dataSource = self
        
        guard let decoded = userDefaults.data(forKey: "presets"),
              let p = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [Preset]
        else { return }
        presets = p
        tableView.reloadData()
    }
    
}

class Preset: NSObject, NSCoding  {
    func encode(with coder: NSCoder) {
        
        var beatsString = ""
        
        for (indexTick, tick) in beats.enumerated() {
            
            for (indexBeat, beat) in tick.enumerated() {
                beatsString += beat?.name() ?? "None"
                
                if indexBeat != tick.count - 1 {
                    beatsString += ","
                }
            }
            
            if indexTick != beats.count - 1 {
                beatsString += "|"
            }
        }
        
        var notesString = ""
        
        for (indexTick, tick) in notes.enumerated() {
            
            for (indexNote, note) in tick.enumerated() {
                notesString += note?.name() ?? "None"
                
                if indexNote != tick.count - 1 {
                    notesString += ","
                }
            }
            
            if indexTick != notes.count - 1 {
                notesString += "|"
            }
        }
        
        coder.encode(title, forKey: "title")
        coder.encode(beatsString, forKey: "beats")
        coder.encode(notesString, forKey: "notes")
        coder.encode(BPM, forKey: "BPM")
    }
    
    required convenience init?(coder: NSCoder) {
        let title = coder.decodeObject(forKey: "title") as! String
        let BPM = coder.decodeDouble(forKey: "BPM")
        let beatsString = coder.decodeObject(forKey: "beats") as! String
        let notesString = coder.decodeObject(forKey: "notes") as! String
        
        var beatDict: [String: Instrument?] = ["None": nil]
        for beat in Instrument.all {
            if beat != nil {
                beatDict[beat!.name()] = beat as? Instrument
            }
        }
        
        var beats: [[Instrument?]] = []
        for tick in beatsString.split(separator: "|") {
            beats.append([])
            for beat in tick.split(separator: ",") {
                beats[beats.count - 1].append(beatDict[String(beat)] as? Instrument)
            }
        }
        
        var noteDict: [String: Note?] = ["None": nil]
        for note in Note.all {
            if note != nil {
                noteDict[note!.name()] = note as? Note
            }
        }
        
        var notes: [[Note?]] = []
        for tick in notesString.split(separator: "|") {
            notes.append([])
            for note in tick.split(separator: ",") {
                notes[notes.count - 1].append(noteDict[String(note)] as? Note)
            }
        }
        
        self.init(title: title, beats: beats, notes: notes, BPM: BPM)
    }
    
    var title: String
    
    var beats: [[Instrument?]]
    var notes: [[Note?]]
    
    var BPM: Double
    
    init(title: String, beats: [[Instrument?]], notes: [[Note?]], BPM: Double) {
        self.title = title
        self.beats = beats
        self.notes = notes
        self.BPM = BPM
    }
}
