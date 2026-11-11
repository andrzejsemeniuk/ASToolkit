//
//  Proportion.swift
//  AppSharkeeForMac
//
//  Created by andrzej semeniuk on 12/8/22.
//

import Foundation

class Proportion : Codable, Equatable, Hashable {
    
    static func == (lhs: Proportion, rhs: Proportion) -> Bool {
        lhs.v == rhs.v && lhs.kind == rhs.kind
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    var v : Double = 0
    
    var value : Double {
        get { v }
        set { v = newValue }
    }
    
    enum Kind : String, Codable {
        case absolute = "a"
        case percent = "p"
    }
    
    var kind : Kind
    
    init(absolute: Double) {
        v = absolute
        kind = .absolute
    }
    init(percent: Double) {
        v = percent
        kind = .percent
    }
    
    var isAbsolute : Bool { kind == .absolute }
    var isPercent  : Bool { kind == .percent }
    
    var valueAsAbsolute : Double! { isAbsolute ? v : nil }
    var valueAsPercent  : Double! { isPercent ? v : nil }
    var valueAsFraction : Double! { isPercent ? v / 100.0 : nil }
    
    func set(absolute: Double) {
        v = absolute
        kind = .absolute
    }
    func set(percent: Double) {
        v = percent
        kind = .percent
    }
    
    static func absolute(_ v: Double) -> Proportion { .init(absolute: v) }
    static func percent(_ v: Double) -> Proportion { .init(percent: v) }
    
    static let zero = Proportion.init(absolute: 0)
    
    var asPresentableString : String {
        if isPercent {
            return "\(valueAsPercent!)%"
        } else if isAbsolute {
            return "\(valueAsAbsolute!)"
        } else {
            return "0"
        }
    }

    var asPresentableIntegerString : String {
        if isPercent {
            return "\(Int64(valueAsPercent!))%"
        } else if isAbsolute {
            return "\(Int64(valueAsAbsolute!))"
        } else {
            return "0"
        }
    }

    typealias Limits = (absolute: (lowerbound: Double, upperbound: Double), percent: (lowerbound: Double, upperbound: Double))

    class Formatter : Foundation.Formatter {
        
        typealias Converter = (Proportion)->String

        let undefined : Proportion
        let limits    : Limits
        let converter : Converter
        
        init(undefined: Proportion, limits: Limits, converter : Converter? = nil) {
            self.undefined = undefined
            self.limits = limits
            self.converter = converter ?? { p in
                p.asPresentableString
            }
            super.init()
        }
        
        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
            self.undefined = .zero
            self.limits = (absolute: (lowerbound: 0, upperbound: 0), percent: (lowerbound: 0, upperbound: 0))
            self.converter = { p in
                p.asPresentableString
            }
            super.init(coder: coder)
        }
        
        override func string(for obj: Any?) -> String? {
            if let p = obj as? Proportion {
                return converter(p)
            }
            return nil
        }
        
        override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
            let string0 = string.trimmed()
            if string0.isEmpty {
                return false
            } else if string0.hasSuffix("%") {
                let string1 = string0.replacingOccurrences(of: "%", with: "")
                guard let v0 = string1.asDouble else {
                    return false
                }
                guard limits.percent.lowerbound <= v0, v0 <= limits.percent.upperbound else {
                    return false
                }
                obj?.pointee = Proportion.init(percent: v0)
                return true
            } else {
                guard let v0 = string0.asDouble else {
                    return false
                }
                guard limits.absolute.lowerbound <= v0, v0 <= limits.absolute.upperbound else {
                    return false
                }
                obj?.pointee = Proportion.init(absolute: v0)
//                updateLayout()
                return true
            }
        }
    }
    
}
