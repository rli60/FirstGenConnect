//
//  CreateNewMessageView.swift
//  FirstGen Connect
//
//  Created by 6 GO Participant on 7/9/24.
//

import SwiftUI
import SDWebImageSwiftUI

class CreateNewMessageViewModel: ObservableObject {
    
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documentsSnapshot, err in
                if let err = err {
                    self.errorMessage = "Failed to fetch users: \(err)"
                    print("Failed to fetch users: \(err)")
                    return
                }
                documentsSnapshot?.documents.forEach({ snapshot in
                    let user = try? snapshot.data(as: ChatUser.self)
                    if user?.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        self.users.append(user!)
                    }
//                    let data = snapshot.data()
//                    let user = ChatUser(data: data)
//                    if user.uid != FirebaseManager.shared.auth.currentUser?.uid {
//                        self.users.append(.init(data: data))
//                    }
                })
                //self.errorMessage = "Fetched users successfully"
            }
    }
}

struct CreateNewMessageView: View {
    
    let didSelectNewUser: (ChatUser) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = CreateNewMessageViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Text("New Message")
                    .font(.custom("Poppins-SemiBold", size: 30))
                    .padding(.trailing, 150)
                    .frame(height: 20)
                    .offset(y: -10)
                
                Divider()
                    .padding(.top)
                
                ScrollView {
                    //Text(vm.errorMessage)
                    Divider()
                    ForEach(vm.users) { user in
                        Button {
                            presentationMode.wrappedValue.dismiss()
                            didSelectNewUser(user)
                        } label: {
                            HStack(spacing: 16) {
                                WebImage(url: URL(string: user.profileImageURL))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipped()
                                    .cornerRadius(60)
                                    .overlay(RoundedRectangle(cornerRadius: 60)
                                        .stroke(Color.gray, lineWidth: 1))
                                Text(user.email)
                                    .foregroundColor(.black)
                                    .font(.custom("Poppins-Regular", size: 15))
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        Divider()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                                .foregroundColor(Color("Canvas"))
                                .padding(.trailing, 2)
                                .offset(y: 20)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MessagesTab().environmentObject(UserProfile())
    //CreateNewMessageView()
}
