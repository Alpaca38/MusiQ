//
//  ContentView.swift
//  MusiQ
//
//  Created by 조규연 on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var rootPresentation = RootPresentation()
    
    var body: some View {
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
                }
                .tint(.black)
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
