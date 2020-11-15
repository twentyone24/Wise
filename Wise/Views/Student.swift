//
//  Student.swift
//  Wise
//
//  Created by NAVEEN MADHAN on 11/15/20.
//

import SwiftUI

struct studentRoom: View {
    
    @ObservedObject var loginData: LoginViewModel
    @State var joinRoom = false
    @State var id = ""
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(self.loginData.rooms) { i in
                        NavigationLink(destination: studRoomDetail(loginData: loginData, id: i.roomId!)) {
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
                            .padding(.horizontal)
                        }
                    }
                }
                .navigationBarTitle("Your Active Classrooms", displayMode: .inline)
                
                Button(action: {
                    self.joinRoom.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color("theme"))
                        .padding()
                        .offset(y: -20)
                }
                
            }.popup(isPresented: self.$joinRoom, type: .`default`,animation: Animation.spring(), closeOnTap: false) {
                joinRoomDialog()
            }
        }
    }
    
    func joinRoomDialog() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            
            TextField("Class ID", text: $id)
                .autocapitalization(.none)
                .padding()
                .background(Color.black.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            HStack {
                Spacer()
                Button(action: {
                    loginData.joinRoom(id: id, name: loginData.user.name ?? " ") { (stat) in
                        if stat {
                            print("requested")
                            self.joinRoom = false
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
                        .background(Color("yellow"))
                        .cornerRadius(15)
                })
                .disabled(id == "" ? true: false)
                Spacer()
            }
        }
        .padding()
        .background(BlurBG())
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: -5)
        .padding(.horizontal, 20)
    }
}




struct studRoomDetail: View {
    
    @ObservedObject var loginData: LoginViewModel
    var id: String
    @State var ind = 0
    
    @State var isRefresh = true
    @State var offset : CGFloat = UIScreen.main.bounds.width
    var body: some View {
        
        VStack {
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    Button(action: {
                        self.ind = 0
                    }) {
                        Text("Overview")
                            .font(.system(size: 15))
                            .foregroundColor(ind == 0 ? .white : Color("text"))
                            .fontWeight(.bold)
                            .padding(.vertical,6)
                            .padding(.horizontal,10)
                            .background(Color("theme").opacity(ind == 0 ? 1 : 0))
                            .clipShape(TabBarShape())
                        
                    }
                    Button(action: {
                        self.ind = 1
                    }) {
                        Text("Resourses")
                            .font(.system(size: 15))
                            .foregroundColor(ind == 1 ? .white : Color("text"))
                            .fontWeight(.bold)
                            .padding(.vertical,6)
                            .padding(.horizontal,10)
                            .background(Color("theme").opacity(ind == 1 ? 1 : 0))
                            .clipShape(TabBarShape())
                        
                    }
                    Button(action: {
                        self.ind = 2
                    }) {
                        Text("Discussion")
                            .font(.system(size: 15))
                            .foregroundColor(ind == 2 ? .white : Color("text"))
                            .fontWeight(.bold)
                            .padding(.vertical,6)
                            .padding(.horizontal,10)
                            .background(Color("theme").opacity(ind == 2 ? 1 : 0))
                            .clipShape(TabBarShape())
                        
                    }
                    Button(action: {
                        self.ind = 3
                    }) {
                        
                        Text("Students")
                            .font(.system(size: 15))
                            .foregroundColor(ind == 3 ? .white : Color("text"))
                            .fontWeight(.bold)
                            .padding(.vertical,6)
                            .padding(.horizontal,10)
                            .background(Color("theme").opacity(ind == 3 ? 1 : 0))
                            .clipShape(TabBarShape())
                    }
                }
                
            }
            .padding(.horizontal, 5)
            .padding(.top,10)
            
