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
    
    @State private var searchText = ""
    
    var filteredQuizList: LazyFilterSequence<Results<Quiz>> {
        let filteredList = quizList.filter { !$0.isCorrect && (searchText.isEmpty || $0.songName.localizedCaseInsensitiveContains(searchText) || $0.artistName.localizedCaseInsensitiveContains(searchText)) }
        return filteredList
    }
    
    var body: some View {
        NavigationView {
            contentView()
                .applyBackground()
        }
    }
    
    @ViewBuilder
    func contentView() -> some View {
        if quizList.isEmpty {
            Text("틀린 문제가 없습니다.")
                .font(.title)
                .bold()
        } else {
            wrongAnswerList()
        }
    }
    
    func wrongAnswerList() -> some View {
        ScrollView {
            if filteredQuizList.isEmpty {
                GeometryReader { geometry in
                    Text("검색 결과가 없습니다.")
                        .font(.title)
                        .bold()
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
                .frame(height: 200)
            } else {
                LazyVStack {
                    let uniqueQuizList = Dictionary(grouping: filteredQuizList, by: \.dataID)
                        .compactMap { $0.value.first } // 틀린 문제 중복표시 방지
                    ForEach(uniqueQuizList, id: \.id) { item in
                        NavigationLazyView(WrongAnswerCell(item: item))
                    }
                }
            }
        }
        .navigationTitle("틀린 문제 목록")
        .padding()
        .searchable(text: $searchText, prompt: "제목 또는 가수로 검색할 수 있습니다.")
    }
}

private struct WrongAnswerCell: View {
    let item: Quiz
    
    var body: some View {
        HStack(spacing: 15) {
            AsyncImage(url: URL(string: item.artworkURL!)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
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
            .foregroundStyle(.text)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
