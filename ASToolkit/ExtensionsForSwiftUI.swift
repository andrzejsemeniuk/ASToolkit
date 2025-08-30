    //
    //  ExtensionsForSwiftUI.swift
    //  AppSharkeeForMac
    //
    //  Created by andrzej semeniuk on 4/27/22.
    //

import Foundation
import SwiftUI
//import AppKit

public func Icon(_ name: String) -> Image {
    Image(systemName: name)
}

public func Icon(_ name: String, tint: Color) -> some View {
    Image(systemName: name)
        .foregroundColor(tint)
}

public extension View {
        //    func navigationTitleInline(_ title: String) -> some View {
        //        self
        //            .navigationTitle(title)
        //            .navigationBarTitleDisplayMode(.inline)
        //    }
    
    func enabled(_ flag: Bool) -> some View {
        self
            .disabled(!flag)
    }
    
    func enabled(_ flag: Bool, opacity: CGFloat) -> some View {
        self
            .disabled(!flag)
            .opacity(flag ? 1 : opacity)
    }
    
    func disabled(_ flag: Bool, opacity: CGFloat) -> some View {
        self
            .disabled(flag)
            .opacity(flag ? opacity : 1)
    }
    
    func enabled4(_ flag: Bool) -> some View { enabled(flag, opacity: 0.4) }
    func enabled5(_ flag: Bool) -> some View { enabled(flag, opacity: 0.5) }
    func disabled4(_ flag: Bool) -> some View { disabled(flag, opacity: 0.4) }
    func disabled5(_ flag: Bool) -> some View { disabled(flag, opacity: 0.5) }
    
    var separator : some View {
        hline(Color.init(white: 1, alpha: 0.5))
    }
    
    func separator(_ alpha: CGFloat) -> some View {
        hline(Color.init(white: 1, alpha: alpha))
    }
    
    func span(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }

    func span() -> some View {
        self
            .frame(maxWidth: .infinity)
    }

#if os(iOS)
    var onTapGestureConsume : some View {
        self
            .onTapGesture {
            }
    }
    var consumeTaps : some View {
        self
            .backgroundAlmostTransparent
            .onTapGestureConsume
    }
#elseif os(macOS)
    var onTapGestureConsume : some View {
        self
            .onTapGesture {
            }
            .onHover { _ in
            }
    }
    var consumeTaps : some View {
        self
            .backgroundAlmostTransparent
            .onTapGestureConsume
    }
#endif

    
    func show(_ condition: Bool) -> some View {
        self
            .opacity(condition ? 1 : 0)
    }
    
    func hide(_ condition: Bool) -> some View {
        show(!condition)
    }
    
    func fontSize(_ size: CGFloat) -> some View {
        self.font(.system(size: size))
    }
    
}

public extension Text {
    
    func fontSize(_ size: CGFloat) -> Text {
        self.font(.system(size: size))
    }

}

// https://stackoverflow.com/questions/63309407/finding-click-location-in-swiftui-on-macos

#if os(iOS) || os(macOS)
public struct ClickGesture: Gesture {
    let count: Int
    let coordinateSpace: CoordinateSpace
    
    public typealias Value = SimultaneousGesture<TapGesture, DragGesture>.Value
    
    init(count: Int = 1, coordinateSpace: CoordinateSpace = .local) {
        precondition(count > 0, "Count must be greater than or equal to 1.")
        self.count = count
        self.coordinateSpace = coordinateSpace
    }
    
    public var body: SimultaneousGesture<TapGesture, DragGesture> {
        SimultaneousGesture(
            TapGesture(count: count),
            DragGesture(minimumDistance: 0, coordinateSpace: coordinateSpace)
        )
    }
    
    func onEnded(perform action: @escaping (CGPoint) -> Void) -> some Gesture {
        ClickGesture(count: count, coordinateSpace: coordinateSpace)
            .onEnded { (value: Value) -> Void in
                guard value.first != nil else { return }
                guard let location = value.second?.startLocation else { return }
                guard let endLocation = value.second?.location else { return }
                guard ((location.x-1)...(location.x+1)).contains(endLocation.x),
                      ((location.y-1)...(location.y+1)).contains(endLocation.y) else {
                          return
                      }
                
                action(location)
            }
    }
}

public extension View {
    func onClickGesture(
        count: Int,
        coordinateSpace: CoordinateSpace = .local,
        perform action: @escaping (CGPoint) -> Void
    ) -> some View {
        gesture(ClickGesture(count: count, coordinateSpace: coordinateSpace)
                    .onEnded(perform: action)
        )
    }
    
    func onClickGesture(
        count: Int,
        perform action: @escaping (CGPoint) -> Void
    ) -> some View {
        onClickGesture(count: count, coordinateSpace: .local, perform: action)
    }
    
    func onClickGesture(
        perform action: @escaping (CGPoint) -> Void
    ) -> some View {
        onClickGesture(count: 1, coordinateSpace: .local, perform: action)
    }
    
    func onClickGesture(
        perform action: @escaping (CGPoint,CGSize) -> Void
    ) -> some View {
        onClickGestureWithBounds(perform: action)
    }
    
    func onClickGestureWithBounds(
        perform action: @escaping (CGPoint,CGSize) -> Void
    ) -> some View {
        GeometryReader { G in
            onClickGesture(count: 1, coordinateSpace: .local, perform: { p in
                action(p,G.size)
            })
        }
    }
}

#endif

//@ViewBuilder func TL(_ view: View) -> some View {
//    HStack {
//        Spacer()
//        view
//    }
//
//}

