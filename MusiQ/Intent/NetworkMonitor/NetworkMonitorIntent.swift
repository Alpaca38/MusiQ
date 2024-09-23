//
//  NetworkMonitorIntent.swift
//  MusiQ
//
//  Created by 조규연 on 9/23/24.
//

import Foundation

final class NetworkMonitorIntent {
    private weak var model: NetworkActionsProtocol?
    
    init(model: NetworkActionsProtocol) {
        self.model = model
    }
}

extension NetworkMonitorIntent: NetworkIntentProtocol {
    func checkNetwork() {
        model?.checkConnection()
    }
}

protocol NetworkIntentProtocol {
    func checkNetwork()
}
