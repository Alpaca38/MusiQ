//
//  WrongAnswerView.swift
//  MusiQ
//
//  Created by 조규연 on 9/18/24.
//

import SwiftUI
import RealmSwift
import MusicKit

struct WrongAnswerView: View {
    @ObservedResults(Quiz.self)
    var quizList
    
    var body: some View {
        if quizList.isEmpty {
            Text("틀린 문제가 없습니다.")
                .font(.title)
                .bold()
        } else {
            NavigationView {
                ScrollView {
                    LazyVStack {
                        let uniqueQuizList = Dictionary(grouping: quizList.filter { !$0.isCorrect }, by: \.dataID)
                                                        .compactMap { $0.value.first } // 틀린 문제 중복표시 방지
                        ForEach(uniqueQuizList, id: \.id) { item in
                            wrongAnswerCell(item)
                        }
                    }
                }
                .navigationTitle("틀린 문제 목록")
                .padding()
            }
        }
    }
    
    func wrongAnswerCell(_ item: Quiz) -> some View {
        HStack {
            AsyncImage(url: URL(string: item.artworkURL!)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure(_):
                    Color.gray
                @unknown default:
                    Color.gray
                }
            }
            .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(item.songName)
                    .bold()
                Text(item.artistName)
                    .font(.caption)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
