//
//  SoundManager.swift
//  metronome
//
//  Created by Egor on 3/18/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import AVFoundation

// MARK: - Protocols

protocol SoundManagerProtocol {
  func playIntro(withTickDuration tickDuration: Double)
  func off()
  func wipe()
  func playTick(withSounds sounds: [Sound], tickDuration: Double)
  func playSound(_ sound: Sound)
}

// MARK: - Main

struct Sound {
  var name: String
}

class SoundManager: SoundManagerProtocol {

  // MARK: - Public

  func wipe() {
    players = []
  }

  func off() {
    for player in players {
      player.setVolume(0.0, fadeDuration: 0.5)
    }
  }

  func playSound(_ sound: Sound) {
    DispatchQueue.main.async {
      self.syncPlaySound(sound)
    }
  }

  func playIntro(withTickDuration tickDuration: Double) {
    DispatchQueue.main.async {
      self.syncPlayIntro(withTickDuration: tickDuration)
    }
  }

  func playTick(withSounds sounds: [Sound], tickDuration: Double) {
    DispatchQueue.main.async {
      self.syncPlayTick(withSounds: sounds, tickDuration: tickDuration)
    }
  }

  // MARK: - Private

  private var players = [AVAudioPlayer]()

  private func removeUnusedPlayers() {
    players.removeAll { !$0.isPlaying }
  }

  private func syncPlaySound(_ sound: Sound) {
    removeUnusedPlayers()

    guard let player = AVAudioPlayer.createPlayerFromFile(withName: sound.name) else {
      return
    }

    players.append(player)
    player.play()
  }

  private func syncPlayIntro(withTickDuration tickDuration: Double) {
    for _ in 0...3 {
      guard let player = AVAudioPlayer.createPlayerFromFile(withName: Instrument.hi_hat.name()) else {
        continue
      }
      players.append(player)
    }

    let time = players[0].deviceCurrentTime
    for i in 0...3 {
      players[i].setVolume(0.7 + Float(i)/10.0, fadeDuration: 0)
      players[i].play(atTime: time + tickDuration * Double(i * 2))
    }
  }

  private func syncPlayTick(withSounds sounds: [Sound], tickDuration: Double) {
    removeUnusedPlayers()

    for sound in sounds {
      guard let player = AVAudioPlayer.createPlayerFromFile(withName: sound.name) else {
        continue
      }
      players.append(player)
    }

    if players.isEmpty {
      return
    }

    let time = players[0].deviceCurrentTime + tickDuration * 7
    for player in players {
      player.play(atTime: time)
    }
  }

}

// MARK: - Extensions

extension AVAudioPlayer {
  static func createPlayerFromFile(withName name: String) -> AVAudioPlayer? {
    if name == GlobalSettings.STRING_OF_NILDATA {
      return nil
    }

    let path = Bundle.main.path(forResource: name, ofType: "wav")!
    let url = URL(fileURLWithPath: path)

    do {
      return try AVAudioPlayer(contentsOf: url)
    } catch {
      return nil
    }
  }
}
