//
//  ChatLogView.swift
//  FirstGen Connect
//
//  Created by 6 GO Participant on 7/10/24.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct FirebaseConstants {
    static let fromID = "fromID"
    static let toID = "toID"
    static let text = "text"
}

struct ChatMessage: Identifiable {
    var id: String { documentID }
    let documentID: String
    let toID, fromID, text: String
    
    init(documentID: String, data: [String: Any]) {
        self.documentID = documentID
        self.fromID = data[FirebaseConstants.fromID] as? String ?? ""
        self.toID = data[FirebaseConstants.toID] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""
    }
}

class ChatLogViewModel: ObservableObject {
    @Published var count = 0
    @Published var chatText = ""
    @Published var errorMessage = ""
    @Published var chatMessages = [ChatMessage]()
    var firestoreListener: ListenerRegistration?
    
    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        fetchMessages()
    }
    
    private func fetchMessages() {
        guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toID = chatUser?.uid else { return }
        firestoreListener?.remove()
        chatMessages.removeAll()
        firestoreListener = FirebaseManager.shared.firestore.collection("messages").document(fromID).collection(toID).order(by: "timestamp").addSnapshotListener { querySnapshot, err in
            if let err = err {
                print(err)
                self.errorMessage = "Failed to listen for messages: \(err)"
                return
            }
            querySnapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    self.chatMessages.append(.init(documentID: change.document.documentID, data: data))
                }
            })
            DispatchQueue.main.async {
                self.count += 1
            }
        }
    }
    
    func handleSend() {
        print(chatText)
        guard let fromID = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toID = chatUser?.uid else { return }
        let document = FirebaseManager.shared.firestore.collection("messages")
            .document(fromID)
            .collection(toID)
            .document()
        
        let messageData = [FirebaseConstants.fromID: fromID, FirebaseConstants.toID: toID, FirebaseConstants.text: self.chatText, "timestamp": Timestamp()] as [String : Any]
        
        document.setData(messageData) { err in
            if let err = err {
                self.errorMessage = "Failed to save message into Firestore: \(err)"
                return
            }
            print("Successfully saved current user sending message")
            
            self.persistRecentMessage()
            
            self.chatText = ""
            self.count += 1
        }
        
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(toID)
            .collection(fromID)
            .document()
        
        recipientMessageDocument.setData(messageData) { err in
            if let err = err {
                self.errorMessage = "Failed to save message into Firestore: \(err)"
                return
            }
            print("Recipient saved message as well")
        }
    }
    
    private func persistRecentMessage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toID = self.chatUser?.uid else { return }
        guard let chatUser = chatUser else { return }
        let document = FirebaseManager.shared.firestore.collection("recent_messages").document(uid).collection("messages").document(toID)
        let data = ["timestamp": Timestamp(), FirebaseConstants.text: self.chatText, FirebaseConstants.fromID: uid,
                    FirebaseConstants.toID: toID, "profileImageURL": chatUser.profileImageURL, "email": chatUser.email] as [String : Any]
        
        document.setData(data) { err in
            if let err = err {
                self.errorMessage = "Failed to save recent message: \(err)"
                print("Failed to save recent message: \(err)")
                return
            }
        }
        
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        let recipientRecentMessageDictionary = [
            "timestamp": Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromID: uid,
            FirebaseConstants.toID: toID,
            "profileImageURL": currentUser.profileImageURL,
            "email": currentUser.email
        ] as [String : Any]
        
        FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(toID)
            .collection("messages")
            .document(currentUser.uid)
            .setData(recipientRecentMessageDictionary) { error in
                if let error = error {
                    print("Failed to save recipient recent message: \(error)")
                    return
                }
            }
        }
    }


struct ChatLogView: View {
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        self.vm = .init(chatUser: chatUser)
    }
    
    let chatUser: ChatUser?
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: ChatLogViewModel
    
    var body: some View {
        ZStack {
            //Text(vm.errorMessage)
            VStack (spacing: 0) {
                WebImage(url: URL(string: chatUser?.profileImageURL ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .cornerRadius(50)
                    .overlay(RoundedRectangle(cornerRadius: 44)
                    .stroke(Color.gray, lineWidth: 1))
                    .offset(y: -30)
                
                Spacer().frame(height: 10)
                
                Text(chatUser?.email ?? "")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 10)
                    .offset(y: -30)
                    .navigationBarBackButtonHidden(true)
                
                Text("Mentor")
                   .font(.custom("Poppins-Regular", size: 14))
                   .offset(y: -40)
                
                Spacer().frame(height: 0.1)
                
                Divider()
                
                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        ForEach(vm.chatMessages) { message in
                            VStack {
                                if message.fromID == FirebaseManager.shared.auth.currentUser?.uid {
                                    HStack {
                                        Spacer()
                                        HStack {
                                            Text(message.text)
                                        }
                                        .padding()
                                        .background(Color("Canvas"))
                                        .cornerRadius(30)
                                    }
                                }
                                else {
                                    HStack {
                                        HStack {
                                            Text(message.text)
                                        }
                                        .padding()
                                        .background(Color("Cloud"))
                                        .cornerRadius(30)
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                        }
                        HStack { Spacer() }
                            .id("Empty")
                            .onReceive(vm.$count) { _ in
                                withAnimation(.easeOut(duration: 0.5)) {
                                    scrollViewProxy.scrollTo("Empty", anchor: .bottom)
                                }
                            }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.backward.circle.fill")
                                .foregroundColor(Color("Canvas"))
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                                .font(.system(size: 30))
                                .padding(.leading, 5)
                                .offset(y: 15)
                        }
                    }
                }
                Divider()
                    .padding(.bottom, 8)
                
                HStack {               
                    TextField("Enter message here", text: $vm.chatText)
                        .font(.custom("Poppins-Regular", size: 16))
                        .padding()
                        .frame(width: 320, height: 50)
                        .background(Color("Cloud"))
                        .cornerRadius(30)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.leading)
                        .padding(.top, 5)
                    
                    Button {
                        vm.handleSend()
                    } label: {
                        Image(systemName: "paperplane.circle.fill")
                            .font(.system(size: 35))
                            .foregroundColor(Color("Canvas"))
                            .overlay(RoundedRectangle(cornerRadius: 44)
                                .stroke(Color.gray, lineWidth: 2))
                    }
                    .padding(.trailing)
                }
                .padding(.bottom)
                .padding(.vertical, 8)
            }
        }
        .onDisappear(perform: {
            vm.firestoreListener?.remove()
        })
    }
}

#Preview {
    MessagesTab().environmentObject(UserProfile())
//    ChatLogView(chatUser: .init(data: ["uid": "19ukCojgncaamzhJrZLpvMcZrxY2", "email": "firstgen@gmail.com"]))
}
