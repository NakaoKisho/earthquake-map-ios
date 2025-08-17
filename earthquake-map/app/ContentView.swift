//
//  ContentView.swift
//  earthquake-map
//
//  Created by 中尾 希翔 on 2025/07/23.
//

import SwiftUI

struct ContentView: View {
    @State var isLoading = false
    @State var isSnackbarReady = false
    @State var message = ""
    @State var duration = Snackbar.Duration.short
    
    var body: some View {
        NavigationStack {
            MapScreenRoute(
                isLoading: $isLoading,
                isSnackbarReady: $isSnackbarReady,
                snackbarMessage: $message
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
        .snackbar(
            isReady: $isSnackbarReady,
            message: $message,
            duration: $duration
        )
    }
}

#Preview {
    ContentView()
}