public extension View {
    @ViewBuilder var viewInTopLeft : some View {
        VStack {
            HStack {
                self
                Spacer()
            }
            Spacer()
        }
    }
    @ViewBuilder var viewInTopRight : some View {
        VStack {
            HStack {
                Spacer()
                self
            }
            Spacer()
        }
    }
    @ViewBuilder var viewInBottomRight : some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                self
            }
        }
    }
    @ViewBuilder var viewInBottomLeft : some View {
        VStack {
            Spacer()
            HStack {
                self
                Spacer()
            }
        }
    }
    @ViewBuilder var viewOnTop : some View {
        VStack {
            self
            Spacer()
        }
    }
    @ViewBuilder var viewOnBottom : some View {
        VStack {
            Spacer()
            self
        }
    }
    @ViewBuilder var viewOnLeft : some View {
        HStack {
            self
            Spacer()
        }
    }
    @ViewBuilder var viewOnRight : some View {
        HStack {
            Spacer()
            self
        }
    }

    @ViewBuilder func viewInScrollView(_ axis: Axis.Set = [.horizontal, .vertical], showsIndicators: Bool = false) -> some View {
        ScrollView.init(axis, showsIndicators: showsIndicators) {
            self
        }
    }

    @ViewBuilder func viewInScrollViewVertical(showsIndicators: Bool = false) -> some View {
        ScrollView.init(.vertical, showsIndicators: showsIndicators) {
            self
        }
    }

    @ViewBuilder func viewInScrollViewHorizontal(showsIndicators: Bool = false) -> some View {
        ScrollView.init(.horizontal, showsIndicators: showsIndicators) {
            self
//                .frame(alignment: .center)
        }
    }

    func hidden(when: Bool) -> some View {
        Group {
            if when {
                self.hidden()
            } else {
                self
            }
        }
    }
    
}

//func MenuItem(_ text: String, size: FontSize = .m, design: FontDesign = .monospaced, _ action: @escaping Block) -> some View {
public func MenuItemDisabled(_ text: String, bold: Bool = false, italic: Bool = false, underline: Bool = false) -> some View {
    Button {
    } label: {
        if #available(iOS 16.0, *), #available(tvOS 16.0, *) {
            Text(text).bold(bold).italic(italic).underline(underline)
        } else {
            Text(text).underline(underline)
        }
//        TextWith(text, size, design) // NOTE: MUST BE A SIMPLE TEXT() ITEM OTHERWISE APP CRASHES 2022.08.08.m
    }.disabled(true)
}

public func RichTextMenuItemDisabled(_ text: LocalizedStringKey, bold: Bool = false, italic: Bool = false, underline: Bool = false) -> some View {
    Button {
    } label: {
        if #available(iOS 16.0, *), #available(tvOS 16.0, *) {
            Text(text).bold(bold).italic(italic).underline(underline)
        } else {
            Text(text).underline(underline)
        }
//        TextWith(text, size, design) // NOTE: MUST BE A SIMPLE TEXT() ITEM OTHERWISE APP CRASHES 2022.08.08.m
    }.disabled(true)
}




//func MenuItem(_ text: String, size: FontSize = .m, design: FontDesign = .monospaced, _ action: @escaping Block) -> some View {
public func MenuItem(_ text: String, bold: Bool = false, italic: Bool = false, underline: Bool = false, _ action: @escaping Block) -> some View {
    Button {
        action()
    } label: {
        if #available(iOS 16.0, *), #available(tvOS 16.0, *) {
            Text(text).bold(bold).italic(italic).underline(underline)
        } else {
            Text(text).underline(underline)
        }
//        TextWith(text, size, design) // NOTE: MUST BE A SIMPLE TEXT() ITEM OTHERWISE APP CRASHES 2022.08.08.m
    }
}

public func RichTextMenuItem(_ text: LocalizedStringKey, bold: Bool = false, italic: Bool = false, underline: Bool = false, _ action: @escaping Block) -> some View {
    Button {
        action()
    } label: {
        if #available(iOS 16.0, *), #available(tvOS 16.0, *) {
            Text(text).bold(bold).italic(italic).underline(underline)
        } else {
            Text(text).underline(underline)
        }
//        TextWith(text, size, design) // NOTE: MUST BE A SIMPLE TEXT() ITEM OTHERWISE APP CRASHES 2022.08.08.m
    }
}

public func RichTextMenuItem(_ text: LocalizedStringKey, _ icon: String, _ action: @escaping Block) -> some View {
    Button {
        action()
    } label: {
        Label(text, image: icon)
//        Text(text)
//        TextWith(text, size, design) // NOTE: MUST BE A SIMPLE TEXT() ITEM OTHERWISE APP CRASHES 2022.08.08.m
    }
}

public func RichTextMenuItem(_ text: LocalizedStringKey, _ icon: String, fill: Bool, _ action: @escaping Block) -> some View {
    Button {
        action()
    } label: {
        Label(text, image: icon + (fill ? ".fill" : ""))
//        Text(text)
//        TextWith(text, size, design) // NOTE: MUST BE A SIMPLE TEXT() ITEM OTHERWISE APP CRASHES 2022.08.08.m
    }
}

public func MenuItemCheckmark(on: Binding<Bool>, title: String) -> some View {
//    Picker("", selection: on) {
//        Text(title).tag(on.wrappedValue)
//    }
    MenuItem("\(on.wrappedValue ? "\u{2611}" : "\u{2610}") \(title)") {
        on.wrappedValue.flip()
    }
}

public func MenuItemCheckmark(_ title: String, _ on: Binding<Bool>) -> some View {
//    MenuItemCheckmark(on: on, title: title)
    MenuItem("\(title) \(on.wrappedValue ? "\u{2611}" : "\u{2610}")") {
        on.wrappedValue.flip()
    }
}

