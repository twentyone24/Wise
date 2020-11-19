//
//  SelcView.swift
//  Wise
//
//  Created by NAVEEN MADHAN on 11/10/20.
//

import SwiftUI
import Firebase

struct SelcView: View {
    
    @ObservedObject var loginData : LoginViewModel
    @Environment(\.presentationMode) var present
    
    @State var name = ""
    @State var phone = LoginViewModel().phNo
    @State var isTeacher = false
    
    @State var picker = false
    @State var imagedata : Data = .init(count: 0)
    @Namespace var animation
    
    var body: some View {
        
        ZStack {
            VStack {
                
                HStack{
                    Button(action: { present.wrappedValue.dismiss() }) {
                        
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Text("Create User")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    if loginData.loading{ ProgressView() }
                }
                .padding()
                
                HStack{
                    Spacer()
                    
                    Button(action: {
                        self.picker.toggle()
                    }) {
                        if self.imagedata.count == 0 {
                            Image(systemName: "person.crop.circle.badge.plus").resizable().scaledToFit().frame(width: 90, height: 70).foregroundColor(.gray)
                        } else {
                            Image(uiImage: UIImage(data: self.imagedata)!).resizable().renderingMode(.original).frame(width: 90, height: 90).clipShape(Circle())
                        }
                    }
                    Spacer()
                    
                }
                .padding(.vertical, 15)
                
                TextField("Name", text: self.$name)
                    .padding()
                    .background(BlurBG())
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                
                
                HStack(spacing: 0) {
                    Button(action: {
                        withAnimation(.spring()) {
                            self.isTeacher = false
                        }
                        
                    }) {
                        ZStack{
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 45)
                            
                            if !isTeacher {
                                Capsule()
                                    .fill(Color.white)
                                    .frame(height: 45)
                                    .matchedGeometryEffect(id: "Tab", in: animation)
                            }
                            
                            Text("STUDENT")
                                .foregroundColor(!isTeacher ? .black : .white)
                                .fontWeight(.bold)
                        }
                    }
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            self.isTeacher = true
                        }
                        
                    }) {
                        ZStack{
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 45)
                            
                            if self.isTeacher {
                                
                                Capsule()
                                    .fill(Color.white)
                                    .frame(height: 45)
                                    .matchedGeometryEffect(id: "Tab", in: animation)
                            }
                            
                            Text("TEACHER")
                                .foregroundColor(isTeacher ? .black : .white)
                                .fontWeight(.bold)
                        }
                    }
                    
                }
                .background(Color.yellow)
                .clipShape(Capsule())
                .padding()
                
                
                
                Button(action: {
                    loginData.createUser(name: name, isTeacher: isTeacher, imagedata: self.imagedata) { (stat) in
                        if stat { withAnimation { loginData.status = true; present.wrappedValue.dismiss() }
                        } else {
                            loginData.errorMsg = "Please Try Again!"
                            withAnimation{ loginData.error.toggle() }
                        }
                    }
                    
                }) {
                    Text("DONE")
                    
                }.foregroundColor(.black)
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width - 30)
                .background(Color("yellow"))
                .cornerRadius(15)
                
                Spacer()
                
            }
            .sheet(isPresented: self.$picker, content: {
                ImagePicker(picker: self.$picker, imagedata: self.$imagedata)
            })
            
            if loginData.error {
                AlertView(msg: loginData.errorMsg, show: $loginData.error)
            }
        }
    }
}

