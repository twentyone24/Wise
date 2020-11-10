//
//  LandingPage.swift
//  Wise
//
//  Created by NAVEEN MADHAN on 11/9/20.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct LandingPage : View {
    
    @State var ccode = "+91"
    @State var no = ""
    @State var show = false
    @State var msg = ""
    @State var alert = false
    @State var ID = ""
    
    var body : some View{
        
        VStack(alignment: .center){
            
            LottieView(fileName: "login")
            
            Text("Verify Your Number").font(.largeTitle).fontWeight(.heavy)
            
            Text("Please Enter Your Number To Verify Your Account")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 12)
            
            HStack{
                
                TextField("+1", text: $ccode)
                    .keyboardType(.numberPad)
                    .frame(width: 45)
                    .padding()
                    .background(BlurBG())
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                
                TextField("Number", text: $no)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(BlurBG())
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
            } .padding(.top, 15)
            
            NavigationLink(destination: VerifyView(show: $show, ID: $ID), isActive: $show) {
                Button(action: {
                    
                    if self.no != "" && self.no.count == 10 {
                        PhoneAuthProvider.provider().verifyPhoneNumber("+"+self.ccode+self.no, uiDelegate: nil) { (ID, err) in
                            if err != nil{
                                self.msg = (err?.localizedDescription)!
                                self.alert.toggle()
                                return
                            }
                            self.ID = ID!
                            self.show.toggle()
                        }
                    } else {
                        self.msg = "Please, Enter a valid phone number."
                        self.alert.toggle()
                    }
                }) {
                    
                    Text("Verify").frame(width: UIScreen.main.bounds.width - 30,height: 50)
                    
                }.foregroundColor(.white)
                .background(Color.orange)
                .cornerRadius(10)
            }
            
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
        }.padding()
        .popup(isPresented: $alert, type: .`default`, closeOnTap: false) {
            AlertView(showingPopup: $alert, msg: self.msg, Lottie: "error")
        }
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
    }
}
