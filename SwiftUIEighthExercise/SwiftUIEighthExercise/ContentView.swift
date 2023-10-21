//
//  ContentView.swift
//  SwiftUIEighthExercise
//
//  Created by Лада Зудова on 20.10.2023.
//

import SwiftUI

struct RoundedCornerShape: Shape { // 1
    let radius: CGFloat
    let corners: UIRectCorner

    func path(in rect: CGRect) -> Path { // 2
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct StretchySlider: View {
    @State var height: CGFloat = 200
    @State var sliderHeight: CGFloat = 150
    @State var width: CGFloat = 100
    @State var yOffset: CGFloat = 0
    
    private var startHeight: CGFloat = 200
    private var startWidth: CGFloat = 100
    private let yPosition: CGFloat = 400
    private let maxHeight: CGFloat = 400
    
    var body: some View {
            ZStack(alignment: .bottom) {
                let offset: CGFloat = yPosition + 0.5 * startHeight
                
                Rectangle()
                    .frame(width: width, height: height)
                    .background(.ultraThinMaterial)
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: width, height: sliderHeight)
                    .gesture(
                        DragGesture(minimumDistance: 0.5, coordinateSpace: .named("screen"))
                            .onChanged({ value in
                                print("value.location.y \(value.location.y)")
                                let progress = offset - value.location.y
                                
                                if value.location.y < offset - startHeight {
                                    sliderHeight = startHeight + pow(abs(offset - startHeight - value.location.y), 7.0/10.0)
                                    width = startWidth - pow(abs(offset - startHeight - value.location.y), 1.0/2.0)
                                    yOffset = -pow(abs(offset - startHeight - value.location.y), 7.0/10.0)
                                }
                                
                                if value.location.y < offset,
                                   value.location.y >= offset - startHeight
                                {
                                    sliderHeight = progress
                                    width = startWidth
                                    yOffset = 0
                                }
                                
                                if value.location.y >= offset {
                                    sliderHeight = 0
                                    height = startHeight + pow(abs(progress), 7.0/10.0)
                                    width = startWidth - pow(abs(progress), 1.0/2.0)
                                    yOffset = pow(abs(progress), 7.0/10.0)
                                }
                            })
                        
                            .onEnded({ value in
                                withAnimation(.easeOut) {
                                    width = startWidth
                                    height = startHeight
                                    yOffset = 0
                                    if value.location.y >= offset {
                                        sliderHeight = 0
                                    }
                                    
                                    if value.location.y < offset - startHeight {
                                        sliderHeight = height
                                    }
                                }
                            })
                    )
        }
            .mask(
                RoundedRectangle(cornerRadius: 20)
            )
            .offset(y: yOffset)
            .position(x: 200, y: yPosition)
            .coordinateSpace(name: "screen")
            
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StretchySlider()
    }
}
