//
//  BreathViewModel.swift
//  SwiftUIBridge
//
//  Created by Jack Wong on 2/1/21.
//

import SwiftUI
import PureSwiftUI
import Combine

final class BreathViewModel: ObservableObject {
    @Published var size = minSize
    @Published var inhaling = false
    @Published var ghostSize = ghostMaxSize
    @Published var ghostBlur: CGFloat = 0
    @Published var ghostOpacity: Double = 0
    
    func performAnimations() {
        withAnimation(.easeInOut(duration: inhaleTime)) {
            inhaling = true
            size = maxSize
        }
        after(inhaleTime + pauseTime) { [weak self] _ in
            guard let self = self else { return }
            self.ghostSize = ghostMaxSize
            self.ghostBlur = 0
            self.ghostOpacity = 0.8
            after(exhaleTime * 0.2) {
                withAnimation(.easeOut(duration: exhaleTime * 0.6)) {
                    self.ghostOpacity = 0
                    self.ghostBlur = 10
                }
            }
            withAnimation(.easeInOut(duration: exhaleTime)) { [weak self] in
                guard let self = self else { return }
                self.inhaling = false
                self.size = minSize
                self.ghostSize = ghostMinSize
            }
        }
    }
}

