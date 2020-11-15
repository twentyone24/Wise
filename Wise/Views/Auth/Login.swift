//
//  Login.swift
//  PhoneAuth
//
//  Created by Balaji on 09/11/20.
//

import SwiftUI

struct Login: View {
    @StateObject var loginData = LoginViewModel()
    @State var isSmall = UIScreen.main.bounds.height < 750
    @State var ccode = "+" + LoginViewModel().getCountryCode()
    var body: some View {
        
        ZStack{
//            VStack{
                VStack {
                    
                    Image("logo")
                    
                    Text("Verify Your Number")
                        .font(.title)
                        .fontWeight(.heavy)
                    
                    Text("You'll receive a 6 digit code\n to verify next.")
                        .lineLimit(2)
                        .font(isSmall ? .none : .title2)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                    
                    HStack{
                        TextField("+91", text: self.$ccode)
                            .keyboardType(.numberPad)
                            .frame(width: 45)
                            .padding()
                            .background(Color("Color"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                           
                        TextField("Number", text: loginData.$phNo)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color("Color"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    } .padding(.top, 15)

                    NavigationLink(destination: Verification(loginData: loginData),isActive: $loginData.gotoVerify) {
                        Text("")
                            .hidden()
                    }
                    
                    Button(action: loginData.sendCode, label: {
                        
                        Text("Continue")
                            .foregroundColor(.black)
                            .frame(width: UIScreen.main.bounds.width - 30,height: 50)
                            .buttonStyle(ScaleButtonStyle())
                            .background(Color("yellow"))
                            .cornerRadius(15)
                    })
                    .disabled(loginData.phNo == "" ? true: false)
                    
                }.padding()
//            }
            //.background(Color("bg").ignoresSafeArea(.all, edges: .all))
            
            if loginData.error{
                
                AlertView(msg: loginData.errorMsg, show: $loginData.error)
            }
        }
    }
    
}

