//
//  RepeatingHearts.swift
//  SwiftUIBridge
//
//  Created by Jack Wong on 2/1/21.
//

import SwiftUI
import PureSwiftUI

fileprivate let heartColor = Color(red: 225/255, green: 40/255, blue: 48/255)
fileprivate let heartLayoutConfig = LayoutGuideConfig.grid(columns: 16, rows: 20)

fileprivate typealias Curve = (p: CGPoint, cp1: CGPoint, cp2: CGPoint)

struct RepeatingHearts: Shape {
    
    private var factor: CGFloat
    
    let debug : Bool
    
    init(animating: Bool = true, debug: Bool = false) {
        self.debug = debug
        self.factor = animating ? 1 : 0
    }
    
    var animatableData: CGFloat {
        get {
            factor
        }
        set {
            factor = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        var g = heartLayoutConfig.layout(in: rect)
            .scaled(0.4)
            .yOffset(rect.heightScaled(-0.3))
        
        for _ in 0..<4 {
            let p1 = g[0,6].to(g[2,6], factor)
            let p2 = g[8,4].to(g[8,5], factor)
            let p3 = g[16,6].to(g[14,6], factor)
            let p4 = g[8,20].to(g[8,19], factor)
            
            var curves = [Curve]()
            
            //C1
            curves.append(
            Curve(p2,
                  g[0,0].to(g[3,2], factor),
                  g[6,-2].to(g[7,2], factor)))
            
            //C2
            curves.append(
            Curve(p3,
                  g[10,-2].to(g[9,2], factor),
                  g[16,0].to(g[13,2], factor)))
            
            //C3
            curves.append(
            Curve(p4,
                  g[16,10].to(g[15,10], factor),
                  g[10,13]))
            
            //C4
            curves.append(
            Curve(p1,
                  g[6,13],
                  g[0,10].to(g[1,10], factor)))
            
            path.move(p1)
            
            for curve in curves {
                path.curve(curve.p, cp1: curve.cp1, cp2: curve.cp2, showControlPoints: debug)
            }
            
            g = g.rotated(90.degrees)
        }

        return path
    }
}


struct RepeatingAnimatedHeartShapeDemo: View {
    @State private var animating = false
    var body: some View {
        VStack(spacing: 75) {
            Group {
                RepeatingHearts(animating: animating)
                    .fill(heartColor)
                
                RepeatingHearts(animating: animating, debug: true)
                    .strokeColor(.black, lineWidth: 2)
                    .layoutGuide(heartLayoutConfig)
            }
            .frame(200)
        }
        .onAppear {
            withAnimation(
                Animation
                    .easeOut(duration: 0.2).repeatForever(autoreverses: true)
            ) {
                animating = true
            }
        }
    }
}


struct RepeatingHeartShapeDemo_Previews: PreviewProvider {
    static var previews: some View {
        RepeatingAnimatedHeartShapeDemo()
            .padding(50)
            .previewDevice(.iPhone_12_Pro)
            .previewSizeThatFits()
            .showLayoutGuides(true)
    }
}
