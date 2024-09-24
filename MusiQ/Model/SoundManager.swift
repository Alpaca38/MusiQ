//
//  SoundManager.swift
//  MusiQ
//
//  Created by 조규연 on 9/24/24.
//

import Foundation
import AVFoundation

final class SoundManager {
    private init() { }
    static let shared = SoundManager()
    
    var audioPlayer: AVPlayer?
    
    func playSong(song: URL?) {
        guard let url = song else { return }
        self.audioPlayer = AVPlayer(url: url)
        audioPlayer?.play()
    }
    
    func pauseSong() {
        audioPlayer?.pause()
    }
}
