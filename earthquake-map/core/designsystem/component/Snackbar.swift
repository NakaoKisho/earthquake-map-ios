//
//  Snackbar.swift
//  earthquake-map
//
//  Created by 中尾 希翔 on 2025/08/15.
//

import SwiftUI

extension View {
    func showSnackbar(
        isReady: Binding<Bool>,
        message: Binding<String>,
        duration: Binding<Snackbar.Duration>
    ) -> some View {
        self.overlay(alignment: .bottom) {
            Snackbar(
                isReady: isReady,
                message: message,
                duration: duration
            )
        }
    }
}

struct Snackbar: View {
    @Binding var isReady: Bool
    @Binding var message: String
    @Binding var duration: Duration
    @State private var visible = false
    
    var body: some View {
        HStack {
            Spacer().frame(width: 20)
            
            GroupBox {
                ZStack {
                    Text(message)
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .shadow(radius: 10)
            
            Spacer().frame(width: 20)
        }
        .opacity(visible && isReady ? 1 : 0)
        .onChange(of: message) {
            hideSnackbar(
                duration: $duration,
                visible: $visible
            )
        }
        .onChange(of: duration) {
            hideSnackbar(
                duration: $duration,
                visible: $visible
            )
        }
    }
}

private func hideSnackbar(
    duration: Binding<Snackbar.Duration>,
    visible: Binding<Bool>
) {
    visible.wrappedValue = true
    
    DispatchQueue.main.asyncAfter(
        deadline:
                .now() + DispatchTimeInterval
            .seconds(duration.wrappedValue.rawValue)
    ) {
        withAnimation(.easeInOut(duration: 0.2)) {
            visible.wrappedValue = false
        }
    }
}

extension Snackbar {
    enum Duration: Int, Equatable {
        case long = 6
        case short = 3
        
        static func == (lhs: Duration, rhs: Duration) -> Bool {
            switch (lhs, rhs) {
                case (long, long):
                    return true
                case (long, short):
                    return false
                    
                case (short, long):
                    return false
                case (short, short):
                    return true
            }
        }
    }
}

#Preview {
    @Previewable @State var isReady = false
    @Previewable @State var message = ""
    @Previewable @State var duration = Snackbar.Duration.long
    
    var count = 0
    
    GeometryReader { geometry in
        Button(
            action: {
                isReady = true
                count += 1
                message = "Hello \(count)"
                duration = if count % 2 == 0 {
                    Snackbar.Duration.short
                } else {
                    Snackbar.Duration.long
                }
            },
            label: {
                Text("Click Here")
            }
        )
    }
    .showSnackbar(
        isReady: $isReady,
        message: $message,
        duration: $duration
    )
}
