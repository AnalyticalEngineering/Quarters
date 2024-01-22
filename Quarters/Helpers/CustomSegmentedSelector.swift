//
//  CustomSegmentedSelector.swift
//  Quarters
//
//  Created by J. DeWeese on 1/22/24.
//

import SwiftUI

struct CustomSegmentedPicker: View {
    var scheme: ColorScheme
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    /// For Sliding Effect
    @Namespace private var logoAnimation
    /// View Properties
    @State private var circleOffset: CGSize
    init(scheme: ColorScheme) {
        self.scheme = scheme
        let isDark = scheme == .dark
        self._circleOffset = .init(initialValue: CGSize(width: isDark ? 30 : 150, height: isDark ? -25 : -150))
    }
    var body: some View {
        /// Custom Segmented Picker
        HStack(spacing: 0) {
            ForEach(Theme.allCases, id: \.rawValue) { theme in
                Text(theme.rawValue)
                    .padding(.vertical, 10)
                    .frame(width: 100)
                    .background {
                        ZStack {
                            if userTheme == theme {
                                Capsule()
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: logoAnimation)
                            }
                        }
                        .animation(.snappy, value: userTheme)
                    }
                    .contentShape(.rect)
                    .onTapGesture {
                        userTheme = theme
                    }
            }
        }
        .padding(3)
        .background(.primary.opacity(0.06), in: .capsule)
        .padding(.top, 20)
        
        /// Max Height = 410
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(height: safeArea.bottom == .zero ? 395 : 410)
        // .background(.themeBG)
        .clipShape(.rect(cornerRadius: 30))
        .padding(.horizontal, 15)
        .padding(.bottom, safeArea.bottom == .zero ? 15 : 0)
        .environment(\.colorScheme, scheme)
        .onChange(of: scheme, initial: false) { _, newValue in
            let isDark = newValue == .dark
            withAnimation(.bouncy) {
                circleOffset = CGSize(width: isDark ? 30 : 150, height: isDark ? -25 : -150)
            }
        }
    }
}