            VStack {
                switch self.ind {
                case 0 :
                    Overview
                case 1 :
                    Resourses
                case 2 :
                    Discussion
                case 3 :
                    Students
                default:
                    Overview
                }
            }
            .highPriorityGesture(
                DragGesture()
                    .onEnded({ (value) in
                        
                        if value.translation.width > 50 {
                            print("right")
                            if ind > 0 && ind <= 3 {
                                withAnimation() { ind -= 1 }
                            }
                        }
                        if -value.translation.width > 50 {
                            print("left")
                            if ind >= 0 && ind < 3 {
                                withAnimation() { ind += 1 }
                            }
                        }
                    }))
            
        }
        
        .navigationBarTitle("Classroom", displayMode: .inline)
        .onAppear() {
            self.loginData.fetchData(id: id)
            self.loginData.messages(id: id)
            loginData.studentRequests(id: id)
        }
    }
    
    var Overview: some View {
        
        VStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 5){
                HStack {
                    Text("Subject").bold().foregroundColor(Color("text"))
                    Text(loginData.roomDetail.subject!).foregroundColor(Color("text"))
                }
                HStack {
                    Text("Instructor").bold().foregroundColor(Color("text"))
                    Text(loginData.roomDetail.createdBy!).foregroundColor(Color("text"))
                }
                HStack {
                    Text("Stats").bold().foregroundColor(Color("text"))
                    Text("\(loginData.roomDetail.students!.count) Students").foregroundColor(Color("text"))
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        //Live Button
                    }) {
                        Text(true ? "Class not started" : "Join Live Class")
                            .bold()
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 5)
                    }
                    .background(true ? Color.gray : Color("theme"))
                    .buttonStyle(ScaleButtonStyle())
                    .cornerRadius(10)
                    .padding(.top, 15)
                    
                    //.disabled(isLive ? )
                    Spacer()
                }
                
            }.padding()
            .background(BlurBG())
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: -5)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            
            Spacer()
        }
        .contentShape(Rectangle())
    }
    
    
    
    @State var fileName = ""
    @State var openFile = false
    @State var desc: String = ""
    @State var title = ""
    
    var Resourses: some View {
        VStack {
            Spacer()
            
            
            
            
        }
    }
    
    
    var Students: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Active Students")
                    .bold()
                    .font(.system(size: 18))
                
                Spacer()
                Text("\(loginData.roomDetail.students?.count ?? 0)")
                    .bold()
                    .padding(.horizontal)
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }.padding()
            
            if loginData.students.count != 0 {
                ForEach(loginData.students, id: \.self) { i in
                    if i.isAccepted {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(i.name).bold()
                                
                            }
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text("Joined At:").foregroundColor(.gray)
                                Text("\(i.joinedAt!.getFormattedDate(format: "MMM d, h:mm a"))").bold()
                            }
                        }.padding()
                        .background(BlurBG())
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                    }
                }
            }
            
            Spacer()
        }
        .contentShape(Rectangle())
    }
    
    
    @State var scrolled = false
    @State var txt = LoginViewModel().txt
    
    var Discussion: some View {
        
        VStack(spacing: 0){
            
            ScrollViewReader{ reader in
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(loginData.msg){ mssg in
                            ChatRow(name: loginData.user.name ?? " ", chatData: mssg)
                                .onAppear{
                                    if mssg.id == self.loginData.msg.last!.id && !scrolled{
                                        
                                        reader.scrollTo(loginData.msg.last!.id,anchor: .bottom)
                                        scrolled = true
                                    }
                                }
                        }
                        .onChange(of: loginData.msg, perform: { value in
                            reader.scrollTo(loginData.msg.last!.id,anchor: .bottom)
                        })
                    }
                    .padding(.vertical)
                }
            }
            
            
            
            HStack(spacing: 15){
                
                TextField("Enter Message", text: self.$txt)
                    .padding(.horizontal)
                    .frame(height: 45)
                    .background(Color.primary.opacity(0.06))
                    .clipShape(Capsule())
                
                if self.txt != ""{
                    
                    Button(action: {
                        loginData.writeMsg(id: id, txt: self.txt, sentBy: loginData.user.name ?? " ")
                        txt = ""
                    })  {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .frame(width: 45, height: 45)
                            .background(Color("theme"))
                            .clipShape(Circle())
                    }
                }
            }
            .animation(.default)
            .padding()
        }
        .contentShape(Rectangle())
        .ignoresSafeArea(.all, edges: .top)
    }
    
}