public func MenuItemCheckmark(_ on: Binding<Bool>, _ title: String, _ action: Block? = nil) -> some View {
//    MenuItemCheckmark(on: on, title: title)
    MenuItem("\(on.wrappedValue ? "\u{2611}" : "\u{2610}") \(title)") {
        on.wrappedValue.flip()
        action?()
    }
}


public func MenuItemCheckmark(_ on: Bool, _ title: String, _ action: @escaping (Bool)->Void) -> some View {
//    MenuItemCheckmark(on: on, title: title)
    MenuItem("\(on ? "\u{2611}" : "\u{2610}") \(title)") {
        action(on.flipped())
    }
}

public func MenuItemForVisibility(title: String = "", _ on: Binding<Bool>, animate: Bool = true, hide: String = "Hide", show: String = "Show", after: ((Bool)->Void)? = nil) -> some View {
    MenuItem("\(on.wrappedValue ? hide : show) \(title)") {
        if animate {
            withAnimation {
                on.wrappedValue.flip()
                after?(on.wrappedValue)
            }
        } else {
            on.wrappedValue.flip()
            after?(on.wrappedValue)
        }
    }
}

public func MenuItemForIncrease<T: SignedNumeric>(title: String = "", _ on: Binding<T>, increment: T, animate: Bool = true, increase: String = "Increase", after: ((T)->Void)? = nil) -> some View {
    MenuItem("\(increase) \(title)") {
        if animate {
            withAnimation {
                on.wrappedValue += increment
                after?(on.wrappedValue)
            }
        } else {
            on.wrappedValue += increment
            after?(on.wrappedValue)
        }
    }
}

public func MenuItemForDecrease<T: SignedNumeric & Comparable>(title: String = "", _ on: Binding<T>, decrement: T, animate: Bool = true, decrease: String = "Decrease", after: ((T)->Void)? = nil) -> some View {
    MenuItemForIncrease(title: title, on, increment: -abs(decrement), animate: animate, increase: decrease, after: after)
}

@available(tvOS 17.0, *)
public func MenuForIncreaseAndDecrease<T: SignedNumeric & Comparable>(title: String, _ on: Binding<T>, increment: T, decrement: T, min: T, max: T, animate: Bool = true, increase: String = "Increase", decrease: String = "Decrease", after: ((T)->Void)? = nil) -> some View {
    Menu(title) {
        MenuItemForIncrease(on, increment: increment, animate: animate, increase: increase, after: after).disabled(on.wrappedValue > max)
        MenuItemForDecrease(on, decrement: decrement, animate: animate, decrease: decrease, after: after).disabled(on.wrappedValue < min)
    }
}

@available(tvOS 17.0, *)
public func MenuItemsForIncreases<T: SignedNumeric & Comparable>(_ on: Binding<T>, increments: [T], min: T, max: T, animate: Bool = true, increase: String = "Increase", after: ((T)->Void)? = nil) -> some View {
    Group {
        increments.views { i,V in
            MenuItemForIncrease(on, increment: V, animate: animate, increase: increase + " by \(V)", after: after).disabled(on.wrappedValue > max)
        }
    }
}

@available(tvOS 17.0, *)
public func MenuItemsForDecreases<T: SignedNumeric & Comparable>(_ on: Binding<T>, decrements: [T], min: T, max: T, animate: Bool = true, decrease: String = "Decrease", after: ((T)->Void)? = nil) -> some View {
    Group {
        decrements.views { i,V in
            MenuItemForDecrease(on, decrement: V, animate: animate, decrease: decrease + " by \(V)", after: after).disabled(on.wrappedValue < min)
        }
    }
}

@available(tvOS 17.0, *)
public func MenuItemsForIncreasesAndDecreases<T: SignedNumeric & Comparable>(_ on: Binding<T>, increments: [T], decrements: [T], min: T, max: T, animate: Bool = true, increase: String = "Increase", decrease: String = "Decrease", after: ((T)->Void)? = nil) -> some View {
    Group {
        MenuItemsForIncreases(on, increments: increments.sorted(by: { a,b in a > b }), min: min, max: max, animate: animate, increase: increase, after: after)
        MenuItemsForDecreases(on, decrements: decrements.sorted(by: { a,b in a < b }), min: min, max: max, animate: animate, decrease: decrease, after: after)
    }
}

@available(tvOS 17.0, *)
public func MenuForIncreasesAndDecreases<T: SignedNumeric & Comparable>(title: String, _ on: Binding<T>, increments: [T], decrements: [T], min: T, max: T, animate: Bool = true, increase: String = "Increase", decrease: String = "Decrease", after: ((T)->Void)? = nil) -> some View {
    Menu(title) {
        MenuItemsForIncreases(on, increments: increments.sorted(by: { a,b in a > b }), min: min, max: max, animate: animate, increase: increase, after: after)
        MenuItemsForDecreases(on, decrements: decrements.sorted(by: { a,b in a < b }), min: min, max: max, animate: animate, decrease: decrease, after: after)
    }
}











@ViewBuilder public func stripes(vertical: Bool, color: Color = .white, thickness: CGFloat, spacing: CGFloat, dash: [CGFloat] = []) -> some View {
    GeometryReader { geometry in
        Path { path in
            let t2 = thickness/2
            if vertical {
                var x = spacing/2
                while x < geometry.size.width {
                    path.move(to: .init(x: x, y: 0))
                    path.addLine(to: .init(x: x - t2, y: geometry.size.height))
                    x += spacing
                }
            } else {
                var y = spacing/2
                while y < geometry.size.height {
                    path.move(to: .init(x: 0, y: y))
                    path.addLine(to: .init(x: geometry.size.width, y: y-t2))
                    y += spacing
                }
            }
        }
        .strokedPath(.init(lineWidth: thickness, dash: dash))
    }
        //        .frame(height:thickness)
    .foregroundColor(color)
}

