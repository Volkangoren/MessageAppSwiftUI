//
//  ChatModel.swift
//  MessageAppSwiftUI
//
//  Created by Volkan on 9.03.2020.
//  Copyright © 2020 Volkan. All rights reserved.
//

import SwiftUI

struct ChatModel : Identifiable {
    var id : Int
    var message : String
    var uidFromFirebase : String
    var messageFrom : String
    var messageTo: String
    var messageDate : Date
    var messageFromMe : Bool
    
}

