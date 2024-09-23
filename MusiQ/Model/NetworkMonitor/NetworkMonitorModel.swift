//
//  NetworkMonitor.swift
//  MusiQ
//
//  Created by 조규연 on 9/22/24.
//

import Foundation
import Network

final class NetworkMonitorModel: ObservableObject, NetworkStateProtocol {
    @Published var isConnected: Bool = true
    private let pathMonitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitorQueue")    
}

extension NetworkMonitorModel: NetworkActionsProtocol {
    func checkConnection() {
        pathMonitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isConnected = (path.status == .satisfied)
            }
        }
        pathMonitor.start(queue: monitorQueue)
    }
}

protocol NetworkStateProtocol {
    var isConnected: Bool { get }
}

protocol NetworkActionsProtocol: AnyObject {
    func checkConnection()
}
