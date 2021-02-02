//
//  ShowDataView.swift
//  SwiftUIBridge
//
//  Created by Jack Wong on 2/1/21.
//

import SwiftUI

struct ShowDataView: View {
    @State var isOn: Bool = false

    var dataPassedIn: String = "No Data Passed In"
    
    let hueColors = stride(from: 0, to: 1, by: 0.01).map {
        Color(hue: $0, saturation: 1, brightness: 1)
    }
    
    var body: some View {
        VStack {
            Text("Here is the data you passed in: ")
            Text(dataPassedIn)
                .font(.largeTitle)
                .fontWeight(.black)
                .overlay(GeometryReader { (proxy: GeometryProxy) in
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: hueColors),
                                       startPoint: .leading,
                                       endPoint: .trailing)
                            .frame(width: 2 * proxy.size.width)
                            .offset(x: isOn ? -proxy.size.width/2 : 0)
                    }
                })
                .mask(Text(dataPassedIn).font(.largeTitle)
                        .fontWeight(.black))
        }
        .onAppear(perform: animate)
    }
    
    private func animate() {
        withAnimation(
            Animation.linear(duration: 10)
                .repeatForever(autoreverses: false)) {
            isOn = true
        }
    }
}
