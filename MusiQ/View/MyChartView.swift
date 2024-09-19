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
    var body: some View {
        PieChartView()
    }
}

struct PieChartView: View {
    @ObservedResults(Quiz.self)
    var data
    
    var body: some View {
        if #available(iOS 17.0, *) {
            let genreCounts = genreCount(data: data)
            
            Chart(genreCounts, id: \.key) { genre, count in
                SectorMark(
                    angle: .value("Count", count),
                    innerRadius: .ratio(0.6),
                    angularInset: 2
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("Category", genre))
            }
            .scaledToFit()
            .chartLegend(alignment: .center, spacing: 16)
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
//
//#Preview {
//    MyChartView()
//}
