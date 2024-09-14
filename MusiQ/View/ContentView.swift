//
//  ContentView.swift
//  MusiQ
//
//  Created by 조규연 on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            QuizModeView()
                .tabItem {
                    Image(systemName: "house")
                }
        }
        .tint(.black)
    }
}
//
//#Preview {
//    ContentView()
//}
