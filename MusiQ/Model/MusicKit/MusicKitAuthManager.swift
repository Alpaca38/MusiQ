//
//  MusicKitAuthManager.swift
//  MusiQ
//
//  Created by 조규연 on 9/13/24.
//

import Foundation
import MusicKit

final class MusicKitAuthManager: ObservableObject {
    static let shared = MusicKitAuthManager()
    private init() {}
    
    @Published var isAuthorizedForMusicKit = false
    @Published var musicKitError: MusicKitError?
    
    func requestMusicAuthorization() async {
        let status = await MusicAuthorization.request()
        
        switch status {
        case .authorized:
            isAuthorizedForMusicKit = true
        case .restricted:
            musicKitError = .restricted
        case .notDetermined:
            musicKitError = .notDetermined
        case .denied:
            musicKitError = .denied
        @unknown default:
            musicKitError = .notDetermined
        }
    }
    
    enum MusicKitError: Error {
        case restricted, notDetermined, denied
    }
}