@ViewBuilder public func stripes(vertical: Bool, color: Color = .white, thickness: CGFloat, dash: [CGFloat] = []) -> some View {
    stripes(vertical: vertical, color: color, thickness: thickness, spacing: thickness * 2, dash: dash)
}

@ViewBuilder public func dots(color: Color = .white, thickness: CGFloat, spacing: CGFloat) -> some View {
    GeometryReader { geometry in
        Path { path in
            let t2 = thickness/2
            var x = spacing/2
            while x < geometry.size.width {
                var y = spacing/2
                while y < geometry.size.height {
                    path.move(to: .init(x: x, y: y))
                    path.addRect(.init(x: x-t2, y: y-t2, width: thickness, height: thickness))
                    y += spacing
                }
                x += spacing
            }
        }
            //            .strokedPath(.init(lineWidth: thickness, dash: dash))
        .fill(style: .init(eoFill: false, antialiased: false))
    }
        //        .frame(height:thickness)
    .foregroundColor(color)
}

    //}

extension Alignment  {
    var asCodableString : String {
        switch self {
            case .center            : return "c"
            case .leading           : return "l"
            case .topLeading        : return "Tl"
            case .bottomLeading     : return "Bl"
            case .trailing          : return "t"
            case .topTrailing       : return "Tt"
            case .bottomTrailing    : return "Bt"
            case .top               : return "T"
            case .bottom            : return "B"
            default                 : return "?"
        }
    }
}

extension String {
    var asCodableAlignment : Alignment? {
        switch self {
            case "c"    : return .center
            case "l"    : return .leading
            case "Tl"   : return .topLeading
            case "Bl"   : return .bottomLeading
            case "t"    : return .trailing
            case "Tt"   : return .topTrailing
            case "Bt"   : return .bottomTrailing
            case "T"    : return .top
            case "B"    : return .bottom
            default     : return nil
        }
    }
}

extension Binding where Value == CGFloat {
    var asBindingToDouble : Binding<Double> {
        .init(get: { self.wrappedValue.asDouble }, set: { v in self.wrappedValue = v.asCGFloat })
    }
}

extension Binding where Value == Array<CGFloat> {
    var asBindingToArrayOfDouble : Binding<Array<Double>> {
        .init(get: { self.wrappedValue.asArrayOfDouble }, set: { v in self.wrappedValue = v.asArrayOfCGFloat })
    }
}

extension Binding where Value == Double {
    var asBindingToCGFloat : Binding<CGFloat> {
        .init(get: { self.wrappedValue.asCGFloat }, set: { v in self.wrappedValue = v.asDouble })
    }
}

extension Binding where Value == Int {
    var asBindingToDouble : Binding<Double> {
        .init(get: { self.wrappedValue.asDouble }, set: { v in self.wrappedValue = Int(v) })
    }
}

extension Binding where Value == Bool {
    var asBindingInverted : Binding<Bool> {
        .init(get: { self.wrappedValue.not }, set: { v in self.wrappedValue = v.not })
    }
}

extension Binding where Value : RawRepresentable<String> {
    var bindingToString : Binding<String> {
        .init {
            self.wrappedValue.rawValue
        } set: { value in
            if let newValue = Value(rawValue: value){
                self.wrappedValue = newValue
            }
        }
    }
}


public func layoutAsLines<T>(line limit: Int, _ count: (T)->Int, values: [T]) -> [[T]] {
    var r : [[T]] = []
    var length = 0
    var line : [T] = []
    for value in values {
        let c = count(value)
        if (length + c) > limit {
            r.append(line)
            line = [value]
            length = c
        } else {
            length += c
            line.append(value)
        }
    }
    if line.isNotEmpty {
        r.append(line)
    }
    return r
}


@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension TimelineSchedule where Self == PeriodicTimelineSchedule {
    public static func every(_ interval: TimeInterval) -> PeriodicTimelineSchedule {
        .periodic(from: .now, by: interval)
    }
}


#if os(macOS)
func pasteboardCopy(string: String) {
    let pasteboard = NSPasteboard.general
    pasteboard.declareTypes([.string], owner: nil)
    pasteboard.setString(string, forType: .string)
}
#endif

public extension View {
    @ViewBuilder func hiddenIf(_ flag: Bool) -> some View {
        if flag {
            EmptyView()
        } else {
            self
        }
    }
}

#if os(macOS)
struct OnHoverBackgroundColor: ViewModifier {
    
    let color : Color
    
    var useAnimation = false
    
    @State private var isHovered = false
    
    func body(content: Content) -> some View {
        content
        .background(isHovered ? color : Color.almostTransparent) // clear)
        .onHover { isHovered in
            if useAnimation {
                withAnimation {
                    self.isHovered = isHovered
                }
            } else {
                self.isHovered = isHovered
            }
        }
    }
}

extension View {
    func onHoverBackgroundColor(_ color: Color) -> some View {
        self.modifier(OnHoverBackgroundColor(color: color))
    }
    
    func onHoverWithAnyView(_ view: AnyView, useAnimation: Bool = false, condition: @escaping (Bool)->Bool = { _ in true }) -> some View {
        self.modifier(OnHoverWithAnyView(view: view, condition: condition, useAnimation: useAnimation))
    }
    
}


