//
//  Home.swift
//  Wise
//
//  Created by NAVEEN MADHAN on 11/13/20.
//

import SwiftUI
import Firebase

struct Home: View {
    
    @AppStorage("log_Status") var status = false
    @ObservedObject var loginData = LoginViewModel()
    
    init() {
        //loginData.getUser()
        
        if loginData.isTeacher {
            loginData.roomList()
        } else { loginData.studRoomList() }
        print(loginData.rooms)
    }
    @State var tab = 0
    
    var body: some View {
        ZStack {
            
            Color("primaryBG").edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0){
                
                if !loginData.isTeacher {
                    Student(loginData: self.loginData)
                } else {
                    TeacherView(loginData: self.loginData)
                }
                
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct Student: View {
    
    @ObservedObject var loginData: LoginViewModel
    @State var id: String = ""
    @State var isShareSheetShowing = false
    var body: some View {
        ZStack {
            if loginData.rooms.count == 0 {
                VStack {
                    
                    HStack{
                        Text("GFS")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .offset(y: -40)
                        Spacer(minLength: 0)
                    }
                    .padding()
                    .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
                    .background(Color("theme"))
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Enter a class ID given by your teacher to enroll in a class.").bold().lineLimit(2).padding(5).font(.title3)
                        
                        TextField("Class ID", text: $id)
                            .textCase(.uppercase)
                            .padding()
                            .background(Color.black.opacity(0.06))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        HStack {
                            Button(action: {
                                loginData.joinRoom(id: id, name: loginData.user.name ?? " ") { (stat) in
                                    if stat {
                                        print("requested")
                                        UIApplication.shared.endEditing()
                                    }
                                    else { print("err") }
                                }
                            }, label: {
                                
                                Text("Enroll")
                                    .font(.title3)
                                    .foregroundColor(.black)
                                    .padding(.vertical,13)
                                    .padding(.horizontal,28)
                                    .buttonStyle(ScaleButtonStyle())
                                    .background(Color("theme"))
                                    .cornerRadius(15)
                            })
                            .disabled(id == "" ? true: false)
                            
                            Button(action: {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                shareButton()
                            }, label: {
                                
                                Text("INVITE TEACHER")
                                    .bold()
                                    .font(.title3)
                                    .foregroundColor(Color("theme"))
                                    .padding(.vertical,8)
                                    .padding(.horizontal,8)
                            })
                        }
                    }
                    .padding()
                    .background(BlurBG())
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: -5)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .offset(y: -50)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Please Note:").bold().padding(5).font(.title2)
                        Divider()
                        Text("♦️ Classrooms are invite only. i.e. Only teachers can set up classrooms & invite students.").font(.body)
                        Text("♦️ If your teacher is teaching on this app, ask them for Classroom Id.").font(.body)
                        Text("♦️ If you already sent a join request, please wait for your teacher to accept it.").font(.body)
                        Text("♦️ If teacher is not teaching in this app, share them the app with the Invite Teacher button").font(.body)
                    }.padding()
                    
                    Spacer()
                }
                .popup(isPresented: $loginData.HUD, type: .floater(), position: .top, animation: Animation.spring(), autohideIn: 2) {
                    msgHUD(msg: loginData.HUDMsg)
                }
            } else {
                studentRoom(loginData: self.loginData)
            }
        }
        
        
        
    }
    
    func shareButton() {
        
        isShareSheetShowing.toggle()
        
        let text = """
            You have been invited by \(loginData.user.name ?? " ") to take your classroom online.

            Download the App at
            https://studant.in

            Enroll in classroom by entering,
            Classroom ID: \(id)
        """
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        
    }
}



struct ClassroomView: View {
    
    @ObservedObject var loginData: LoginViewModel
    @State var createRoom = false
    @State var menu = false
    
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            NavigationView {
                ZStack(alignment: .bottomTrailing) {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(self.loginData.rooms) { i in
                            NavigationLink(destination: teacherRoomDetail(loginData: loginData, id: i.roomId!)) {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(i.roomName ?? "N/A").bold().padding(3).foregroundColor(Color("text"))
                                    Divider()
                                    Text(i.subject ?? "N/A").padding(.horizontal, 5).foregroundColor(Color("text"))
                                    Text("\(i.createdAt!.getFormattedDate(format: "MMM d, h:mm a") )").padding(.horizontal, 5).foregroundColor(Color("text"))
                                    
                                }
                                .frame(height: UIScreen.main.bounds.height / 7, alignment: .center)
                                .background(BlurBG())
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: -5)
                                .cornerRadius(20)
                                .padding(.horizontal, 10)
                            }
                        }
                    }
                    .padding(.top, 10)
                    .navigationBarTitle("Your Active Classrooms", displayMode: .inline)
                    .navigationBarItems(
                        leading:
                            Button(action: {
                                withAnimation{
                                    self.menu = true
                                }
                            }) {
                                Image(systemName: "gear")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color("theme"))
                            }
                    )
                    
                    Button(action: {
                        self.createRoom.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color("theme"))
                            .padding()
                            .offset(y: -20)
                    }
                    .fullScreenCover(isPresented: self.$createRoom) {
                        Wise.createRoom(show: self.$createRoom, loginData: loginData)
                    }
                }
            }
            .bottomSheet(isPresented: self.$menu, height: UIScreen.main.bounds.height /  2) {
                SideMenu(loginData: loginData)
            }
            
            
            if loginData.error{
                
                AlertView(msg: loginData.errorMsg, show: $loginData.error)
            }
            
            
            
            
        }
        
    }
}


