//
//  ChatUser.swift
//  FirstGen Connect
//
//  Created by 6 GO Participant on 7/9/24.
//

//import Foundation
import FirebaseFirestoreSwift

struct ChatUser: Codable, Identifiable {
    //var id: String { uid }
    @DocumentID var id: String?
    let uid, email, profileImageURL: String
    
//    init(data: [String: Any]) {
//        self.uid = data["uid"] as? String ?? ""
//        self.email = data["email"] as? String ?? ""
//        self.profileImageURL = data["profileImageURL"] as? String ?? ""
//    }
}