struct OnHoverWithAnyView : ViewModifier {
    
    let view : AnyView
    
    let condition : (Bool)->Bool
    
    var useAnimation = false
    
    @State private var isHovered = false
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .onHover { isHovered in
                    var isHovered = isHovered
                    if condition(isHovered).not {
                        isHovered = false
                    }
                    if useAnimation {
                        withAnimation {
                            self.isHovered = isHovered
                        }
                    } else {
                        self.isHovered = isHovered
                    }
                }

            if isHovered {
                view
            }
        }
    }

}
#endif

public extension View {
    
    var backgroundAlmostTransparent : some View {
        self.background(Color.almostTransparent)
    }
    
    func backgroundColor(_ color: Color) -> some View {
        self.background(color)
    }
    
    @ViewBuilder func backgroundColor(_ flag: Bool, _ color: Color) -> some View {
        if flag {
            self.background(color)
        } else {
            self
        }
    }
    
    var backgroundWithTapGestureConsumed : some View {
        background(Color.almostTransparent.onTapGesture {
        })
    }
    
    func backgroundWithTapGesture(_ f: @escaping Block) -> some View {
        background(Color.almostTransparent.onTapGesture {
            f()
        })
    }
    

}


public extension Progress {
    
    static func percent(completed: Int) -> Progress {
        let r = Progress.init(totalUnitCount: 100)
        r.completedUnitCount = Int64(completed)
        return r
    }
    
    static let finished : Progress = {
        var r = Progress.init(totalUnitCount: 1)
        r.completedUnitCount = 1
        return r
    }()

    var percentCompleted : Double {
        100.0 * fractionCompleted
    }
}
 



#if os(macOS)
public func eventHandlerRegister(matching: NSEvent.EventTypeMask, handler: @escaping (NSEvent)->Void) -> Any? {
    NSEvent.addLocalMonitorForEvents(matching: matching) { e in
        handler(e)
        return e
    }
}

public func eventHandlerUnregister(_ monitor: Any?) {
    if let monitor = monitor {
        NSEvent.removeMonitor(monitor)
    }
}

public let NSEventKeyCodeForEsc = 53 // 55?
public let NSEventKeyCodeForTab = 48
public let NSEventKeyCodeForSpace = 49
public let NSEventKeyCodeForShift = 44

public func eventHandlerForKeyDownRegister(_ keyCode: UInt16, handler: @escaping (NSEvent)->Void) -> Any? {
    NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { e in
        if e.keyCode == keyCode {
            handler(e)
        } else {
            // 53 = ESC
            // 48 = TAB
            // 49 = SPACE
            // 51 = DELETE
            // 117 = DEL
            // 44 = SHIFT + / == ?
//            e.modifierFlags
//            print("code: \(e.keyCode)")
        }
        return e
    }
    
        //    { nsevent in
        //        if nsevent.keyCode == 125 { // arrow down
        //            //... set for example your local @State var ...
        //        } else {
        //            if nsevent.keyCode == 126 { // arrow up
        //                //... set for example your local @State var ...
        //            }
        //        }
        //        keyPressed = "\(nsevent.keyCode)"
        //        if nsevent.modifierFlags == .option {
        //            keyPressed = "OPTION"
        //        }
        //        return nsevent
        //    }
}

public enum KeyCode : UInt16 {
    case esc = 53
    case tab = 48
    case space = 32
}


public extension View {
    
    func onKeyPress(_ keyCode: UInt16, handler: @escaping Block) -> some View {
        onAppear {
            _ = eventHandlerForKeyDownRegister(keyCode) { e in
                handler()
            }
        }
    }
    
    func onKeyPress(_ keyCode: KeyCode, handler: @escaping Block) -> some View {
        onKeyPress(keyCode.rawValue, handler: handler)
    }
    
    func onKeyPress(_ keyCodes: [KeyCode], handler: @escaping Block) -> some View {
        onKeyPress(keyCodes.reduce(0, { $0 | $1.rawValue }), handler: handler)
    }
    
}

public extension NSEvent {
    
    static var isKeyDownShift : Bool {
        NSEvent.modifierFlags.contains(.shift)
    }
    
    static var isKeyDownOption : Bool {
        NSEvent.modifierFlags.contains(.option)
    }
    
    static var isKeyDownCommand : Bool {
        NSEvent.modifierFlags.contains(.command)
    }
    
    static let keyCodeEscape                : UInt16 = 53
    static let keyCodeTab                   : UInt16 = 48
    static let keyCodeSpace                 : UInt16 = 32
    
    var keyCodeIsEscape : Bool { keyCode == Self.keyCodeEscape }
    
}

public extension UInt16 {
    
    static let keyCodeEscape                : UInt16 = 53
    static let keyCodeTab                   : UInt16 = 48
    static let keyCodeSpace                 : UInt16 = 32
    
}
#endif



