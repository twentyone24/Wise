//
//  TeacherView.swift
//  Wise
//
//  Created by NAVEEN MADHAN on 11/15/20.
//

import SwiftUI


struct TeacherView: View {
    
    @ObservedObject var loginData: LoginViewModel
    @State var id: String = ""
    @State var createRoom = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
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
                        Spacer()
                        Text("You haven't created any classes yet.").bold().padding(5).font(.title3)
                        Spacer()
                    }
                    
                    Spacer()
                }
                
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
            } else {
                ClassroomView(loginData: self.loginData)
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
                loginData.createRoom(rname: self.roomName, rsubj: self.desc, code: "ofcb1")
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

struct uploadDocument: View {
    
    @Binding var show: Bool
    @ObservedObject var loginData: LoginViewModel
    @State var title: String = ""
    @State var desc: String = ""
    @State var openFile = false
    @State var id: String
    
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
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Title").padding(.horizontal)
                TextField("title", text: self.$title)
                    .padding()
                    .background(BlurBG())
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 15)
                
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Description").padding(.horizontal)
                TextField("Description", text: self.$desc)
                    .padding()
                    .background(BlurBG())
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 15)
            }
            
            Button { openFile.toggle() } label: {
                Text("Add Attachments")
                    .bold()
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .padding()
            }
            .background(Color("theme"))
            .cornerRadius(15)
            .padding(15)
            .fileImporter(isPresented: $openFile, allowedContentTypes: [.pdf, .png, .jpeg]) { (res) in
                do {
                    let fileUrl = try res.get()
                    loginData.uploadResource(data: fileUrl, id: id, desc: desc, title: title, sentBy: loginData.user.name ?? " ") { (stat) in
                        if stat {
                            self.show.toggle()
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            Spacer()
            
        }
    }
    
}


struct teacherRoomDetail: View {
    
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
            .highPriorityGesture(
                DragGesture()
                    .onEnded({ (value) in
                        
                        if value.translation.width > 50 {
                            if ind > 0 && ind <= 4 {
                                ind -= 1
                            }
                            
                        }
                        if -value.translation.width > 50 {
                            if ind >= 0 && ind < 4 {
                                ind += 1
                            }
                        }
                    }))
        }
        
        .navigationBarTitle("Classroom", displayMode: .inline)
        .onAppear() {
            self.loginData.fetchData(id: id)
            self.loginData.messages(id: id)
            self.loginData.studentRequests(id: id)
            self.loginData.getResources(id: id)
        }
    }
    
    @State private var isShareSheetShowing = false
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
                shareButton()
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
        .contentShape(Rectangle())
    }
    
    func shareButton() {
        
        isShareSheetShowing.toggle()
        
        let text = """
            You have been invited by () to join their classroom.

            Download the Wise App at
            https://studant.in

            Enroll in classroom by entering,
            Classroom ID: \(id)
        """
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        
    }
    
    
    @State var openFile = false
    
    var Resourses: some View {
        VStack {
            if loginData.resources.count != 0 {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(loginData.resources, id: \.self) { i in
                        NavigationLink(destination: ResourceDetail(doc: i)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(i.title!).bold()
                                    
                                }
                                Spacer()
                                
                                VStack(alignment: .leading) {
                                    Text("Added At:").foregroundColor(.gray)
                                    Text("\(i.sentAt!.getFormattedDate(format: "MMM d, h:mm a"))").bold()
                                }
                            }.padding()
                            .background(BlurBG())
                            .cornerRadius(15)
                            .padding(.horizontal)
                        }
                    }
                }
                
            }
            Spacer()
            
            Button { openFile.toggle() } label: {
                Text("Add Resources")
                    .bold()
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .padding()
            }
            .background(Color("theme"))
            .cornerRadius(15)
            .padding(15)
        }
        .contentShape(Rectangle())
        .fullScreenCover(isPresented: self.$openFile) {
            Wise.uploadDocument(show: self.$openFile, loginData: loginData, id: id)
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
        .contentShape(Rectangle())
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
                                Text("Joined: \(i.joinedAt!.getFormattedDate(format: "MMM d, h:mm a"))").foregroundColor(.gray)
                            }
                            Spacer()
                            
                            Button(action: {
                                loginData.deleteStud(id: id, stud: i.phone)
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


struct ResourceDetail: View {
    
    @State var doc: Attachments
    @State var openFile = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Title").padding(.horizontal)
                Text(doc.title!)
                    .bold()
                    .padding()
                    .background(BlurBG())
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 15)
                
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Description").padding(.horizontal)
                Text(doc.desc!)
                    .bold()
                    .padding()
                    .background(BlurBG())
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 15)
                
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Uploaded At").padding(.horizontal)
                Text("\(doc.sentAt!.getFormattedDate(format: "MMM d, h:mm a"))")
                    .bold()
                    .padding()
                    .background(BlurBG())
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 15)
                
            }
            
            Spacer()
            
            Button(action: {
                self.openFile.toggle()
            }, label: {
                Text("Open Document")
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width - 30,height: 50)
                    .buttonStyle(ScaleButtonStyle())
                    .background(Color("yellow"))
                    .cornerRadius(15)
            })
            .fullScreenCover(isPresented: self.$openFile) {
//                VStack {
//                HStack {
//                    Button(action: {
//                        self.openFile.toggle()
//                    }) {
//                        Image(systemName: "arrow.left")
//                            .font(.title2)
//                            .foregroundColor(.black)
//                    }
//                    Spacer()
//                }.padding()
                PDFProvider(openFile: self.$openFile, pdfUrlString: doc.docUrl!)
                    //PDFKitView(url: Foundation.URL(string: doc.docUrl!))
                //}
            }
            
            Spacer()
            
        }.padding()
    }
    
}
