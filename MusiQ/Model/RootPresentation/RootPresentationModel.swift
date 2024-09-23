//
//  RootPresentationModel.swift
//  MusiQ
//
//  Created by 조규연 on 9/23/24.
//

import Foundation

final class RootPresentationModel: ObservableObject, RootPresentationStateProtocol {
    @Published var isActive: Bool = true
    
}

extension RootPresentationModel: RootPresentationActionsProtocol {
    func reset() {
        isActive = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isActive = true
        }
    }
}

protocol RootPresentationStateProtocol {
    var isActive: Bool { get }
}

protocol RootPresentationActionsProtocol: AnyObject {
    func reset()
}
