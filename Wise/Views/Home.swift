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
        loginData.getUser()
        loginData.roomList()
        print(loginData.rooms)
    }
    @State var tab = 0
    
    var body: some View {
        ZStack {
            
            Color("primaryBG").edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0){
                
                if self.tab == 0 {
                    if loginData.isTeacher {
                        Student(loginData: self.loginData)
                    } else {
                        Student(loginData: self.loginData)
                    }
                } else {
                    VStack {
                        Spacer()
                        Button(action: {
                            try? Auth.auth().signOut()
                            withAnimation{ status = false }
                        }, label: {
                            Text("LogOut")
                                .fontWeight(.heavy)
                        })
                        Spacer()
                    }
                }
                
//                ZStack(alignment: .bottom){
//                    HStack{
//                        Button(action: {
//                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
//                            withAnimation() {
//                                self.tab = 0
//                            }
//                        }) {
//                            HStack {
//                                Image(systemName: "house.circle.fill")
//                                    .resizable()
//                                    .foregroundColor(self.tab == 0 ? Color("tabOn") : Color("tabOff"))
//                                    .frame(width: 30, height: 30)
//
//                                if self.tab == 0 {
//                                    Text("Home")
//                                        .padding(.vertical, 7)
//                                        .padding(.horizontal, 10)
//                                        .foregroundColor(Color("primaryBG"))
//                                        .background(Color("text"))
//                                        .clipShape(RoundedRectangle(cornerRadius: 30.0))
//                                }
//                            }
//                        }
//                        Spacer(minLength: 1)
//
//                        Button(action: {
//                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
//                            withAnimation() {
//                                self.tab = 1
//                            }
//                        }) {
//                            HStack {
//                                Image(systemName: "grid.circle.fill")
//                                    .resizable()
//                                    .frame(width: 30, height: 30)
//                                    .foregroundColor(self.tab == 1 ? Color("tabOn") : Color("tabOff"))
//
//                                if self.tab == 1 {
//                                    Text("Account")
//                                        .padding(.vertical, 7)
//                                        .padding(.horizontal, 10)
//                                        .foregroundColor(Color("primaryBG"))
//                                        .background(Color("text"))
//                                        .clipShape(RoundedRectangle(cornerRadius: 30.0))
//
//                                }
//                            }
//                        }
//
//                    }
//                    .padding(.horizontal, 15)
//                    .padding(.top,10)
//                    .padding(.bottom, 10)
//                    .background(BlurBG())
//                    .clipShape(Capsule())
//                    .frame(width: UIScreen.main.bounds.width - 200, alignment: .center)
//                    .offset(y: -25)
//                }.edgesIgnoringSafeArea(.bottom)
                
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
                    .background(Color("yellow"))
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Enter a class ID given by your teacher to enroll in a class.").bold().lineLimit(2).padding(5).font(.title3)
                        
                        TextField("Class ID", text: $id)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.black.opacity(0.06))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        HStack {
                            Button(action: {
                                print("enroll")
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
                            
                            Button(action: {
                                print("Or Invite Teacher")
                            }, label: {
                                
                                Text("Or Invite Teacher")
                                    .font(.title3)
                                    .foregroundColor(Color("yellow"))
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
            } else {
                ClassroomView(loginData: self.loginData)
            }
        }
        
    }
}



struct ClassroomView: View {
    
    @ObservedObject var loginData: LoginViewModel
    @State var createRoom = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(self.loginData.rooms) { i in
                        NavigationLink(destination: RoomDetail(loginData: loginData, id: i.roomId!)) {
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
                .navigationBarTitle("Your Active Classrooms")
                
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
    }
}

struct createRoom: View {
    
    @Binding var show: Bool
    @ObservedObject var loginData: LoginViewModel
    @State var roomName: String = ""
    @State var desc: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.show.toggle()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
            }.padding()
            
            TextField("Room Name", text: self.$roomName)
                .padding()
                .background(BlurBG())
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(15)
            
            
            TextField("Subject / Description", text: self.$desc)
                .padding()
                .background(BlurBG())
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(15)
            
            Button(action: {
                loginData.createRoom(rname: self.roomName, rsubj: self.desc, code: "ofbb1")
                self.show.toggle()
            }, label: {
                Text("Create Room")
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width - 30,height: 50)
                    .buttonStyle(ScaleButtonStyle())
                    .background(Color("yellow"))
                    .cornerRadius(15)
            })
            .disabled(self.desc == "" && self.roomName == "" ? true: false)
            
            Spacer()
            
        }
    }
    
}


