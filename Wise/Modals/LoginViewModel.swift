//
//  LoginViewModel.swift
//  PhoneAuth
//
//  Created by Balaji on 09/11/20.
//

import SwiftUI
import Firebase


class LoginViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    @AppStorage("phNo") var phNo = ""
    @Published var code = ""
    
    @Published var errorMsg = ""
    @Published var error = false
    
    @Published var CODE = ""
    @Published var gotoVerify = false
    
    @AppStorage("log_Status") var status = false
    @Published var loading = false
    
    @AppStorage("isTeacher") var isTeacher = false
    @Published var user: User = User(id: "", dp: "", isTeacher: false, name: "", phone: "", rooms: [String]())
    
    //MARK:- LOGIN
    func getCountryCode() ->String {
        
        let regionCode = "IN"
        return countries[regionCode] ?? ""
    }
    
    
    func sendCode(){
        
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        let number = "+\(getCountryCode())\(phNo)"
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (CODE, err) in
            
            if let error = err{
                
                self.errorMsg = error.localizedDescription
                withAnimation{ self.error.toggle()}
                return
            }
            
            self.CODE = CODE ?? ""
            self.gotoVerify = true
        }
    }
    
    func verifyCode(completion : @escaping (Bool)-> Void){
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.CODE, verificationCode: code)
        loading = true
        
        Auth.auth().signIn(with: credential) { (result, err) in
            self.loading = false
            
            if let error = err{
                self.errorMsg = error.localizedDescription
                withAnimation{ self.error.toggle() }
                completion(false)
            }
            //withAnimation{ self.status = true }
        }
        completion(true)
    }
    
    func requestCode() {
        sendCode()
        
        withAnimation{
            self.errorMsg = "Code Sent Successfully!"
            self.error.toggle()
        }
    }
    
    func checkUser(completion : @escaping (Bool)-> Void) {
        
        let docRef = db.collection("users").document(phNo)
        docRef.getDocument { (document, error) in
            if document!.exists {
                print("Document data: \(document!.data()!)")
                
                document.map { (QueryDocumentSnapshot) -> Void in
                    let data = QueryDocumentSnapshot.data()
                    
                    self.isTeacher = (data!["isTeacher"] as? Bool? ?? false)!
                    print(self.isTeacher)
                }
                completion(true)
            } else {
                print("Document does not exist")
                completion(false)
            }
        }
    }
    
    func getUser() {
        db.collection("users")
            .document(phNo)
            .addSnapshotListener { (document, error) in
                if error == nil {
                    if document != nil && document!.exists {
                        do {
                            let data = try document?.data(as: User.self)
                            self.user = data!
                        } catch {
                            print("Error decoding JSON: \(error)")
                        }
                        
                    }
                }
            }
    }
    
    func createUser(name: String, isTeacher: Bool, imagedata: Data, completion : @escaping (Bool)-> Void) {
        
        let storage = Storage.storage().reference()
        let uid = Auth.auth().currentUser?.uid
        loading = true
        storage.child("profilepics").child(uid!).putData(imagedata, metadata: nil) { (_, err) in
            
            if err != nil{
                print((err?.localizedDescription)!)
                completion(false)
            }
            
            storage.child("profilepics").child(uid!).downloadURL { (url, err) in
                
                if err != nil{
                    print((err?.localizedDescription)!)
                    completion(false)
                }
                
                self.db.collection("users").document(String(self.phNo)).setData(["name":name, "isTeacher":isTeacher, "dp":"\(url!)", "rooms": [String](), "phone": self.phNo]) { (err) in
                    
                    if err != nil {
                        print((err?.localizedDescription)!)
                        completion(false)
                    }
                    
                    completion(true)
                }
            }
        }
    }
    
    
    
    deinit {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    //MARK: - ROOMS
    @Published var rooms: [Rooms] = []
    @Published var msg: [Msg] = []
    
    private var listenerRegistration: ListenerRegistration?
    
    @Published var roomDetail: Rooms = Rooms(id: "", createdAt: Date(), createdBy: "", roomId: "", roomName: "", subject: "")
    
    
    
    func roomList() {
        let docRef = db.collection("Rooms").whereField("createdBy", isEqualTo: phNo)
        
        docRef.addSnapshotListener { (querySnapshot, err) in
            guard let docs = querySnapshot?.documents else { return }
            
            self.rooms = docs.compactMap { (queryDocumentSnapshot) -> Rooms? in
                return try? queryDocumentSnapshot.data(as: Rooms.self)
            }
        }
    }
    
    @Published var students: [Attendence] = []
    func studentRequests(id: String) {
        let docRef = db.collection("Rooms/\(id)/Attendence")
        
        docRef.addSnapshotListener { (querySnapshot, err) in
            guard let docs = querySnapshot?.documents else { return }
            
            self.students = docs.compactMap { (queryDocumentSnapshot) -> Attendence? in
                return try? queryDocumentSnapshot.data(as: Attendence.self)
            }
        }
    }
    
    func deleteRequest(id: String, stud: String) {
        let docRef = db.collection("Rooms/\(id)/Attendence").document(stud)
        
        docRef.delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
    }
    
    func AcceptRequest(id: String, stud: String) {
        let docRef = db.collection("Rooms/\(id)/Attendence").document(stud)
        
        docRef.updateData([
            "isAccepted": true,
            "joinedAt": Date()
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }

    }
    
    func fetchData(id: String) {
        db.collection("Rooms")
            .document(id)
            .addSnapshotListener { (document, error) in
                if error == nil {
                    if document != nil && document!.exists {
                        do {
                            let data = try document?.data(as: Rooms.self)
                            self.roomDetail = data!
                            print(self.roomDetail)
                        } catch {
                            print("Error decoding JSON: \(error)")
                        }
                        
                    }
                }
            }
    }
    
    //MARK: CREATE ROOMS (T)
    func createRoom(rname: String, rsubj: String, code: String){
        
        let docData: [String: Any] = [
            "createdBy" : self.phNo,
            "createdAt" : Date(),
            "roomId" : code,
            "roomName" : rname,
            "subject" : rsubj,
        ]
        
        db.collection("Rooms").document(code).setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
                return
            } else {
                self.db.collection("users")
                    .document(self.phNo).updateData([ "rooms": FieldValue.arrayUnion([code]) ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                        return
                    } else {
                        print("Document successfully updated")
                    }
                }
            }
        }
    }
    
    //MARK: JOIN ROOMS (S)
    func joinRoom(id: String, name: String, completion : @escaping (Bool)-> Void) {
        
        let param: Attendence = Attendence(isAccepted: false, name: name, phone: self.phNo)
        
        let _ = try!  db.collection("Rooms/\(id)/Attendence").addDocument(from: param) { (err) in
            
            if err != nil{
                print(err!.localizedDescription)
                completion(false)
                return
            }
            
            self.db.collection("users")
                .document(self.phNo).updateData([ "rooms": FieldValue.arrayUnion([id]) ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                    completion(false)
                    return
                } else {
                    print("Document successfully updated")
                    completion(true)
                }
            }

            completion(true)
            
        }
    }
    
    //MARK: MESSAGES
    @State var txt = ""
    func messages(id: String) {
        print(id)
        self.msg = []
        db.collection("Rooms/\(id)/Messages").order(by: "sentAt", descending: false).addSnapshotListener { (querySnapshot, err) in
            guard let docs = querySnapshot?.documents else { return }
            
            self.msg = docs.compactMap { (queryDocumentSnapshot) -> Msg? in
                return try? queryDocumentSnapshot.data(as: Msg.self)
                
            }
        }
    }
    

    
    func writeMsg(id: String, txt: String, sentBy: String){
        print(self.user)
        let msg = Msg(isTeacher: self.isTeacher, sentBy: sentBy , sentAt: Date(), text: txt )
        
        let _ = try! db.collection("Rooms/\(id)/Messages").addDocument(from: msg) { (err) in
            
            if err != nil{
                print(err!.localizedDescription)
                return
            }
 
        }
        
        self.txt = ""
    }
    
    //MARK: UPLOAD ATTACHMENTS (T)
    func uploadResource(data: URL, id: String, desc: String, title: String, sentBy: String, completion : @escaping (Bool)-> Void) {
        let storage = Storage.storage().reference()
        let uid = Auth.auth().currentUser?.uid
        
        storage.child("resources").child(uid!).putFile(from: data, metadata: nil) { (_, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                completion(false)
                return
            }
            
            storage.child("resources").child(uid!).downloadURL { (url, err) in
                if err != nil {
                    print((err?.localizedDescription)!)
                    completion(false)
                    return
                }
            }
        }
        
        storage.child("resources").child(uid!).downloadURL { (url, err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                completion(false)
                return
            }
            
            let param: Attachments = Attachments(sentAt: Date(), desc: desc, docUrl: data.absoluteString, sentBy: sentBy, title: title)
            let _ = try! self.db.collection("Rooms/\(id)/Attachments").addDocument(from: param) { (err) in
                
                if err != nil{
                    print(err!.localizedDescription)
                    return
                }
                completion(true)
     
            }
            
            
        
        }
    }
    
    
    
}



