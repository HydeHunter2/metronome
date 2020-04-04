//
//  VibrationManager.swift
//  metronome
//
//  Created by Egor on 3/31/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Protocols

protocol VibrationManagerProtocol {
    func selectionChanged()
    func successNotification()
    func errorNotification()
    func warningNotification()
    func heavyImpact()
    func mediumImpact()
    func lightImpact()
    func softImpact()
    func rigidImpact()
}

// MARK: - Main

class VibrationManager: VibrationManagerProtocol {
    
    // MARK: - Public
    
    func selectionChanged() {
        DispatchQueue.main.async {
            UISelectionFeedbackGenerator().selectionChanged()
        }
    }
    
    func successNotification() {
        DispatchQueue.main.async {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
    
    func errorNotification() {
        DispatchQueue.main.async {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
    
    func warningNotification() {
        DispatchQueue.main.async {
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        }
    }
    
    func heavyImpact() {
        DispatchQueue.main.async {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }
    
    func mediumImpact() {
        DispatchQueue.main.async {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
    
    func lightImpact() {
        DispatchQueue.main.async {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
    
    func softImpact() {
        DispatchQueue.main.async {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        }
    }
    
    func rigidImpact() {
        DispatchQueue.main.async {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        }
    }
    
}
