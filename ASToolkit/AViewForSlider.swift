//
//  AViewForSlider.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 2024-12-03.
//  Copyright © 2024 Andrzej Semeniuk. All rights reserved.
//

import SwiftUI

public struct AViewForSlider: View {
    
    @Binding public var value : Double
    
    public let min     : Double
    public let max     : Double
    
    public var minValue    : Double?
    public var maxValue    : Double?
    
    @State public var bg      : Color     = .gray9
    @State public var fg      : Color     = .white
    
    public let width   : CGFloat
    public var radius  : CGFloat   = 16
    
    public var userChangedValue : Block?
    
    @State public var showTextField = true
    @State public var isTextFieldEditing = false
    
    public func valueFromLocation(_ x0: CGFloat) -> Double {
        let x = x0 + width/2 - radius
        let w = Double(width - radius - radius)
        let a = Double(x - radius)
        let b = self.max - self.min
        print("width: \(width), w=\(w) radius=\(radius) x=\(x) x0=\(x0)")
        let VMIN = min.max(minValue ?? min)
        let VMAX = max.min(maxValue ?? max)
        return Swift.max(min, Swift.min(max, min + a / w * b)).max(VMIN).min(VMAX)
    }
    
        //    @State private var offset : CGFloat = 0
    
    public var offsetFromValue : CGFloat {
        let VMIN = min.max(minValue ?? min)
        let VMAX = max.min(maxValue ?? max)
        let VALUE = value.max(VMIN).min(VMAX)
        return radius + (width - radius - radius) * CGFloat(Swift.max(min,Swift.min(max,VALUE)) - min)/CGFloat(max - min) - width / 2
    }
    
    public var body: some View {
        ZStack {
            Capsule()
                .fill(bg)
                .frame(minWidth: radius + radius)
                .frame(width: width, height: radius*2)
                .onClickGesture { location in
                    value   = valueFromLocation(location.x - width/2 + radius)
                    userChangedValue?()
                }
            
            Circle()
                .fill(fg)
                .frame(width: radius*2, height: radius*2)
                .offset(x: offsetFromValue)
                .gesture(
                    DragGesture()
                        .onEnded { gesture in
                            value   = valueFromLocation(gesture.location.x)
                            userChangedValue?()
                        }.onChanged { gesture in
                            value   = valueFromLocation(gesture.location.x)
                            userChangedValue?()
                        })
                .onTapGesture {
                    isTextFieldEditing = true
                }
            
            if showTextField && isTextFieldEditing {
                TextField.init("", text: .init(get: { value.asString }, set: { v in
                    if let V = v.asDouble {
                        value = V
                        userChangedValue?()
                    }
                }), onCommit: {
                    isTextFieldEditing = false
                }).frame(width: width)
            }
        }
            //            .save(size: <#T##Binding<CGSize>#>)
            //        .border(Color.black, width: 1)
            //        .onAppear {
            //            offset = offsetFromValue
            //        }
    }
}

//#Preview {
//    AViewForSlider(value: <#T##Double#>, min: <#T##Double#>, max: <#T##Double#>, minValue: <#T##Double?#>, maxValue: <#T##Double?#>, bg: <#T##Color#>, fg: <#T##Color#>, width: <#T##CGFloat#>, radius: <#T##CGFloat#>, userChangedValue: <#T##Block?#>, isEditing: <#T##arg#>)
//}
struct AViewForSlider_Previews: PreviewProvider {
    
    class HoldingValue : ObservableObject {
        @Published var value : Double = 0
    }
    
    @ObservedObject static var holder = HoldingValue()
    
    static var previews: some View {
        Group {
            AViewForSlider(value: $holder.value, min: -1, max: +1, bg: .gray8, fg: .white, width: 128, radius: 12)
//                .frame(width: 128)
        }
    }
}

