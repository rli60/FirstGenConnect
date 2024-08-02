//
//  FriendsTab.swift
//  FirstGen Connect
//
//  Created by 6 GO Participant on 7/3/24.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import SDWebImageSwiftUI

struct RecentMessage: Codable, Identifiable {
    @DocumentID var id: String?
    
    let text, email: String
    let toID, fromID: String
    let profileImageURL: String
    let timestamp: Date
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}

class MainMessagesViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    @Published var recentMessages = [RecentMessage]()
    private var firestoreListener: ListenerRegistration?
    
    init() {
        fetchCurrentUser()
        fetchRecentMessages()
    }
    
    func fetchRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        firestoreListener?.remove()
        self.recentMessages.removeAll()
        firestoreListener = FirebaseManager.shared.firestore.collection("recent_messages").document(uid).collection("messages").order(by: "timestamp").addSnapshotListener { querySnapshot, err in
            if let err = err {
                self.errorMessage = "Failed to listen for recent messages: \(err)"
                print(err)
                return
            }
            querySnapshot?.documentChanges.forEach({ change in
                let docID = change.document.documentID
                if let index = self.recentMessages.firstIndex(where: { rm in
                    return rm.id == docID
                }) {
                    self.recentMessages.remove(at: index)
                }
                do {
                    let rm = try change.document.data(as: RecentMessage.self)
                    self.recentMessages.insert(rm, at: 0)
                } catch {
                    print(err)
                }
            })
        }
    }
    
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find Firebase uid"
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            self.chatUser = try? snapshot?.data(as: ChatUser.self)
            FirebaseManager.shared.currentUser = self.chatUser
        }
    }
}

struct MessagesTab: View {
    @ObservedObject private var vm = MainMessagesViewModel()
    @State var shouldShowNewMessageScreen = false
    @State var shouldNavigateToChatLogView = false
    @State var chatUser: ChatUser?

    var body: some View {
        NavigationView {
            VStack (spacing: 0) {
                //Text("USER: \(vm.chatUser?.uid ?? "")")
                Text("Messages")
                    .ignoresSafeArea()
                    .font(.custom("Poppins-SemiBold", size: 30))
                    .padding(.trailing, 210)
                    .offset(y: 5)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .padding(.bottom, 10)
                    .background(Color("Canvas"))
                
                ScrollView {
                    Divider()
                        .padding(.bottom, 8)
                    ForEach(vm.recentMessages) { recentMessage in
                        VStack {
                            Button {
                                let uid = FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromID ? recentMessage.toID : recentMessage.fromID
                                self.chatUser = .init(id: uid, uid: uid, email: recentMessage.email, profileImageURL: recentMessage.profileImageURL)
                                self.shouldNavigateToChatLogView.toggle()
                            } label: {
                                HStack(spacing: 16) {
                                    WebImage(url: URL(string: recentMessage.profileImageURL))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 64, height: 64)
                                        .clipped()
                                        .cornerRadius(64)
                                        .overlay(RoundedRectangle(cornerRadius: 64).stroke(Color.gray, lineWidth: 1))
                                    
                                    VStack (alignment: .leading, spacing: 2) {
                                        Text(recentMessage.email)
                                            .font(.custom("Poppins-SemiBold", size: 16))
                                            .foregroundColor(.black)
                                            .multilineTextAlignment(.leading)
                                            .font(.system(size: 16, weight: .bold))
                                        Text(recentMessage.text)
                                            .font(.custom("Poppins-Regular", size: 14))
                                            .foregroundColor(Color(.lightGray))
                                            .multilineTextAlignment(.leading)
                                    }
                                    Spacer()
                                    Text(recentMessage.timeAgo)
                                        .font(.custom("Poppins-SemiBold", size: 14))
                                        .foregroundColor(.black)
                                }
                            }
                              Divider()
                                 .padding(.vertical, 8)
                        }
                        .padding(.horizontal)
                    }
                }
                NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                    ChatLogView(chatUser: self.chatUser)
                }
            }
            .overlay(
                Button {
                    shouldShowNewMessageScreen.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 55))
                        .background(Color.black.opacity(0.7))
                        .clipShape(Circle())
                        .foregroundColor(Color("Canvas"))
                        .padding(.bottom)
                }
                .offset(x: 145, y: 290)
                .fullScreenCover(isPresented: $shouldShowNewMessageScreen, content: {
                    CreateNewMessageView(didSelectNewUser: { user in
                        //print(user.email)
                        self.shouldNavigateToChatLogView.toggle()
                        self.chatUser = user
                    })
                })
            )
            .navigationBarHidden(true)
        }
    }
    
}

#Preview {
    MessagesTab().environmentObject(UserProfile())
}
