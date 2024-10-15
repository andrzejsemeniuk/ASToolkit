    //
    //  ExtensionsForSwiftUI.swift
    //  AppSharkeeForMac
    //
    //  Created by andrzej semeniuk on 4/27/22.
    //

import Foundation
import SwiftUI
//import AppKit

func Icon(_ name: String) -> Image {
    Image(systemName: name)
}

func Icon(_ name: String, tint: Color) -> some View {
    Image(systemName: name)
        .foregroundColor(tint)
}

extension View {
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
    
    func fontSize(_ size: CGFloat) -> some View {
        self.font(.system(size: size))
    }
    
}

extension Text {
    
    func fontSize(_ size: CGFloat) -> Text {
        self.font(.system(size: size))
    }

}

// https://stackoverflow.com/questions/63309407/finding-click-location-in-swiftui-on-macos

#if os(iOS) || os(macOS)
struct ClickGesture: Gesture {
    let count: Int
    let coordinateSpace: CoordinateSpace
    
    typealias Value = SimultaneousGesture<TapGesture, DragGesture>.Value
    
    init(count: Int = 1, coordinateSpace: CoordinateSpace = .local) {
        precondition(count > 0, "Count must be greater than or equal to 1.")
        self.count = count
        self.coordinateSpace = coordinateSpace
    }
    
