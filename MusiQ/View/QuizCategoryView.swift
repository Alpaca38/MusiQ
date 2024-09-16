//
//  QuizCategoryView.swift
//  MusiQ
//
//  Created by 조규연 on 9/14/24.
//

import SwiftUI

struct QuizCategoryView: View {
    @State private var currentSongIndex = 0
    let mode: Mode
    
    var body: some View {
        ScrollView {
            CategoryGridView(mode: mode, currentSongIndex: $currentSongIndex)
                .padding()
                .navigationTitle("장르 선택")
        }
    }
}

struct CategoryGridView: View {
    let mode: Mode
    @Binding var currentSongIndex: Int
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        LazyVGrid(columns: columns, content: {
            ForEach(GenreSelection.allCases, id: \.id) { item in
                NavigationLink {
                    NavigationLazyView(QuizView(mode: mode, genre: item, currentSongIndex: $currentSongIndex))
                } label: {
                    categoryItem(item)
                }
            }
        })
    }
    
    func categoryItem(_ item: GenreSelection) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.random())
                .aspectRatio(1, contentMode: .fit)
            Text(item.genreData.name)
                .bold()
                .font(.title)
                .foregroundStyle(.black)
        }
    }
}
//
//#Preview {
//    QuizCategoryView()
//}
