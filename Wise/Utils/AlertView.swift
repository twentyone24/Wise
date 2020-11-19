//
//  AlertView.swift
//  Wise
//
//  Created by NAVEEN MADHAN on 11/9/20.
//

import SwiftUI

/*
struct AlertView: View {
    
    @Binding var showingPopup: Bool
    @State var msg: String
    @State var Lottie: String = "error"
    let popupColor = Color(hex: "3d5a80")
    
    var body: some View {
        VStack(spacing: 10) {
            LottieView(fileName: self.Lottie)
                .aspectRatio(contentMode: ContentMode.fit)
                .frame(width: 100, height: 100)

            Text("Oh, Snap!")
                .foregroundColor(.white)
                .fontWeight(.bold)

            Text(self.msg)
                .font(.system(size: 12))
                .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))

            Spacer()

            Button(action: {
                self.showingPopup = false
            }) {
                Text("Got it")
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
            }
            .frame(width: 100, height: 40)
            .background(Color.white)
            .cornerRadius(20.0)
        }
        .padding(EdgeInsets(top: 70, leading: 20, bottom: 40, trailing: 20))
        .frame(width: 300, height: 400)
        .background(self.popupColor)
        .cornerRadius(10.0)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
    }
}

*/


struct AlertView: View {
    var msg: String
    @Binding var show: Bool
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15, content: {
            Text("Message")
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            Text(msg)
                .foregroundColor(.gray)
            
            Button(action: {
                // closing popup...
                show.toggle()
            }, label: {
                Text("Close")
                    .foregroundColor(.black)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 100)
                    .background(Color("yellow"))
                    .cornerRadius(15)
            })
            
            // centering the button
            .frame(alignment: .center)
        })
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal,25)
        
        // background dim...
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3).ignoresSafeArea())
    }
}

func msgHUD(msg: String, logo: String = "antenna.radiowaves.left.and.right") -> some View {
    HStack(spacing: 10) {
        Image(systemName: logo)
            .font(.system(size: 15))
            .foregroundColor(.red)
        Text(msg)
            .font(.system(size: 15))
            .foregroundColor(.gray)
    }
    .cornerRadius(30.0)
    .padding(.horizontal, 10)
    .padding(14)
    .background(
        BlurView(style: .systemMaterial)
            .clipShape(Capsule())
            .shadow(color: Color(.black).opacity(0.22), radius: 12, x: 0, y: 5)
    )
}
