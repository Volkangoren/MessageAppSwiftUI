//
//  UserStore.swift
//  MessageAppSwiftUI
//
//  Created by Volkan on 8.03.2020.
//  Copyright © 2020 Volkan. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

class UserStore : ObservableObject{
    
    let db = Firestore.firestore()
    var user : [UserModel] = []
    
    var objectWillChange = PassthroughSubject<Array<Any> , Never>()
    
    
    init() {
        
        db.collection("Users").addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
                
            }else {
                
                self.user.removeAll(keepingCapacity: false)
                
                for document in snapshot!.documents{
                    
                    if let userUidFromFirebase = document.get("UserIdFromFireBase") as? String {
                        
                        if let userName = document.get("username") as? String {
                            let currentIndex = self.user.last?.id
                            
                            let createdUser = UserModel(id: (currentIndex ?? -1) + 1, name: userName, uidFromFirebase: userUidFromFirebase)
                            self.user.append(createdUser)
                        }
                    }
                }
                self.objectWillChange.send(self.user)
            }
        }
        
    }
    
    
    
}
