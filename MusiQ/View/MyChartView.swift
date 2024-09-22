//
//  MyChartView.swift
//  MusiQ
//
//  Created by 조규연 on 9/19/24.
//

import SwiftUI
import Charts
import RealmSwift

struct MyChartView: View {
    @ObservedResults(Quiz.self)
    var data
    
    var body: some View {
        contentView()
            .applyBackground()
    }
    
    @ViewBuilder
    func contentView() -> some View {
        if data.isEmpty {
            Text("플레이 기록이 없습니다.")
                .font(.title)
                .bold()
        } else {
            ScrollView {
                LazyVStack(spacing: 20) {
                    PieChartView()
                    
                    let songData = data.where { $0.mode == Mode.artwork.name }
                    if !songData.isEmpty {
                        BarChartView(data: data.where { $0.mode == Mode.song.name })
                    }
                    
                    let artworkData = data.where { $0.mode == Mode.artwork.name }
                    if !artworkData.isEmpty {
                        BarChartView(data: data.where { $0.mode == Mode.artwork.name })
                    }
                }
            }
            .padding()
        }
    }
}

struct PieChartView: View {
    @ObservedResults(Quiz.self)
    var data
    
    var body: some View {
        if #available(iOS 17.0, *) {
            Text("플레이한 장르")
                .asHeaderStyle()
            
            let genreCounts = genreCount(data: data)
            
            Chart(genreCounts, id: \.key) { genre, count in
                SectorMark(
                    angle: .value("Count", count),
                    innerRadius: .ratio(0.6),
                    angularInset: 2
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("Category", genre.localized))
            }
            .scaledToFit()
            .chartLegend(alignment: .center, spacing: 8)
            .chartBackground { chartProxy in
              GeometryReader { geometry in
                  if let anchor = chartProxy.plotFrame {
                      let frame = geometry[anchor]
                      VStack {
                          Text("플레이한 장르 비율")
                              .bold()
                          Text("총 \(genreCounts.reduce(0) { $0 + $1.count })개의 곡 플레이")
                              .font(.caption)
                      }
                      .position(x: frame.midX, y: frame.midY)
                  }
              }
            }
        }
    }
    
    // 장르별로 퀴즈 수를 계산하는 함수
    func genreCount(data: Results<Quiz>) -> [(key: String, count: Int)] {
        let genreGroups = Dictionary(grouping: data, by: \.genre) // 장르별로 그룹화
        return genreGroups.map { (key: $0.key, count: $0.value.count) } // 각 그룹의 개수를 카운트
    }
}

struct BarChartView: View {
    var data: Results<Quiz>
    
    var body: some View {
        Text(data.first?.mode == "노래 듣고 맞추기" ? "노래 듣고 맞추기 정답률" : "앨범 커버 보고 맞추기 정답률")
            .asHeaderStyle()
        
        let genreCorrectRates = genreCorrectRate(data: data)
        
        Chart(genreCorrectRates, id: \.key) { genre, correctRate in
            BarMark(
                x: .value("Genre", genre.localized),
                y: .value("Correct Rate", correctRate)
            )
            .foregroundStyle(by: .value("Genre", genre.localized))
        }
        .scaledToFit()
        .chartLegend(alignment: .center, spacing: 8)
    }
    
    // 장르별 정답률 계산 함수
    func genreCorrectRate(data: Results<Quiz>) -> [(key: String, correctRate: Double)] {
        let genreGroups = Dictionary(grouping: data, by: \.genre) // 장르별로 그룹화
        
        return genreGroups.map { (key: $0.key, correctRate: calculateCorrectRate(for: $0.value)) }
    }
    
    // 각 장르의 정답률을 계산하는 함수
    func calculateCorrectRate(for quizzes: [Quiz]) -> Double {
        let total = quizzes.count
        let correctCount = quizzes.filter { $0.isCorrect }.count
        return total > 0 ? (Double(correctCount) / Double(total)) * 100 : 0.0
    }
}
//
//#Preview {
//    MyChartView()
//}
