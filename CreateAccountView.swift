//
//  CreateAccountView.swift
//  FirstGen Connect
//
//  Created by 6 GO Participant on 7/7/24.
//

import SwiftUI
import Firebase

struct CreateAccountView: View {
    
    @State var email = ""
    @State var password = ""
    @State var confirmPass = ""
    @State var loginStatusMessage = ""
    @State var shouldShowImagePicker = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("background2")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack {
                    Text("Create Account")
                        .font(.custom("Poppins-SemiBold", size: 30))
                    
                    Spacer()
                        .frame(height: 50)
                    
                    Button {
                        shouldShowImagePicker.toggle()
                    } label: {
                        
                        VStack {
                            if let image = self.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 128, height: 128)
                                    .cornerRadius(64)
                            }
                            else {
                                Image(systemName: "photo.badge.plus")
                                    .foregroundColor(.gray)
                                    .frame(width: 120, height: 120)
                                    .font(.system(size: 80))
                                    .padding(8)
                            }
                        }
                        .overlay(RoundedRectangle(cornerRadius: 70)
                            .stroke(Color.gray, lineWidth: 3))
                    }
                    
                    Spacer()
                        .frame(height: 50)
                    
                    Group {
                        TextField("School Email*", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password*", text: $password)
                        SecureField("Confirm Password*", text: $confirmPass)
                    }
                    .font(.custom("Poppins-Regular", size: 16))
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color("Cloud"))
                    .cornerRadius(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding(.vertical, 5)
                    
                    
                    if password != confirmPass {
                        Text("Password does not match")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(.red)
                        Button {
                            // do nothing
                        } label: {
                            Text("Continue")
                                .font(.custom("Poppins-Regular", size: 16))
                                .padding()
                                .frame(width: 120)
                                .foregroundColor(.black)
                                .background(Color("Canvas"))
                                .cornerRadius(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .padding(.vertical)
                        }
                    }
                    else {
                        NavigationLink(destination: EditProfileView().navigationBarBackButtonHidden(true), tag: true, selection: $createdAccount) {}
                        
                        Button {
                            createAccount()
                        } label: {
                            Text("Continue")
                                .font(.custom("Poppins-Regular", size: 16))
                                .padding()
                                .frame(width: 120)
                                .foregroundColor(.black)
                                .background(Color("Canvas"))
                                .cornerRadius(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .padding(.vertical)
                        }
                        
                        Text(self.loginStatusMessage)
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(.red)
                            .padding(.horizontal, 50)
                            .offset(y: -10)
                    }
                    
                    Spacer()
                        .frame(height: 80)
                }
            }
        }
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
                .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
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
    }
    
    @State var image: UIImage?
    @State var createdAccount: Bool? = false
    
    private func createAccount() {
        if self.image == nil {
            self.loginStatusMessage = "You must select a profile image"
            return
        }
        
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to create user:", err)
                self.loginStatusMessage = "Failed to create user: \(err.localizedDescription)"
                return
            }
            print("Successfully created user: \(result?.user.uid ?? "")")
            //self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
            self.loginStatusMessage = "Successfully created account. Please log in with your credentials."
            self.persistImageToStorage()
            self.createdAccount = true
        }
    }
    
    private func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                self.loginStatusMessage = "Failed to push image to Storage: \(err)"
                return
            }
            ref.downloadURL { url, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                //self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                print(url?.absoluteString as Any)
                
                guard let url = url else { return }
                self.storeUserInformation(imageProfileURL: url)
            }
        }
    }
    
    private func storeUserInformation(imageProfileURL: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let userData = ["email": self.email, "uid": uid, "profileImageURL": imageProfileURL.absoluteString]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    self.loginStatusMessage = "\(err)"
                    return
                }
                print("Success")
            }
    }
}

#Preview {
    CreateAccountView().environmentObject(UserProfile())
}
