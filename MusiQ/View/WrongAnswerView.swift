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
    @StateObject var container: MVIContainer<WrongAnswerIntentProtocol, WrongAnswerStateProtocol>
    private var state: WrongAnswerStateProtocol { container.model }
    private var intent: WrongAnswerIntentProtocol { container.intent }
    
    var body: some View {
        NavigationView {
            contentView()
                .applyBackground()
        }
    }
    
    @ViewBuilder
    func contentView() -> some View {
        if state.quizList.where({ !$0.isCorrect }).isEmpty {
            Text("틀린 문제가 없습니다.")
                .font(.title)
                .bold()
        } else {
            wrongAnswerList()
        }
    }
    
    func wrongAnswerList() -> some View {
        ScrollView {
            if state.filteredQuizList.isEmpty {
                GeometryReader { geometry in
                    Text("검색 결과가 없습니다.")
                        .font(.title)
                        .bold()
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
                .frame(height: 200)
            } else {
                LazyVStack {
                    let uniqueQuizList = Dictionary(grouping: state.filteredQuizList, by: \.dataID)
                        .compactMap { $0.value.first } // 틀린 문제 중복표시 방지
                    ForEach(Array(uniqueQuizList), id: \.dataID) { item in
                        NavigationLazyView(WrongAnswerCell(item: item))
                    }
                }
            }
        }
        .navigationTitle("틀린 문제 목록")
        .padding()
        .searchable(text: Binding(
            get: { state.searchText },
            set: { newValue in
                intent.updateSearchText(newValue)
            }
        ), prompt: "제목 또는 가수로 검색할 수 있습니다.")
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

extension WrongAnswerView {
    static func build() -> some View {
        let model = WrongAnswerModel()
        let intent = WrongAnswerIntent(model: model)
        let container = MVIContainer(intent: intent as WrongAnswerIntentProtocol,
                                     model: model as WrongAnswerStateProtocol,
                                     modelChangePublisher: model.objectWillChange)
        return WrongAnswerView(container: container)
    }
}
