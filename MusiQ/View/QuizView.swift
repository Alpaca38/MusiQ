//
//  QuizView.swift
//  MusiQ
//
//  Created by 조규연 on 9/14/24.
//

import SwiftUI

struct QuizView: View {
    let mode: Mode
    let genre: GenreSelection
    
    var body: some View {
        if mode.name == Mode.song.name {
            Text("노래 맞추기 퀴즈")
        } else {
            Text("앨범 커버 맞추기 퀴즈")
        }
    }
}
//
//#Preview {
//    QuizView()
//}
