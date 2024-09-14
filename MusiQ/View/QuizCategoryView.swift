//
//  QuizCategoryView.swift
//  MusiQ
//
//  Created by 조규연 on 9/14/24.
//

import SwiftUI

struct QuizCategoryView: View {
    var body: some View {
        ScrollView {
            CategoryGridView()
                .padding()
                .navigationTitle("장르 선택")
        }
    }
}

struct CategoryGridView: View {
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        LazyVGrid(columns: columns, content: {
            ForEach(GenreSelection.allCases, id: \.id) { item in
                NavigationLink {
                    NavigationLazyView(QuizView())
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

#Preview {
    QuizCategoryView()
}
