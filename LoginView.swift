//
//  ContentView.swift
//  FirstGen Connect
//
//  Created by 6 GO Participant on 7/2/24.
//

import SwiftUI
import Firebase

struct LoginView: View {
        
    @State private var email = ""
    @State private var password = ""
    @State private var loginStatusMessage = ""
    @State private var isLoggedIn: Bool? = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("welcomePage")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack {
                    Image("logo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)

                    Text("Log In")
                        .font(.custom("Poppins-SemiBold", size: 30))
                        .padding(.vertical)
                    
                    Group {
                        TextField("School Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
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
                    .padding(.bottom, 8)
                    
                    
                    Button {
                        loginUser()
                    } label: {
                        Text("Log in")
                            .font(.custom("Poppins-Regular", size: 16))
                            .padding()
                            .frame(width: 100)
                            .foregroundColor(.black)
                            .background(Color("Canvas"))
                            .cornerRadius(10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.vertical)
                    }
                    
                    
                    NavigationLink(destination: CreateAccountView()) {
                        Text("Don't have an account? Sign up ")
                            .font(.custom("Poppins-Regular", size: 14))
                            + Text("here.").underline()
                            .font(.custom("Poppins-Regular", size: 14))
                    }
                    .foregroundColor(.black)
                    .padding(.bottom)
                    
                    Text(self.loginStatusMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal, 50)
                    
                    NavigationLink(destination: HomePage().navigationBarBackButtonHidden(true), tag: true, selection: $isLoggedIn) {}
                }
                .offset(y: -30)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to log in user:", err)
                self.loginStatusMessage = "Failed to log in user: \(err.localizedDescription)"
                return
            }
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            self.isLoggedIn = true
            //self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
        }
    }
}


#Preview {
    LoginView().environmentObject(UserProfile())
}