struct classCard: View {
    
    @State var name: String
    @State var time: Date
    @State var subj: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            Text(self.name).bold().padding(3).foregroundColor(Color("text"))
            Divider()
            Text(self.subj).padding(.horizontal, 5).foregroundColor(Color("text"))
            Text("\(self.time)").padding(.horizontal, 5).foregroundColor(Color("text"))
            
        }
        .frame(height: UIScreen.main.bounds.height / 7, alignment: .center)
        .background(BlurBG())
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: -5)
        .cornerRadius(20)
    }
}


struct RoomDetail: View {
    
    @ObservedObject var loginData: LoginViewModel
    var id: String
    @State var ind = 0
    
    @State var isRefresh = true
    @State var offset : CGFloat = UIScreen.main.bounds.width
    var body: some View {
        
        VStack {
            
            ScrollView(.horizontal, showsIndicators: false){
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
                        Text("Attendance")
                            .font(.system(size: 15))
                            .foregroundColor(ind == 3 ? .white : Color("text"))
                            .fontWeight(.bold)
                            .padding(.vertical,6)
                            .padding(.horizontal,10)
                            .background(Color("theme").opacity(ind == 3 ? 1 : 0))
                            .clipShape(TabBarShape())
                    }
                    Button(action: {
                        self.ind = 4
                    }) {
                        
                        Text("Students")
                            .font(.system(size: 15))
                            .foregroundColor(ind == 4 ? .white : Color("text"))
                            .fontWeight(.bold)
                            .padding(.vertical,6)
                            .padding(.horizontal,10)
                            .background(Color("theme").opacity(ind == 4 ? 1 : 0))
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
                Attendance
            case 4 :
                Students
            default:
                Overview
            }
            }
            .highPriorityGesture(DragGesture()
            .onEnded({ (value) in
                
                if value.translation.width > 50 {
                    print("right")
                    if ind > 0 && ind <= 4 {
                        withAnimation() { ind -= 1 }
                    }
                    
                }
                if -value.translation.width > 50 {
                    print("left")
                    if ind >= 0 && ind < 4 {
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
                    Text("Timings").bold().foregroundColor(Color("text"))
                    Text("PlaceHolder").foregroundColor(Color("text"))
                }
                HStack {
                    Text("Stats").bold().foregroundColor(Color("text"))
                    Text("PlaceHolder").foregroundColor(Color("text"))
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        //Live Button
                    }) {
                        Text("Go Live")
                            .bold()
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .center)
                    }
                    .background(Color("theme"))
                    .buttonStyle(ScaleButtonStyle())
                    .cornerRadius(30)
                    .padding(.top, 15)
                    
                    Spacer()
                }
                
            }.padding()
            .background(BlurBG())
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: -5)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            
            Text("Classroom ID").foregroundColor(.gray)
            Text(id.uppercased()).bold().font(.system(size: 24)).foregroundColor(Color("text"))
            
