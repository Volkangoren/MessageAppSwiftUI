//
//  ChatStore.swift
//  MessageAppSwiftUI
//
//  Created by Volkan on 9.03.2020.
//  Copyright © 2020 Volkan. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

class ChatStore : ObservableObject {
    
    let db = Firestore.firestore()
    var chatArray : [ChatModel] = []
    
    var objectWillChange = PassthroughSubject<Array<Any>, Never>()
    
    
    init() {
        db.collection("Chat").whereField("chatUserFrom", isEqualTo: Auth.auth().currentUser!.uid).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            }else {
                self.chatArray.removeAll(keepingCapacity: false)
                for document in snapshot!.documents {
                    let chatUidFromFirebase = document.documentID
                    if let chatMessage = document.get("message") as? String {
                        if let messageFrom = document.get("chatUserFrom") as? String {
                            if let messageTo = document.get("chatUserTo") as? String {
                                if let dateString = document.get("date") as? String {
                                    let formatter = DateFormatter()
                                           formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
                                    let dateFromFirebase = formatter.date(from:  dateString)
                                    
                                    let currentIndex = self.chatArray.last?.id
                                    
                                    let createdChat = ChatModel(id: (currentIndex ?? -1) + 1, message: chatMessage, uidFromFirebase: chatUidFromFirebase, messageFrom: messageFrom, messageTo: messageTo, messageDate: dateFromFirebase!, messageFromMe: true)
                                    
                                    self.chatArray.append(createdChat)
                                }
                            }
                        }
                    }
                }
                
                self.db.collection("Chat").whereField("chatUserTo", isEqualTo: Auth.auth().currentUser!.uid).addSnapshotListener { (snapshot, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                    }else {
                        
                        for document in snapshot!.documents {
                            let chatUidFromFirebase = document.documentID
                            if let chatMessage = document.get("message") as? String {
                                if let messageFrom = document.get("chatUserFrom") as? String {
                                    if let messageTo = document.get("chatUserTo") as? String {
                                        if let dateString = document.get("date") as? String {
                                            let formatter = DateFormatter()
                                                   formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
                                            let dateFromFirebase = formatter.date(from:  dateString)
                                            
                                            let currentIndex = self.chatArray.last?.id
                                            
                                            let createdChat = ChatModel(id: (currentIndex ?? -1) + 1, message: chatMessage, uidFromFirebase: chatUidFromFirebase, messageFrom: messageFrom, messageTo: messageTo, messageDate: dateFromFirebase!, messageFromMe: true)
                                            
                                            self.chatArray.append(createdChat)
                                        }
                                    }
                                }
                            }
                        }
                        self.chatArray = self.chatArray.sorted(by: {
                            $0.messageDate.compare($1.messageDate) == .orderedDescending
                        })
                        self.objectWillChange.send(self.chatArray)
                    }
                }
                
                
            }
        }
        
    }
    
}