    var body: SimultaneousGesture<TapGesture, DragGesture> {
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

extension View {
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

extension View {
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

}

//func MenuItem(_ text: String, size: FontSize = .m, design: FontDesign = .monospaced, _ action: @escaping Block) -> some View {
func MenuItemDisabled(_ text: String, bold: Bool = false, italic: Bool = false, underline: Bool = false) -> some View {
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

func RichTextMenuItemDisabled(_ text: LocalizedStringKey, bold: Bool = false, italic: Bool = false, underline: Bool = false) -> some View {
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
func MenuItem(_ text: String, bold: Bool = false, italic: Bool = false, underline: Bool = false, _ action: @escaping Block) -> some View {
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

func RichTextMenuItem(_ text: LocalizedStringKey, bold: Bool = false, italic: Bool = false, underline: Bool = false, _ action: @escaping Block) -> some View {
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

func RichTextMenuItem(_ text: LocalizedStringKey, _ icon: String, _ action: @escaping Block) -> some View {
    Button {
        action()
    } label: {
        Label(text, image: icon)
//        Text(text)
//        TextWith(text, size, design) // NOTE: MUST BE A SIMPLE TEXT() ITEM OTHERWISE APP CRASHES 2022.08.08.m
    }
}

func RichTextMenuItem(_ text: LocalizedStringKey, _ icon: String, fill: Bool, _ action: @escaping Block) -> some View {
    Button {
        action()
    } label: {
        Label(text, image: icon + (fill ? ".fill" : ""))
//        Text(text)
//        TextWith(text, size, design) // NOTE: MUST BE A SIMPLE TEXT() ITEM OTHERWISE APP CRASHES 2022.08.08.m
    }
}

func MenuItemCheckmark(on: Binding<Bool>, title: String) -> some View {
//    Picker("", selection: on) {
//        Text(title).tag(on.wrappedValue)
//    }
    MenuItem("\(on.wrappedValue ? "\u{2611}" : "\u{2610}") \(title)") {
        on.wrappedValue.flip()
    }
}

func MenuItemCheckmark(_ title: String, _ on: Binding<Bool>) -> some View {
//    MenuItemCheckmark(on: on, title: title)
    MenuItem("\(title) \(on.wrappedValue ? "\u{2611}" : "\u{2610}")") {
        on.wrappedValue.flip()
    }
}

func MenuItemCheckmark(_ on: Binding<Bool>, _ title: String, _ action: Block? = nil) -> some View {
//    MenuItemCheckmark(on: on, title: title)
    MenuItem("\(on.wrappedValue ? "\u{2611}" : "\u{2610}") \(title)") {
        on.wrappedValue.flip()
        action?()
    }
}


func MenuItemCheckmark(_ on: Bool, _ title: String, _ action: @escaping (Bool)->Void) -> some View {
//    MenuItemCheckmark(on: on, title: title)
    MenuItem("\(on ? "\u{2611}" : "\u{2610}") \(title)") {
        action(on.flipped())
    }
}

func MenuItemForVisibility(title: String = "", _ on: Binding<Bool>, animate: Bool = true, hide: String = "Hide", show: String = "Show", after: ((Bool)->Void)? = nil) -> some View {
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

func MenuItemForIncrease<T: SignedNumeric>(title: String = "", _ on: Binding<T>, increment: T, animate: Bool = true, increase: String = "Increase", after: ((T)->Void)? = nil) -> some View {
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

func MenuItemForDecrease<T: SignedNumeric & Comparable>(title: String = "", _ on: Binding<T>, decrement: T, animate: Bool = true, decrease: String = "Decrease", after: ((T)->Void)? = nil) -> some View {
    MenuItemForIncrease(title: title, on, increment: -abs(decrement), animate: animate, increase: decrease, after: after)
}

@available(tvOS 17.0, *)
func MenuForIncreaseAndDecrease<T: SignedNumeric & Comparable>(title: String, _ on: Binding<T>, increment: T, decrement: T, min: T, max: T, animate: Bool = true, increase: String = "Increase", decrease: String = "Decrease", after: ((T)->Void)? = nil) -> some View {
    Menu(title) {
        MenuItemForIncrease(on, increment: increment, animate: animate, increase: increase, after: after).disabled(on.wrappedValue > max)
        MenuItemForDecrease(on, decrement: decrement, animate: animate, decrease: decrease, after: after).disabled(on.wrappedValue < min)
    }
}











@ViewBuilder func stripes(vertical: Bool, color: Color = .white, thickness: CGFloat, spacing: CGFloat, dash: [CGFloat] = []) -> some View {
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

@ViewBuilder func stripes(vertical: Bool, color: Color = .white, thickness: CGFloat, dash: [CGFloat] = []) -> some View {
    stripes(vertical: vertical, color: color, thickness: thickness, spacing: thickness * 2, dash: dash)
}

@ViewBuilder func dots(color: Color = .white, thickness: CGFloat, spacing: CGFloat) -> some View {
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


func layoutAsLines<T>(line limit: Int, _ count: (T)->Int, values: [T]) -> [[T]] {
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

extension View {
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

extension View {
    
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
}


extension Progress {
    
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
func eventHandlerRegister(matching: NSEvent.EventTypeMask, handler: @escaping (NSEvent)->Void) -> Any? {
    NSEvent.addLocalMonitorForEvents(matching: matching) { e in
        handler(e)
        return e
    }
}

func eventHandlerUnregister(_ monitor: Any?) {
    if let monitor = monitor {
        NSEvent.removeMonitor(monitor)
    }
}

let NSEventKeyCodeForEsc = 53 // 55?
let NSEventKeyCodeForTab = 48
let NSEventKeyCodeForSpace = 49
let NSEventKeyCodeForShift = 44

func eventHandlerForKeyDownRegister(_ keyCode: UInt16, handler: @escaping (NSEvent)->Void) -> Any? {
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

enum KeyCode : UInt16 {
    case esc = 53
    case tab = 48
    case space = 32
}


extension View {
    
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
            .onChange(of: vv.wrappedValue) { v in
                to.wrappedValue = v
            }
    }
    func viewVariable<T: Equatable>(_ vv: Binding<T>, get: @escaping ()->T, set: @escaping (T)->Void) -> some View {
        self
            .onAppear {
                vv.wrappedValue = get()
            }
            .onChange(of: vv.wrappedValue) { v in
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

func forEachElements(from E: [any ExpressibleByStringInterpolation]) -> [String] {
    E.enumerated().map { i,e in "\(i)|\(e)" }
}

func forEachElements(from E: [CustomStringConvertible]) -> [String] {
    E.enumerated().map { i,e in "\(i)|\(e)" }
}

func forEachElementsIndex(from E: String) -> Int {
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
extension View {
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
struct TrackingAreaRepresentable<Content>: NSViewRepresentable where Content: View {
    let onMove: (NSPoint) -> Void
    let content: Content
    
    func makeNSView(context: Context) -> NSHostingView<Content> {
        return TrackingNSHostingView(onMove: onMove, rootView: self.content)
    }
    
    func updateNSView(_ nsView: NSHostingView<Content>, context: Context) {
        
    }
}

@available(macOS 13.0, *)
class TrackingNSHostingView<Content>: NSHostingView<Content> where Content : View {
    let onMove: (NSPoint) -> Void
    
    init(onMove: @escaping (NSPoint) -> Void, rootView: Content) {
        self.onMove = onMove
        
        super.init(rootView: rootView)
        
        setupTrackingArea()
    }
    
    required init(rootView: Content) {
        fatalError("init(rootView:) has not been implemented")
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTrackingArea() {
        let options: NSTrackingArea.Options = [.mouseMoved, .activeAlways, .inVisibleRect]
        self.addTrackingArea(NSTrackingArea.init(rect: .zero, options: options, owner: self, userInfo: nil))
    }
        
    override func mouseMoved(with event: NSEvent) {
        self.onMove(self.convert(event.locationInWindow, from: nil))
    }
}

extension View {

    func onMouseWheel(_ action: @escaping (NSEvent)->Void) -> some View {
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
    
    func onDragGesture(minimumDistance: CGFloat = 0, changed: @escaping (DragGesture.Value)->Void, ended: @escaping (DragGesture.Value)->Void) -> some View {
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

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}

extension View {
    
    func viewInScrollViewTrackingPosition(_ axes: Axis.Set, showsIndicators: Bool = false, position: Binding<CGPoint>) -> some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            self
                .background(GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll-view")).origin)
                })
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    position.wrappedValue = value
                }
        }
        .coordinateSpace(name: "scroll-view")
    }
    
    func viewInScrollViewHorizontalTrackingPosition(showsIndicators: Bool = false, _ position: Binding<CGPoint>) -> some View {
        viewInScrollViewTrackingPosition(.horizontal, showsIndicators: showsIndicators, position: position)
    }
    
    func viewInScrollViewVerticalTrackingPosition(showsIndicators: Bool = false, _ position: Binding<CGPoint>) -> some View {
        viewInScrollViewTrackingPosition(.vertical, showsIndicators: showsIndicators, position: position)
    }
    
}


struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    }
}

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .init()
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
    }
}

extension View {
    
    func viewInScrollViewTrackingFrame(_ axes: Axis.Set, showsIndicators: Bool = false, frame: Binding<CGRect>) -> some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            self
                .background(GeometryReader { geometry in
                    Color.clear
                        .preference(key: FramePreferenceKey.self, value: geometry.frame(in: .named("scroll-view")))
                })
                .onPreferenceChange(FramePreferenceKey.self) { value in
                    frame.wrappedValue = value
                }
        }
        .coordinateSpace(name: "scroll-view")
    }
    
    func viewInScrollViewHorizontalTrackingFrame(showsIndicators: Bool = false, frame: Binding<CGRect>) -> some View {
        viewInScrollViewTrackingFrame(.horizontal, showsIndicators: showsIndicators, frame: frame)
    }
    
    func viewInScrollViewVerticalTrackingFrame(showsIndicators: Bool = false, frame: Binding<CGRect>) -> some View {
        viewInScrollViewTrackingFrame(.vertical, showsIndicators: showsIndicators, frame: frame)
    }
    
}

extension View {
    func viewTrackingSize(size: Binding<CGSize>) -> some View {
        self
            .background(GeometryReader { geometry in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
            })
            .onPreferenceChange(SizePreferenceKey.self) { value in
                size.wrappedValue = value
            }
    }
}

//extension View {
//    func viewTrackingFrame(frame: Binding<CGRect>) -> some View {
//        let NAME = Date.now.asString
//        return self
//            .coordinateSpace(name: NAME)
//            .background(GeometryReader { geometry in
//                Color.clear
//                    .preference(key: FramePreferenceKey.self, value: geometry.frame(in: .named(NAME)))
//            })
//            .onPreferenceChange(FramePreferenceKey.self) { value in
//                frame.wrappedValue = value
//            }
//    }
//}



#if os(iOS)
// https://stackoverflow.com/questions/71744888/view-with-rounded-corners-and-border

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func borderWithRoundedCorner(lineWidth: CGFloat, borderColor: Color, radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
            .overlay(RoundedCorner(radius: radius, corners: corners)
                .stroke(borderColor, lineWidth: lineWidth))
    }
}
#endif

func ButtonWithIcon(_ name: String, selected: Bool = false, tint: Color? = nil, action: @escaping Block) -> some View {
    Button(action: {
        action()
    }, label: {
        Icon(name + (selected ? ".fill" : "" ))
            .foregroundColor(tint ?? .accentColor)
    })
}
