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
    @State var shouldRenew = false
    
    var body: some View {
        NavigationStack {
            MapScreenRoute(
                isLoading: $isLoading,
                isSnackbarReady: $isSnackbarReady,
                snackbarMessage: $message,
                shouldRenew: $shouldRenew,
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(
                        isLoading ? "GIProgressActivity" : "GIRefresh"
                    )
                    .rotationEffect(
                        Angle(
                            degrees: isLoading ? 90 : 0
                        )
                    )
                    .onTapGesture {
                        shouldRenew = true
                    }
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
