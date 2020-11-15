//
//  ActivityIndicator.swift
//  Instructor
//
//  Created by NAVEEN MADHAN on 10/25/20.
//

import SwiftUI

public struct ActivityIndicatorView: View {

    public enum IndicatorType {
        case `default`
        case arcs
        case rotatingDots
        case flickeringDots
        case scalingDots
        case opacityDots
        case equalizer
        case growingArc(Color = .red)
        case growingCircle
        case gradient([Color], CGLineCap = .butt)
    }

    @Binding var isVisible: Bool
    var type: IndicatorType

    public init(isVisible: Binding<Bool>, type: IndicatorType) {
        self._isVisible = isVisible
        self.type = type
    }

    public var body: some View {
        guard isVisible else { return AnyView(EmptyView()) }
        switch type {
        case .default:
            return AnyView(DefaultIndicatorView())
        case .arcs:
            return AnyView(ArcsIndicatorView())
        case .rotatingDots:
            return AnyView(RotatingDotsIndicatorView())
        case .flickeringDots:
            return AnyView(FlickeringDotsIndicatorView())
        case .scalingDots:
            return AnyView(ScalingDotsIndicatorView())
        case .opacityDots:
            return AnyView(OpacityDotsIndicatorView())
        case .equalizer:
            return AnyView(EqualizerIndicatorView())
        case .growingArc(let color):
            return AnyView(GrowingArcIndicatorView(color: color))
        case .growingCircle:
            return AnyView(GrowingCircleIndicatorView())
        case .gradient(let colors, let lineCap):
            return AnyView(GradientIndicatorView(colors: colors, lineCap: lineCap))
        }
    }
}


//MARK: - ARCS INDICATOR
struct ArcsIndicatorView: View {

    private let count: Int = 3

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<self.count) { index in
                ArcsIndicatorItemView(index: index, count: self.count, size: geometry.size)
            }
        }
    }
}

struct ArcsIndicatorItemView: View {

    let index: Int
    let count: Int
    let size: CGSize

    @State private var rotation: Double = 0

    var body: some View {
        let animation = Animation.default
            .speed(Double.random(in: 0.2...0.5))
            .repeatForever(autoreverses: false)

        return Group { () -> Path in
            var p = Path()
            p.addArc(center: CGPoint(x: self.size.width / 2, y: self.size.height / 2),
                     radius: self.size.width / 2 - CGFloat(self.index) * CGFloat(self.count),
                     startAngle: .degrees(0),
                     endAngle: .degrees(Double(Int.random(in: 120...300))),
                     clockwise: true)
            return p.strokedPath(.init(lineWidth: 2))
        }
        .frame(width: size.width, height: size.height)
        .rotationEffect(.degrees(rotation))
        .onAppear {
            self.rotation = 0
            withAnimation(animation) {
                self.rotation = 360
            }
        }
    }
}

//MARK: DEFAULT
struct DefaultIndicatorView: View {

    private let count: Int = 8

