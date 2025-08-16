//
//  IconText.swift
//  earthquake-map
//
//  Created by 中尾 希翔 on 2025/08/14.
//

import SwiftUI
import SwiftUICore

struct IconText<
    LeadingImageContent, Content,
    TrailingImageContent
>: View where LeadingImageContent: View,
              Content: View,
              TrailingImageContent: View {
    let backgroundColor: Color
    @ViewBuilder let leadingImage: () -> LeadingImageContent
    @ViewBuilder let content: () -> Content
    @ViewBuilder let trailingImage: () -> TrailingImageContent
    
    init(
        backgroundColor: Color,
        @ViewBuilder leadingImage: @escaping () -> LeadingImageContent = { EmptyView() },
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder trailingImage: @escaping () -> TrailingImageContent = { EmptyView() }
    ) {
        self.backgroundColor = backgroundColor
        self.leadingImage = leadingImage
        self.content = content
        self.trailingImage = trailingImage
    }
    
    var body: some View {
        HStack {
            leadingImage().padding(5)
            
            content()
            
            trailingImage().padding(5)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(backgroundColor)
        )
        .padding(2)
    }
}

#Preview {
    VStack {
        IconText(
            backgroundColor: .blue,
            content: {
                Text("アイコンなし")
            }
        )
        
        IconText(
            backgroundColor: .blue,
            leadingImage: {
                Image(systemName: "paperplane")
            },
            content: {
                Text("前アイコンのみ")
            }
        )
        
        IconText(
            backgroundColor: .blue,
            content: {
                Text("後ろアイコンのみ")
            },
            trailingImage: {
                Image(systemName: "paperplane")
            }
        )
        
        IconText(
            backgroundColor: .blue,
            leadingImage: {
                Image(systemName: "paperplane")
            },
            content: {
                Text("両アイコンあり")
            },
            trailingImage: {
                Image(systemName: "paperplane")
            }
        )
    }
}
