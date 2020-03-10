//
//  ContentView.swift
//  MessageAppSwiftUI
//
//  Created by Volkan on 5.03.2020.
//  Copyright © 2020 Volkan. All rights reserved.
//

import SwiftUI
import Firebase

struct AuthView: View {
    
    let db = Firestore.firestore()
    @ObservedObject var userStore = UserStore()
    
    @State var email : String = ""
    @State var password : String = ""
    @State var username : String = ""
    @State var showAuthView = true
    
    var body: some View {
        
        
        NavigationView{
            
            if showAuthView {
            
        List {
            Text("MessageApp")
                .font(.largeTitle)
                .bold()
            
            Section{
                VStack(alignment: .center){
                    SectionSubtitle(subtitle: "User E-mail")
                    TextField("", text: $email)
                }
            }.padding()
            
            Section{
                VStack(alignment: .center){
                    SectionSubtitle(subtitle: "Password")
                    TextField("", text: $password)
                }
            }.padding()
            
            Section{
                VStack(alignment: .center){
                    SectionSubtitle(subtitle: "Username")
                    TextField("", text: $username)
                }
            }.padding()
            
            HStack {
                Section{
                    
                    Button(action: {
                        //sign in
                        Auth.auth().signIn(withEmail: self.email, password: self.password) { (result, error) in
                            if error != nil {
                                print(error!.localizedDescription)
                            }else {
                                self.showAuthView = false
                            }
                        }
                    }) {
                        Text("Sign In")
                            .foregroundColor(.red)
                    }
                }
                .padding(.all)
                
                Spacer()
                
                Section{
                    
                    Button(action: {
                        Auth.auth().createUser(withEmail: self.email, password: self.password) { (result, error) in
                            if error != nil {
                                print(error?.localizedDescription)
                            }else {
                                //Databate process
                                
                                var ref : DocumentReference? = nil
                                
                                let myUserDictionary : [String : Any] = ["username":self.username, "email" : self.email , "UserIdFromFireBase": result!.user.uid]
                                
                                ref = self.db.collection("Users").addDocument(data: myUserDictionary, completion: { (error) in
                                    if error != nil {
                                        print(error?.localizedDescription)
                                    }
                                })
                                //User's Screen
                                self.showAuthView = false
                            }
                        }
                    }) {
                        Text("Sign Up")
                            .foregroundColor(.red)
                        
                    }
                }
                .padding(.all)
            }
        }
            }else {
                
                //User View
                NavigationView{
                    List(userStore.user){ user in
                        NavigationLink(destination: ChatView(userToChat: user)) {
                            Text(user.name)
                        }
                        
                        
                    }
                    }.navigationBarTitle(Text("Users"))
                     .navigationBarItems(
                        leading: Button(action: {
                            do{
                            try Auth.auth().signOut()
                            }catch{
                                
                            }
                            self.showAuthView = true
                            }) {
                            Text("Log Out")
                                
                        }
                )

                    
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AuthView(showAuthView:true)
            AuthView(showAuthView:false)
        }
    }
}

struct SectionSubtitle : View {
    var subtitle: String
    
    var body : some View {
        
        Text(subtitle).font(.subheadline).foregroundColor(.gray)
    }
}