    public var body: some View {
        GeometryReader { geometry in
            ForEach(0..<self.count) { index in
                DefaultIndicatorItemView(index: index, count: self.count, size: geometry.size)
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct DefaultIndicatorItemView: View {

    let index: Int
    let count: Int
    let size: CGSize

    @State private var opacity: Double = 0

    var body: some View {
        let height = size.height / 3.2
        let width = height / 2
        let angle = 2 * .pi / CGFloat(count) * CGFloat(index)
        let x = (size.width / 2 - height / 2) * cos(angle)
        let y = (size.height / 2 - height / 2) * sin(angle)

        let animation = Animation.default
            .repeatForever(autoreverses: true)
            .delay(Double(index) / Double(count) / 2)

        return RoundedRectangle(cornerRadius: width / 2 + 1)
            .frame(width: width, height: height)
            .rotationEffect(Angle(radians: Double(angle + CGFloat.pi / 2)))
            .offset(x: x, y: y)
            .opacity(opacity)
            .onAppear {
                self.opacity = 1
                withAnimation(animation) {
                    self.opacity = 0.3
                }
            }
    }
}

//MARK:- EQUILIZER INDICATOR
struct EqualizerIndicatorView: View {

    private let count: Int = 5

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<self.count) { index in
                EqualizerIndicatorItemView(index: index, count: self.count, size: geometry.size)
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct EqualizerIndicatorItemView: View {

    let index: Int
    let count: Int
    let size: CGSize

    @State private var scale: CGFloat = 0

    var body: some View {
        let itemSize = size.width / CGFloat(count) / 2

        let animation = Animation.easeOut.delay(0.2)
            .repeatForever(autoreverses: true)
            .delay(Double(index) / Double(count) / 2)

        return RoundedRectangle(cornerRadius: 3)
            .frame(width: itemSize, height: size.height)
            .scaleEffect(x: 1, y: scale, anchor: .center)
            .onAppear {
                self.scale = 1
                withAnimation(animation) {
                    self.scale = 0.4
                }
            }
            .offset(x: 2 * itemSize * CGFloat(index) - size.width / 2 + itemSize / 2)
    }
}

//MARK:- FLICKER INDICATOR
struct FlickeringDotsIndicatorView: View {

    private let count: Int = 8

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<self.count) { index in
                FlickeringDotsIndicatorItemView(index: index, count: self.count, size: geometry.size)
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct FlickeringDotsIndicatorItemView: View {

    let index: Int
    let count: Int
    let size: CGSize

    @State private var scale: CGFloat = 0
    @State private var opacity: Double = 0

    var body: some View {
        let duration = 0.5
        let itemSize = size.height / 5
        let angle = 2 * CGFloat.pi / CGFloat(count) * CGFloat(index)
        let x = (size.width / 2 - itemSize / 2) * cos(angle)
        let y = (size.height / 2 - itemSize / 2) * sin(angle)

        let animation = Animation.linear(duration: duration)
            .repeatForever(autoreverses: true)
            .delay(duration * Double(index) / Double(count) * 2)

        return Circle()
            .frame(width: itemSize, height: itemSize)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                self.scale = 1
                self.opacity = 1
                withAnimation(animation) {
                    self.scale = 0.5
                    self.opacity = 0.3
                }
            }
            .offset(x: x, y: y)
    }
}

//MARK:- GRADIENT INDICATOR
struct GradientIndicatorView: View {

    let colors: [Color]
    let lineCap: CGLineCap

    @State private var rotation: Double = 0

    var body: some View {
        let gradientColors = Gradient(colors: colors)
        let conic = AngularGradient(gradient: gradientColors, center: .center, startAngle: .zero, endAngle: .degrees(360))
        let lineWidth: CGFloat = 4

        let animation = Animation
            .linear(duration: 1.5)
            .repeatForever(autoreverses: false)

        return ZStack {
            Circle()
                .stroke(colors.first ?? .white, lineWidth: lineWidth)

            Circle()
                .trim(from: lineWidth / 500, to: 1 - lineWidth / 100)
                .stroke(conic, style: StrokeStyle(lineWidth: lineWidth, lineCap: lineCap))
                .rotationEffect(.degrees(rotation))
                .onAppear {
                    self.rotation = 0
                    withAnimation(animation) {
                        self.rotation = 360
                    }
                }
        }
    }
}

//MARK:- GROWING ARC
struct GrowingArcIndicatorView: View {

    let color: Color
    @State private var animatableParameter: Double = 0

    public var body: some View {
        let animation = Animation
            .easeIn(duration: 2)
            .repeatForever(autoreverses: false)
        
        return GrowingArc(p: animatableParameter)
            .stroke(color, lineWidth: 4)
            .onAppear {
                self.animatableParameter = 0
                withAnimation(animation) {
                    self.animatableParameter = 1
                }
            }
    }
}

struct GrowingArc: Shape {

    var maxLength = 2 * Double.pi - 0.7
    var lag = 0.35
    var p: Double

    var animatableData: Double {
        get { return p }
        set { p = newValue }
    }

    func path(in rect: CGRect) -> Path {

        let h = p * 2
        var length = h * maxLength
        if h > 1 && h < lag + 1 {
            length = maxLength
        }
        if h > lag + 1 {
            let coeff = 1 / (1 - lag)
            let n = h - 1 - lag
            length = (1 - n * coeff) * maxLength
        }

        let first = Double.pi / 2
        let second = 4 * Double.pi - first

        var end = h * first
        if h > 1 {
            end = first + (h - 1) * second
        }

        let start = end + length

        var p = Path()
        p.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.width/2),
                 radius: rect.size.width/2,
                 startAngle: Angle(radians: start),
                 endAngle: Angle(radians: end),
                 clockwise: true)
        return p
    }
}

//MARK:- GOWING CIRCLE INDICATOR
struct GrowingCircleIndicatorView: View {

    @State private var scale: CGFloat = 0
    @State private var opacity: Double = 0

    var body: some View {
        let animation = Animation
            .easeIn(duration: 1.1)
            .repeatForever(autoreverses: false)

        return Circle()
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                self.scale = 0
                self.opacity = 1
                withAnimation(animation) {
                    self.scale = 1
                    self.opacity = 0
                }
            }
    }
}

//MARK:- OPACITY DOTS
struct OpacityDotsIndicatorView: View {

    private let count: Int = 3
    private let inset: Int = 4

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<self.count) { index in
                OpacityDotsIndicatorItemView(index: index, count: self.count, inset: self.inset, size: geometry.size)
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct OpacityDotsIndicatorItemView: View {

    let index: Int
    let count: Int
    let inset: Int
    let size: CGSize

    @State private var scale: CGFloat = 0
    @State private var opacity: Double = 0

    var body: some View {
        let itemSize = (size.width - CGFloat(inset) * CGFloat(count - 1)) / CGFloat(count)

        let animation = Animation.easeOut
            .repeatForever(autoreverses: true)
            .delay(index % 2 == 0 ? 0.2 : 0)

        return Circle()
            .frame(width: itemSize, height: itemSize)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                self.scale = 1
                self.opacity = 1
                withAnimation(animation) {
                    self.scale = 0.9
                    self.opacity = 0.3
                }
            }
            .offset(x: (itemSize + CGFloat(inset)) * CGFloat(index) - size.width / 2 + itemSize / 2)
    }
}

//MARK:- ROTATING DOTS
struct RotatingDotsIndicatorView: View {

    private let count: Int = 5

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<self.count) { index in
                RotatingDotsIndicatorItemView(index: index, size: geometry.size)
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct RotatingDotsIndicatorItemView: View {

    let index: Int
    let size: CGSize

    @State private var scale: CGFloat = 0
    @State private var rotation: Double = 0

    var body: some View {
        let animation = Animation
            .timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)
            .repeatForever(autoreverses: false)

        return Circle()
            .frame(width: size.width / 5, height: size.height / 5)
            .scaleEffect(scale)
            .offset(y: size.width / 10 - size.height / 2)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                self.rotation = 0
                self.scale = (5 - CGFloat(self.index)) / 5
                withAnimation(animation) {
                    self.rotation = 360
                    self.scale = (1 + CGFloat(self.index)) / 5
                }
            }
    }
}

//MARK:- SCALING DOTS
struct ScalingDotsIndicatorView: View {

    private let count: Int = 3
    private let inset: Int = 2

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<self.count) { index in
                ScalingDotsIndicatorItemView(index: index, count: self.count, inset: self.inset, size: geometry.size)
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct ScalingDotsIndicatorItemView: View {

    let index: Int
    let count: Int
    let inset: Int
    let size: CGSize

    @State private var scale: CGFloat = 0

    var body: some View {
        let itemSize = (size.width - CGFloat(inset) * CGFloat(count - 1)) / CGFloat(count)

        let animation = Animation.easeOut
            .repeatForever(autoreverses: true)
            .delay(Double(index) / Double(count) / 2)
        
        return Circle()
            .frame(width: itemSize, height: itemSize)
            .scaleEffect(scale)
            .onAppear {
                self.scale = 1
                withAnimation(animation) {
                    self.scale = 0.3
                }
            }
            .offset(x: (itemSize + CGFloat(inset)) * CGFloat(index) - size.width / 2 + itemSize / 2)
    }
}