@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public extension View {
    
//    @inlinable public func onChange<V>(of value: V, perform action: @escaping (_ newValue: V) -> Void) -> some View where V : Equatable
    
//    @ViewBuilder public func onChangedProperties<V>(of value: V, matching: [String], perform action: @escaping (_ newValue: V) -> Void) -> some View where V : Equatable {
//        Mirror(reflecting: value).children.filter { child in
//            matching.any(where: { regex in
//                child.label?.matches(regex: regex) ?? false
//            })
//        }
//            .reduce(self, {
//                $0.onChange(of: $1.value, perform: action)
//            })
//    }
//
//    public func onChanged<V>(values: [Any], perform action: @escaping (_ newValue: V) -> Void) -> some View where V : Equatable {
//        Group {
//            if values.count > 0 {
//                var values = values
//                self
//                    .onChange(of: values.removeFirst() as (any Equatable), perform: action)
//                    .onChanged(values: values, perform: action)
//            } else {
//                self
//            }
//        }
//    }

    func viewVariable<T: Equatable>(_ vv: Binding<T>, on to: Binding<T>) -> some View {
        self
            .onAppear {
                vv.wrappedValue = to.wrappedValue
            }
            .onChange(of: vv.wrappedValue) { _,v in
                to.wrappedValue = v
            }
    }
    func viewVariable<T: Equatable>(_ vv: Binding<T>, get: @escaping ()->T, set: @escaping (T)->Void) -> some View {
        self
            .onAppear {
                vv.wrappedValue = get()
            }
            .onChange(of: vv.wrappedValue) { _,v in
                set(v)
            }
    }
}


public extension View {
    func geometryProxy(onAppear perform: @escaping (GeometryProxy)->Void) -> some View {
        GeometryReader { proxy in
            self.onAppear {
                perform(proxy)
            }
        }
    }
}

public extension View {
    func frame(size: CGSize) -> some View {
        self.frame(width: size.width, height: size.height)
    }
}

public extension String {
    var asLocalizedStringKey : LocalizedStringKey {
        LocalizedStringKey(self)
    }
}







//// https://stackoverflow.com/questions/67502138/select-all-text-in-textfield-upon-click-swiftui
//public struct SelectTextOnEditingModifier: ViewModifier {
//    public func body(content: Content) -> some View {
//        content
//            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
//                if let textField = obj.object as? UITextField {
//                    textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
//                }
//            }
//    }
//}
//
//extension View {
//
//    /// Select all the text in a TextField when starting to edit.
//    /// This will not work with multiple TextField's in a single view due to not able to match the selected TextField with underlying UITextField
//    public func selectAllTextOnEditing() -> some View {
//        modifier(SelectTextOnEditingModifier())
//    }
//}

public func forEachElements(from E: [any ExpressibleByStringInterpolation]) -> [String] {
    E.enumerated().map { i,e in "\(i)|\(e)" }
}

public func forEachElements(from E: [CustomStringConvertible]) -> [String] {
    E.enumerated().map { i,e in "\(i)|\(e)" }
}

public func forEachElementsIndex(from E: String) -> Int {
    E.splitByPipe[0].asInt!
}


#if os(macOS)

// NOTE: DON'T USE!!! USE INSTEAD 
//    .onContinuousHover { phase in
//        switch phase {
//            case .active(let point):
//                ...
//            case .ended:
//                break
//        }
//    }

// from https://swiftui-lab.com/a-powerful-combo/
@available(macOS 13.0, *)
public extension View {
    func trackingMouse(onMove: @escaping (NSPoint) -> Void) -> some View {
        TrackinAreaView(onMove: onMove) { self }
    }
    func trackingMouse(onMove: @escaping (NSPoint,NSSize) -> Void) -> some View {
        GeometryReader { G in
            TrackinAreaView(onMove: { p in
                onMove(p,G.size)
            }) { self }
        }
    }
//    func onMoveGesture(_ action: @escaping (NSPoint) -> Void) -> some View {
//        trackingMouse(onMove: action)
//    }
    func onMoveGesture(_ action: @escaping (NSPoint,NSSize) -> Void) -> some View {
        trackingMouse(onMove: action)
    }
    func onMoveGesture(_ action: @escaping (NSPoint?) -> Void) -> some View {
        self
            .onContinuousHover { phase in
                switch phase {
                    case .active(let point):
                        action(point)
                    case .ended:
                        action(nil)
                }
            }
    }
    func onMouseMove(_ action: @escaping (NSPoint?) -> Void) -> some View {
        self
            .onContinuousHover { phase in
                switch phase {
                    case .active(let point):
                        action(point)
                    case .ended:
                        action(nil)
                }
            }
    }
}

@available(macOS 13.0, *)
struct TrackinAreaView<Content>: View where Content : View {
    let onMove: (NSPoint) -> Void
    let content: () -> Content
    
    init(onMove: @escaping (NSPoint) -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.onMove = onMove
        self.content = content
    }
    
    var body: some View {
        TrackingAreaRepresentable(onMove: onMove, content: self.content())
    }
}

@available(macOS 13.0, *)
public struct TrackingAreaRepresentable<Content>: NSViewRepresentable where Content: View {
    public let onMove: (NSPoint) -> Void
    public let content: Content
    
    public func makeNSView(context: Context) -> NSHostingView<Content> {
        return TrackingNSHostingView(onMove: onMove, rootView: self.content)
    }
    
    public func updateNSView(_ nsView: NSHostingView<Content>, context: Context) {
        
    }
}

@available(macOS 13.0, *)
public class TrackingNSHostingView<Content>: NSHostingView<Content> where Content : View {
    public let onMove: (NSPoint) -> Void
    
    public init(onMove: @escaping (NSPoint) -> Void, rootView: Content) {
        self.onMove = onMove
        
        super.init(rootView: rootView)
        
        setupTrackingArea()
    }
    
    public required init(rootView: Content) {
        fatalError("init(rootView:) has not been implemented")
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setupTrackingArea() {
        let options: NSTrackingArea.Options = [.mouseMoved, .activeAlways, .inVisibleRect]
        self.addTrackingArea(NSTrackingArea.init(rect: .zero, options: options, owner: self, userInfo: nil))
    }
        
    override public func mouseMoved(with event: NSEvent) {
        self.onMove(self.convert(event.locationInWindow, from: nil))
    }
}

extension View {

