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
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    func successNotification() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    func errorNotification() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
    func warningNotification() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
    
    func heavyImpact() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
    
    func mediumImpact() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    func lightImpact() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    func softImpact() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
    
    func rigidImpact() {
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
    }
    
}
