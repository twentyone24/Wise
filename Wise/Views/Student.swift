//
//  Student.swift
//  Wise
//
//  Created by NAVEEN MADHAN on 11/15/20.
//

import BottomSheet
import SwiftUI

struct studentRoom: View {
    
    @ObservedObject var loginData: LoginViewModel
    @State var joinRoom = false
    @State var id = ""
    @State var menu = false
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
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
                            }.disabled(joinRoom)
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
                        self.id = ""
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
                    
                    
                   
                }.onTapGesture {
                    UIApplication.shared.endEditing() }
                .popup(isPresented: self.$joinRoom, type: .`default`,animation: Animation.spring(), closeOnTap: false, closeOnTapOutside: true) {
                    joinRoomDialog()
                }
            }
            
            //nLottieHUD(fileName: "confetti" )
                
            .popup(isPresented: $loginData.HUD, type: .floater(), position: .top, animation: Animation.spring(), autohideIn: 2) {
                msgHUD(msg: loginData.HUDMsg)
            }
            
        }
        .bottomSheet(isPresented: self.$menu, height: UIScreen.main.bounds.height /  2) {
            SideMenu(loginData: loginData)
        }
    }
    
    func joinRoomDialog() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            
            TextField("Class ID", text: $id)
                .textCase(.uppercase)
                .padding()
                .background(Color.black.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            HStack {
                Spacer()
                Button(action: {
                    loginData.joinRoom(id: id, name: loginData.user.name ?? " ") { (stat) in
                        if stat {
                            print("requested")
                            UIApplication.shared.endEditing()
                            self.joinRoom = false
                        }
                        else { print("err") }
                    }
                }, label: {
                    Text("Enroll")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.vertical,13)
                        .padding(.horizontal,28)
                        .buttonStyle(ScaleButtonStyle())
                        .background(Color("theme"))
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
        .onDisappear() {
            UIApplication.shared.endEditing()
            self.id = ""
        }
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
                        
                        Text("Assessments")
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
                    Assessments
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
            self.loginData.getAssessments(id: id)
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
                
            } else {
                VStack(alignment: .center, spacing: 5) {
                    Spacer()
                    LottieView(fileName: "no" ).frame( height: UIScreen.main.bounds.height / 2)
                    Text("NO RESOURCES ADDED").bold().foregroundColor(.gray).offset(y: -70)
                    Spacer()
                }
            }
            
            Spacer()
        }.contentShape(Rectangle())
    }
    
    var Assessments: some View {
        VStack(alignment: .leading) {
            
            if loginData.assessments.count != 0 {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(loginData.assessments, id: \.self) { i in
                        NavigationLink(destination: AssesDetail(id: id, loginData: loginData,doc: i)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(i.title).bold()
                                    
                                }
                                Spacer()
                                
                                VStack(alignment: .leading) {
                                    Text("Due:").foregroundColor(.gray)
                                    Text(
                                        i.submTime < Date() ? "ENDED" : "\(i.submTime.getFormattedDate(format: "MMM d, h:mm a"))"
                                    ).bold().foregroundColor(i.submTime < Date() ? .red : .green)
                                }
                            }.padding()
                            .background(BlurBG())
                            .cornerRadius(15)
                            .padding(.horizontal)
                        }
                    }
                }
            } else {
                VStack(alignment: .center, spacing: 5) {
                    Spacer()
                    LottieView(fileName: "no" ).frame( height: UIScreen.main.bounds.height / 2)
                    Text("NO ASSESSMENTS DUE").bold().foregroundColor(.gray).offset(y: -70)
                    Spacer()
                }
            }
            Spacer()
        }.contentShape(Rectangle())
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
                    .background(BlurBG())
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


struct AssesDetail: View {
    
