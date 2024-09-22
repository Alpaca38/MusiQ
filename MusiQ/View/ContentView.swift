//
//  ContentView.swift
//  MusiQ
//
//  Created by 조규연 on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var rootPresentation = RootPresentation()
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some View {
        if !networkMonitor.isConnected {
            Text("네트워크 연결이 해제되었습니다. 네트워크 상태를 확인해주세요.")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .bold))
                .transition(.move(edge: .top))
        }
        
        if rootPresentation.isActive {
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
            .environmentObject(rootPresentation)
        }
    }
}
//
//#Preview {
//    ContentView()
//}
class RootPresentation: ObservableObject {
    @Published var isActive: Bool = true
    
    func reset() {
        isActive = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isActive = true
        }
    }
}
