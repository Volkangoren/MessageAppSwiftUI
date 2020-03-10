//
//  ChatRow.swift
//  MessageAppSwiftUI
//
//  Created by Volkan on 9.03.2020.
//  Copyright © 2020 Volkan. All rights reserved.
//

import SwiftUI
import Firebase

struct ChatRow: View {
    
    var chatMessage : ChatModel
    var userToChatFromChatView : UserModel
    
    
    var body: some View {
        
        
        Group {
            if chatMessage.messageFrom == Auth.auth().currentUser?.uid && chatMessage.messageTo == userToChatFromChatView.uidFromFirebase {
                
                
                HStack {
                    Text(chatMessage.message)
                .bold()
                    .foregroundColor(.black)
                        .padding(10)
                    Spacer()
                }
            }else if chatMessage.messageTo == Auth.auth().currentUser?.uid && chatMessage.messageFrom == userToChatFromChatView.uidFromFirebase {
                
                HStack {
                    
                    
                    Spacer()
                    Text(chatMessage.message)
                .bold()
                    .foregroundColor(.black)
                        .padding(10)
                    
                }

            }else {
                
            }
            
        }.frame(width:UIScreen.main.bounds.width * 0.95)
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(chatMessage: ChatModel(id: 0, message: "deneme", uidFromFirebase: "123", messageFrom: "asdasd", messageTo: "dq", messageDate: Date(), messageFromMe: true), userToChatFromChatView: UserModel(id: 1, name: "deneme", uidFromFirebase: "kasdaskd"))
    }
}
