//
//  BreatheAnimation.swift
//  SwiftUIBridge
//
//  Created by Jack Wong on 2/1/21.
//
import SwiftUI
import PureSwiftUI

func createColor(_ red: Double, _ green: Double, _ blue: Double) -> Color {
    Color(red: red / 255, green: green / 255, blue: blue / 255)
}

let gradientStart = createColor(82, 215, 157)
let gradientEnd = createColor(51, 167, 175)
let gradient = LinearGradient([gradientStart, gradientEnd], to: .bottom)
let maskGradient = LinearGradient([.black], to: .bottom)

let maxSize: CGFloat = 200
let minSize: CGFloat = 40
let inhaleTime: Double = 3
let exhaleTime: Double = 4
let pauseTime: Double = 0.5

let ghostMaxSize: CGFloat = maxSize * 0.99
let ghostMinSize: CGFloat = maxSize * 0.94

struct BreatheAnimation: View {
    @ObservedObject var viewModel: BreathViewModel

    var body: some View {
        ZStack {
            Petals(size: viewModel.ghostSize, inhaling: viewModel.inhaling)
                .blur(viewModel.ghostBlur)
                .opacity(viewModel.ghostOpacity)
                .drawingGroup()
            Petals(size: viewModel.size, inhaling: viewModel.inhaling, isMask: true)
            Petals(size: viewModel.size, inhaling: viewModel.inhaling)
        }
        .rotateIf(viewModel.inhaling, 60.degrees)
        .rotateIfNot(viewModel.inhaling, -30.degrees)
        .onTapGesture(perform: viewModel.performAnimations)
    }
}

private struct Petals: View {
    
    let size: CGFloat
    let inhaling: Bool
    var isMask = false
    
    var body: some View {
        let petalsGradient = isMask ? maskGradient : gradient
        ZStack {
            ForEach(0..<6) { index in
                petalsGradient
                    .mask(
                Circle()
                    .frame(size)
                    .xOffsetIf(inhaling, size * 0.5)
                    .rotate(60.degrees * index)
            )
                    .blendMode(isMask ? .normal : .screen)
            }
        }
        .frameIf(inhaling, size * 2)
        .frameIfNot(inhaling, size)
    }
}

struct BreatheAnimation_Previews: PreviewProvider {
    struct BreatheAnimation_Harness: View {

        var body: some View {
            BreatheAnimation(viewModel: BreathViewModel())
                .greedyFrame()
                .backgroundColor(Color(white: 0.1))
                .ignoresSafeArea()
        }
    }

    static var previews: some View {
        BreatheAnimation_Harness()
            .previewDevice(.iPhone_12_Pro)
    }
}
