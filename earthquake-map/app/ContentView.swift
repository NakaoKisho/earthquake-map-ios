//
//  ContentView.swift
//  earthquake-map
//
//  Created by 中尾 希翔 on 2025/07/23.
//

import SwiftUI

struct ContentView: View {
    @State var isLoading = false
    @State var message = "Hello"
    
    var body: some View {
        NavigationStack {
            MapScreenRoute(
                isLoading: $isLoading
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(
                        isLoading ? "GIProgressActivity" : "GIRefresh"
                    )
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .background(
                Color("BarBackground"),
                ignoresSafeAreaEdges: .all
            )
        }
        .overlay(alignment: .bottom) {
//            Snackbar(
//                message: $message,
//                duration: Snackbar.Duration.short
//            )
        }
    }
}

#Preview {
    ContentView()
}
