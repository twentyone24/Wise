//
//  SideMenu.swift
//  Wise
//
//  Created by NAVEEN MADHAN on 11/15/20.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct SideMenu: View {
    
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @ObservedObject var loginData: LoginViewModel
    @AppStorage("log_Status") var status = false
    
    var body: some View {
        VStack {
            
            Spacer(minLength: 5)
            HStack {
                if let dp = loginData.user.dp {
                WebImage(url: Foundation.URL(string: dp)!)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    .foregroundColor(Color("BG"))
                    .frame(width: UIScreen.main.bounds.width / 4)
                }
                
                VStack {
                    Text(loginData.user.name!)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text(loginData.user.id!).fontWeight(.bold).foregroundColor(.gray)
                }
                
                
            }.padding(.trailing)
            
            VStack {
                HStack {
                Button(action: {
                    try? Auth.auth().signOut()
                    withAnimation{ status = false }
                }, label: {
                    Text("LogOut")
                        .fontWeight(.heavy)
                })
                    
                }.padding(.trailing)
            }
            
            Spacer()
            
        }//.frame(width: UIScreen.main.bounds.width / 0.5, alignment: .leading)
        .background(Color.white)
    }
}
