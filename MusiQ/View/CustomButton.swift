//
//  CustomButton.swift
//  MusiQ
//
//  Created by 조규연 on 1/8/25.
//

import SwiftUI

struct CustomButton: View {
    let image: Image?
    let title: String
    let titleColor: Color
    let tintColor: Color
    let action: () -> Void
    
    init(image: Image? = nil, title: String, titleColor: Color, tintColor: Color, action: @escaping () -> Void) {
        self.image = image
        self.title = title
        self.titleColor = titleColor
        self.tintColor = tintColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack() {
                if let image {
                    image
                }
                Text(title)
                    .foregroundStyle(titleColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 30)
        }
        .buttonStyle(BorderedProminentButtonStyle())
        .tint(tintColor)
    }
}
