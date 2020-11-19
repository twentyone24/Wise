//
//  BlurBG.swift
//  Wise
//
//  Created by NAVEEN MADHAN on 11/9/20.
//

import SwiftUI

struct BlurBG : UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIVisualEffectView{
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

public struct BlurView: UIViewRepresentable {
    
    public init(style: UIBlurEffect.Style) {
        self.style = style
    }
    
    private let style: UIBlurEffect.Style
    
    public typealias Context = UIViewRepresentableContext<BlurView>
    
    public func makeUIView(context: Context) -> UIView { createView() }
    
    public func updateUIView(_ uiView: UIView, context: Context) {}
}


// MARK: - Test Extensions
extension BlurView {
    
    func createView() -> UIView {
        let view = UIView(frame: .zero)
        let blurView = createBlurView()
        add(blurView, to: view)
        return view
    }
}


// MARK: - Private Extensions
private extension BlurView {
    
    func add(_ blurView: UIVisualEffectView, to view: UIView) {
        view.backgroundColor = .clear
        view.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func createBlurView() -> UIVisualEffectView {
        let effect = UIBlurEffect(style: style)
        let view = UIVisualEffectView(effect: effect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}


public extension UIBlurEffect.Style {
    
    /**
     All available UIBlurEffect styles.
     */
    static var allCases: [UIBlurEffect.Style] {
        [
            .regular,
            .prominent,
            
            .systemUltraThinMaterial,
            .systemThinMaterial,
            .systemMaterial,
            .systemThickMaterial,
            .systemChromeMaterial,
            
            .systemUltraThinMaterialLight,
            .systemThinMaterialLight,
            .systemMaterialLight,
            .systemThickMaterialLight,
            .systemChromeMaterialLight,
            
            .systemUltraThinMaterialDark,
            .systemThinMaterialDark,
            .systemMaterialDark,
            .systemThickMaterialDark,
            .systemChromeMaterialDark,
            
            .extraLight,
            .light,
            .dark
        ]
    }
}

public extension View {
    
    func systemBlur(style: UIBlurEffect.Style) -> some View {
        overlay(BlurView(style: style))
    }
}
