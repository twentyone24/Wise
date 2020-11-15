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