    @State var id: String
    @ObservedObject var loginData: LoginViewModel
    @State var doc: Assessments
    @State var openFile = false
    @State var showSubmit = false
    @State var add = false
    @State var studAttach = false
    var body: some View {
            VStack {
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(doc.title)
                            .font(.title)
                            .bold()
                        //.padding()
                        
                        Text("Assigned on").font(.caption).foregroundColor(.gray)
                        Text("\(doc.addedAt.getFormattedDate(format: "MMM d, h:mm a"))")
                            .font(.caption)
                            .bold()
                            .background(BlurBG())
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        
                    }.padding()
                    .onAppear() { loginData.checkAssessment(id: id, docID: doc.id!) }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Due:").font(.caption).foregroundColor(.gray)
                        Text(
                            doc.submTime < Date() ? "ENDED" : "\(doc.submTime.getFormattedDate(format: "MMM d, h:mm a"))"
                        ).bold().foregroundColor(doc.submTime < Date() ? .red : .green)
                    }.padding(.horizontal, 15)
                    
                }.padding(.horizontal, 15)
                
                Text("Description").bold().font(.caption)
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text(doc.desc!)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 15))
                        .padding(10)
                    
                }
                
                .frame(width: UIScreen.main.bounds.width - 50)
                .background(BlurBG().cornerRadius(10))
                //.padding(1.2)
               // .background(Color.gray.cornerRadius(10))
                
                if doc.docUrl != nil {
                    Capsule()
                        .frame(width: UIScreen.main.bounds.width - 50, height: 1.5, alignment: .center).foregroundColor(.yellow).padding(.top)
                    Button(action: {
                        self.openFile.toggle()
                    }, label: {
                        Text("REFER ATTACHMENTS")
                            .bold()
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width - 50,height: 50)
                            .buttonStyle(ScaleButtonStyle())
                            .background(Color("theme"))
                            .cornerRadius(15)
                    })
                    .fullScreenCover(isPresented: self.$openFile) {
                        PDFProvider(openFile: self.$openFile, pdfUrlString: doc.docUrl!)
                    }
                    
                    Capsule()
                        .frame(width: UIScreen.main.bounds.width - 50, height: 1.5, alignment: .center).foregroundColor(.yellow).padding(.bottom)
                }
                
                Spacer()
                
                Button(action: {
                    self.showSubmit.toggle()
                }, label: {
                    Text("YOUR ASSESSMENT")
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 50,height: 50)
                        .buttonStyle(ScaleButtonStyle())
                        .background(Color("theme"))
                        .cornerRadius(15)
                })
                
            }
            
            .bottomSheet(isPresented: self.$showSubmit, height: UIScreen.main.bounds.height / 3, showTopIndicator: true) {
                VStack {
                    
                    if loginData.submission.docUrl != "" {
                            VStack {
                                HStack {
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Text("OUT OF \(doc.maxMarks!)").foregroundColor(.gray).font(.caption)
                                        if loginData.submission.isGraded {
                                            Text("\(loginData.submission.marks!)").bold().foregroundColor(.green)
                                            
                                        } else {
                                            Text("TURNED IN").bold().foregroundColor(.gray)
                                        }
                                    }
                                }.padding()
                                Spacer()
                                Button(action: {
                                    self.studAttach.toggle()
                                }, label: {
                                    Text("REVIEW SUBMISSION")
                                        .bold()
                                        .foregroundColor(.white)
                                        .frame(width: UIScreen.main.bounds.width - 50,height: 50)
                                        .buttonStyle(ScaleButtonStyle())
                                        .background(Color("theme"))
                                        .cornerRadius(15)
                                })
                                .fullScreenCover(isPresented: self.$studAttach) {
                                    PDFProvider(openFile: self.$studAttach, pdfUrlString: loginData.submission.docUrl!)
                                }
                                Spacer()
                                
                            }.padding()
                           
                        
                    } else {
                        HStack {
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("Due").font(.caption).foregroundColor(.gray)
                                Text("\(doc.submTime.getFormattedDate(format: "MMM d, h:mm a"))"
                                ).bold().foregroundColor( .red)
                            }.padding(.horizontal, 15)
                            
                        }.padding(.horizontal, 15)
                        Spacer()
                        if doc.submTime < Date() {
                            Text("YOU CANNOT SUBMIT YOUR ASSIGNMENT NOW.").bold()
                                .foregroundColor(.red).padding(.horizontal).multilineTextAlignment(.center)
                            Button(action: {}, label: {
                                Text("SUBMIT ASSESMENT")
                                    .bold()
                                    .foregroundColor(.gray)
                                    .frame(width: UIScreen.main.bounds.width - 50,height: 50)
                                    .buttonStyle(ScaleButtonStyle())
                                    .background(BlurBG())
                                    .cornerRadius(15)
                            }).disabled(true)
                            .padding(15)
                        } else {
                            if loginData.loading{ ProgressView() }
                            else {
                                Button(action: {
                                    self.add.toggle()
                                }, label: {
                                    Text("SUBMIT ASSESMENT")
                                        .bold()
                                        .foregroundColor(.white)
                                        .frame(width: UIScreen.main.bounds.width - 50,height: 50)
                                        .buttonStyle(ScaleButtonStyle())
                                        .background(Color("theme"))
                                        .cornerRadius(15)
                                })
                                .padding(15)
                                .fileImporter(isPresented: $add, allowedContentTypes: [.pdf, .png, .jpeg]) { (res) in
                                    do {
                                        let fileUrl = try res.get()
                                        loginData.submitAssessments(id: id, docID: doc.id!, data: fileUrl, name: loginData.user.name ?? " ") { (stat) in
                                            if stat {
                                                self.showSubmit.toggle()
                                            }
                                        }
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    
                    
                    
                }
            }
        
    }
}