    public func onMouseWheel(_ action: @escaping (NSEvent)->Void) -> some View {
        let KEY = String.random(length: 16)
        return self
            .onAppear {
                let HANDLER = eventHandlerRegister(matching: .scrollWheel, handler: action)
                globalStorage[KEY] = HANDLER
            }
            .onDisappear {
                _ = globalStorage.removeValue(forKey: KEY)
            }
    }
}

#endif


var globalStorage : [String : Any] = [:]



#if os(iOS) || os(macOS)
extension View {
    
    public func onDragGesture(minimumDistance: CGFloat = 0, changed: @escaping (DragGesture.Value)->Void = { _ in }, ended: @escaping (DragGesture.Value)->Void) -> some View {
        self.gesture(DragGesture.init(minimumDistance: minimumDistance)
            .onChanged { value in
                changed(value)
//                let p0 = value.startLocation - geometry[proxy.plotAreaFrame].origin
//                let p1 = value.location - geometry[proxy.plotAreaFrame].origin
//                
//                dragRectangle = .init(p0, p1)
//                
//                if let v0 = proxy.value(at: p0, as: (Double,Double).self), let v1 = proxy.value(at: p1, as: (Double,Double).self) {
//                    let V0 = (min(v0.0,v1.0), min(v0.1,v1.1))
//                    let V1 = (max(v0.0,v1.0), max(v0.1,v1.1))
//                    focusedSymbols = entries.filter { entry in
//                        entry.xValue >= V0.0 && entry.xValue <= V1.0 &&
//                        entry.yValue >= V0.1 && entry.yValue <= V1.1
//                    }.map { entry in
//                        entry.symbol
//                    }
//                }
                
            }
            .onEnded { value in
                ended(value)
//                dragRectangle = .zero
//                if focusedSymbols.isNotEmpty {
//                    switch Self.mode {
//                        case .select:
//                            selectedSymbols += focusedSymbols
//                        case .zoom:
//                            omittedSymbols += [vm.results.symbols - focusedSymbols]
//                        case .hide:
//                            hiddenSymbols += focusedSymbols
//                    }
//                    focusedSymbols = []
//                    recalculateEntries()
//                }
            }
        )
            //                            .trackingMouse(onMove: { point in
    }
    
}
#endif












// https://saeedrz.medium.com/detect-scroll-position-in-swiftui-3d6e0d81fc6b

public struct ScrollOffsetPreferenceKey: PreferenceKey {
    public static var defaultValue: CGPoint = .zero
    
    static public func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}

extension View {
    
    public func viewInScrollViewTrackingPosition(_ axes: Axis.Set, showsIndicators: Bool = false, position: Binding<CGPoint>, named: String) -> some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            self
                .background(GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named(named)).origin)
                })
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    position.wrappedValue = value
                }
        }
        .coordinateSpace(name: named)
    }
    
    public func viewInScrollViewHorizontalTrackingPosition(showsIndicators: Bool = false, _ position: Binding<CGPoint>, named: String) -> some View {
        viewInScrollViewTrackingPosition(.horizontal, showsIndicators: showsIndicators, position: position, named: named)
    }
    
    public func viewInScrollViewVerticalTrackingPosition(showsIndicators: Bool = false, _ position: Binding<CGPoint>, named: String) -> some View {
        viewInScrollViewTrackingPosition(.vertical, showsIndicators: showsIndicators, position: position, named: named)
    }

    
    public func viewInScrollViewReaderTrackingIdentifiers(identifier: Binding<String>, anchor: UnitPoint? = nil,  onChangedIdentifier: ((ScrollViewProxy,String)->Void)? = nil) -> some View {
        ScrollViewReader { proxy in
            self
                .onChange(of: identifier.wrappedValue) { _,v in
                if let onChangedIdentifier {
                    onChangedIdentifier(proxy,v)
                } else {
                    proxy.scrollTo(v, anchor: anchor)
                }
            }
        }
    }
    
    public func viewInScrollViewReaderTrackingIdentifiers(identifier: Binding<Int>, anchor: UnitPoint? = nil,  onChangedIdentifier: ((ScrollViewProxy,Int)->Void)? = nil) -> some View {
        ScrollViewReader { proxy in
            self
                .onChange(of: identifier.wrappedValue) { _,v in
                if let onChangedIdentifier {
                    onChangedIdentifier(proxy,v)
                } else {
                    proxy.scrollTo(v, anchor: anchor)
                }
            }
        }
    }
    
    public func viewInScrollViewReader(proxy: Binding<ScrollViewProxy?>) -> some View {
        ScrollViewReader { PROXY in
            self
                .onAppear {
                    proxy.wrappedValue = PROXY
                }
        }
    }
    
    public func viewInScrollViewReader(proxy: @escaping (ScrollViewProxy)->Void) -> some View {
        ScrollViewReader { PROXY in
            self
                .onAppear {
                    proxy(PROXY)
                }
        }
    }
    
//    public func viewInScrollViewTrackingIdentifiers(_ axes: Axis.Set, named: String, showsIndicators: Bool = false, identifier: Binding<String>, anchor: UnitPoint? = nil,  onChangedIdentifier: ((ScrollViewProxy,String)->Void)? = nil) -> some View {
//        ScrollView(axes, showsIndicators: showsIndicators) {
//            self
//        }
//        .viewInScrollViewReaderTrackingIdentifiers(identifier: identifier, anchor: anchor, onChangedIdentifier: onChangedIdentifier)
//    }

}


struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static public func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    }
}

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .init()
    
    static public func reduce(value: inout CGRect, nextValue: () -> CGRect) {
    }
}