            Button(action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                //Live Button
            }) {
                Text("Invite Students")
                    .bold()
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .padding()
            }
            .background(Color("theme"))
            .cornerRadius(15)
            .padding(.top, 15)
            
            Spacer()
        }
    }
    
    
    
    @State var fileName = ""
    @State var openFile = false
    @State var desc: String = ""
    @State var title = ""
    
    var Resourses: some View {
        VStack {
            Spacer()
            Text(fileName)
            
            Button { openFile.toggle() } label: {
                Text("Add Resources")
                    .bold()
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .padding()
            }
            .background(Color("theme"))
            .cornerRadius(15)
            .padding(.top, 15)
            .fileImporter(isPresented: $openFile, allowedContentTypes: [.pdf, .png, .jpeg]) { (res) in
                do {
                    let fileUrl = try res.get()
                    self.fileName = fileUrl.lastPathComponent
                    loginData.uploadResource(data: fileUrl, id: id, desc: "test", title: "test", sentBy: loginData.user.name ?? " ") { (stat) in
                        if stat {
                            print("DONE")
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }

        }
    }
    
    
    
    
    
    var Attendance: some View {
        VStack(alignment: .leading) {
            Text("Pending Requests")
                .bold()
                .font(.system(size: 18))
                .padding()
            
            if loginData.students.count != 0 {
                ForEach(loginData.students, id: \.self) { i in
                    if !i.isAccepted {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(i.name).bold()
                                Text(i.phone).foregroundColor(.gray)
                            }
                            Spacer()
                            
                            Button(action: {
                                loginData.AcceptRequest(id: id, stud: i.phone)
                            }) {
                                Image(systemName: "plus.circle.fill").font(.title).foregroundColor(.green)
                            }
                            
                            Button(action: {
                                loginData.deleteRequest(id: id, stud: i.phone)
                            }) {
                                Image(systemName: "xmark.circle.fill").font(.title).foregroundColor(.red)
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
    }
    
    
    
    
    var Students: some View {
        VStack(alignment: .leading) {
            HStack {
            Text("Active Students")
                .bold()
                .font(.system(size: 18))
                
                Spacer()
                Text("\(loginData.students.count)")
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
                                Text("Joined: \(i.joinedAt!.getFormattedDate(format: "MMM d, h:mm a"))").foregroundColor(.gray)
                            }
                            Spacer()
                            
                            Button(action: {
                                loginData.deleteRequest(id: id, stud: i.phone)
                            }) {
                                Image(systemName: "xmark.circle.fill").font(.title).foregroundColor(.red)
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
        .ignoresSafeArea(.all, edges: .top)
    }
    
}








struct ChatRow: View {
    var name: String
    var chatData : Msg
    var body: some View {
        
        HStack(spacing: 15){
            
            if chatData.sentBy == name { Spacer(minLength: 0) }
            
            VStack(alignment: chatData.sentBy == name ? .trailing : .leading, spacing: 5, content: {
                
                Text(chatData.text)
                    .fontWeight(.regular)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(chatData.isTeacher ? .gray : Color("theme"))
                    
                    .clipShape(ChatBubble(myMsg: chatData.sentBy == name))
                    .contentShape(ChatBubble(myMsg: chatData.sentBy == name))
                    .contextMenu{
                        VStack {
                            Text(chatData.sentBy.capitalized)
                                .fontWeight(.bold)
                            Text(chatData.sentAt.getFormattedDate(format: "MMM d, h:mm a"))
                        }
                    }
                Text(chatData.isTeacher ? "\(chatData.sentAt.getFormattedDate(format: "h:mm a")) ~ Teacher" : chatData.sentAt.getFormattedDate(format: "h:mm a"))
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(chatData.sentBy != name ? .leading : .trailing , 10)
            })
            
            if chatData.sentBy != name { Spacer(minLength: 0) }
        }
        .padding(.horizontal)
        .id(chatData.id)
        
    }
}

extension View {
    public func flip() -> some View {
        return self
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .bottom)
    }
}





//MARK:- LOG OUT
/*
 
 */

struct TabBarShape : Shape {
     
     func path(in rect: CGRect) -> Path {
         let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.bottomRight], cornerRadii: CGSize(width: 15, height: 15))
         return Path(path.cgPath)
     }
 }
 
