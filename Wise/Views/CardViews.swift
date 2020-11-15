//
//  CardViews.swift
//  Wise
//
//  Created by NAVEEN MADHAN on 11/15/20.
//

import SwiftUI


struct TabBarShape : Shape {
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.bottomRight], cornerRadii: CGSize(width: 15, height: 15))
        return Path(path.cgPath)
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