struct ScrollViewWithTrackingFrame<Content: View>: View {
    let name: String
    var axes: Axis.Set = [.vertical, .horizontal]
    var showsIndicators: Bool = false
    @Binding var frame: CGRect
    let content: () -> Content
    
    var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            content()
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: FramePreferenceKey.self, value: geometry.frame(in: .named(name)))
                    }
                )
                .onPreferenceChange(FramePreferenceKey.self) { value in
                    frame = value
                }
        }
        .coordinateSpace(name: name)
    }
}


extension View {
    
    public func viewInScrollViewTrackingFrame(_ axes: Axis.Set, showsIndicators: Bool = false, name: String = "scroll-view", frame: Binding<CGRect>) -> some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            self
                .background(GeometryReader { geometry in
                    Color.clear
                        .preference(key: FramePreferenceKey.self, value: geometry.frame(in: .named(name)))
                })
                .onPreferenceChange(FramePreferenceKey.self) { value in
                    frame.wrappedValue = value
                }
        }
        .coordinateSpace(name: name)
    }
    
    public func viewInScrollViewHorizontalTrackingFrame(showsIndicators: Bool = false, frame: Binding<CGRect>) -> some View {
        viewInScrollViewTrackingFrame(.horizontal, showsIndicators: showsIndicators, frame: frame)
    }
    
    public func viewInScrollViewVerticalTrackingFrame(showsIndicators: Bool = false, frame: Binding<CGRect>) -> some View {
        viewInScrollViewTrackingFrame(.vertical, showsIndicators: showsIndicators, frame: frame)
    }
    
}

extension View {
    public func viewTrackingSize(size: Binding<CGSize>) -> some View {
        self
            .background(GeometryReader { geometry in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
            })
            .onPreferenceChange(SizePreferenceKey.self) { value in
                size.wrappedValue = value
            }
    }
    public func viewTrackingFrame(frame: Binding<CGRect>) -> some View {
        let NAME = Date.now.asString
        return self
            .coordinateSpace(name: NAME)
            .background(GeometryReader { geometry in
                Color.clear
                    .preference(key: FramePreferenceKey.self, value: geometry.frame(in: .named(NAME)))
            })
            .onPreferenceChange(FramePreferenceKey.self) { value in
                frame.wrappedValue = value
            }
    }
}



#if os(iOS)
// https://stackoverflow.com/questions/71744888/view-with-rounded-corners-and-border

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    public func borderWithRoundedCorner(lineWidth: CGFloat, borderColor: Color, radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
            .overlay(RoundedCorner(radius: radius, corners: corners)
                .stroke(borderColor, lineWidth: lineWidth))
    }
}
#endif

public func ButtonWithIcon(_ name: String, selected: Bool = false, tint: Color? = nil, action: @escaping Block) -> some View {
    Button(action: {
        action()
    }, label: {
        Icon(name + (selected ? ".fill" : "" ))
            .foregroundColor(tint ?? .accentColor)
    })
}

public func ButtonWithIconAndAnimation(_ name: String, selected: Bool = false, tint: Color? = nil, action: @escaping Block) -> some View {
    Button(action: {
        withAnimation {
            action()
        }
    }, label: {
        Icon(name + (selected ? ".fill" : "" ))
            .foregroundColor(tint ?? .accentColor)
    })
}

public func ButtonWithTextAndAnimation(_ text: String, selected: Bool = false, tint: Color? = nil, action: @escaping Block) -> some View {
    Button(action: {
        withAnimation {
            action()
        }
    }, label: {
        Text(text)
            .foregroundColor(tint ?? .primary)
//            .foregroundColor(tint ?? .accentColor)
    })
}


public extension Array {
    func views(@ViewBuilder f: @escaping (_ index: Int, _ element: Element) -> some View) -> some View {
        Group {
            ForEach(self.range, id: \.self) { i in
                f(i,self[i])
            }
        }
    }
    func views(@ViewBuilder f: @escaping (_ index: Int, _ last: Bool, _ element: Element) -> some View) -> some View {
        Group {
            ForEach(self.range, id: \.self) { i in
                f(i,i == count-1, self[i])
            }
        }
    }
}

public extension View {
    func scaleEffect(_ s: Double) -> some View {
        self
            .scaleEffect(x: s, y: s, anchor: .center)
    }
}

public extension View {
    func modify(_ mod: @escaping (AnyView)->some View) -> some View {
        mod(self.asAnyView)
    }
    func modify(if condition: Bool, then: @escaping (AnyView)->some View) -> some View {
        Group {
            if condition {
                then(self.asAnyView)
            } else {
                self
            }
        }
    }
}

public extension View {
    @ViewBuilder func optional(_ flag: Bool, content: (Self) -> some View) -> some View {
        if flag {
            content(self)
        } else {
            self
        }
    }
}


public extension Binding where Value == Bool {
    static let alwaysTrue = Binding.constant(true)
    static let alwaysFalse = Binding.constant(false)
    static func value(_ v: Bool) -> Self {
        Binding.constant(v)
    }
}

public extension Binding<Bool> {
    static func onEmptyString(_ value: Binding<String>) -> Binding<Bool> {
        .init(get: {
            value.wrappedValue.isNotEmpty
        }, set: { v in
            if !v {
                value.wrappedValue = ""
            }
        })
    }
    static func onOptionalString(_ value: Binding<String?>) -> Binding<Bool> {
        .init(get: {
            value.wrappedValue != nil
        }, set: { v in
            if !v {
                value.wrappedValue = nil
            }
        })
    }
}


extension Bool {
    var asIconCheckmark : String {
        self ? "checkmark.square.fill" : "square"
    }
}
