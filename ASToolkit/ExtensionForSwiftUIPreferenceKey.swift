//
//  ExtensionForSwiftUIPreferenceKey.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 12/12/20.
//  Copyright © 2020 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import SwiftUI

public struct ViewPreferenceSizeKey: PreferenceKey {
    public typealias Value = CGSize
    
    public static var defaultValue: Value = .zero

    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

public struct ViewSizeGeometry: View {
    public var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: ViewPreferenceSizeKey.self, value: geometry.size)
        }
    }
}

public extension View {
    func captureSize(_ completion: @escaping (CGSize)->Void) -> some View {
        self
            .background(ViewSizeGeometry())
            .onPreferenceChange(ViewPreferenceSizeKey.self) {
                completion($0)
            }
    }
}

