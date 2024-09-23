//
//  ContentView.swift
//  MusiQ
//
//  Created by 조규연 on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var rootPresentationContainer: MVIContainer<RootPresentationIntentProtocol, RootPresentationStateProtocol>
    private var rootPresentationState: RootPresentationStateProtocol { rootPresentationContainer.model }
    private var rootPresentationIntent: RootPresentationIntentProtocol { rootPresentationContainer.intent }
    
    @StateObject var networkMonitorContainer: MVIContainer<NetworkIntentProtocol, NetworkStateProtocol>
    private var networkState: NetworkStateProtocol { networkMonitorContainer.model }
    private var networkIntent: NetworkIntentProtocol { networkMonitorContainer.intent }
    
    var body: some View {
        VStack {
            if !networkState.isConnected {
                Text("네트워크 연결이 해제되었습니다. 네트워크 상태를 확인해주세요.")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .bold))
                    .transition(.move(edge: .top))
            }
            
            if rootPresentationState.isActive {
                NavigationStack {
                    TabView {
                        QuizModeView()
                            .tabItem {
                                Image(systemName: "house")
                                Text("퀴즈")
                            }
                        
                        WrongAnswerView()
                            .tabItem {
                                Image(systemName: "doc.text.magnifyingglass")
                                Text("틀린 문제")
                            }
                        
                        MyChartView()
                            .tabItem {
                                Image(systemName: "chart.pie")
                                Text("통계")
                            }
                    }
                    .tint(.teal)
                }
            }
        }
        .onAppear {
            networkIntent.checkNetwork()
        }
        .environmentObject(rootPresentationContainer)
    }
}

extension ContentView {
    static func build() -> some View {
        let rootModel = RootPresentationModel()
        let rootIntent = RootPresentationIntent(model: rootModel)
        let rootContatiner = MVIContainer(intent: rootIntent as RootPresentationIntentProtocol,
                                          model: rootModel as RootPresentationStateProtocol,
                                          modelChangePublisher: rootModel.objectWillChange)
        
        let networkModel = NetworkMonitorModel()
        let networkIntent = NetworkMonitorIntent(model: networkModel)
        let networkContainer = MVIContainer(intent: networkIntent as NetworkIntentProtocol,
                                            model: networkModel as NetworkStateProtocol,
                                            modelChangePublisher: networkModel.objectWillChange)
        return ContentView(rootPresentationContainer: rootContatiner, networkMonitorContainer: networkContainer)
    }
}
//
//#Preview {
//    ContentView()
//}
