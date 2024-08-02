//
//  ProfileTab.swift
//  FirstGen Connect
//
//  Created by 6 GO Participant on 7/15/24.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct ProfileTab: View {
    @ObservedObject private var vm = MainMessagesViewModel()
    @EnvironmentObject var userInfo: UserProfile
    
    var body: some View {
        NavigationView {
            VStack (spacing: 0){
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundColor(Color("Canvas"))
                    .frame(height: 130)
                Group {
                    WebImage(url: URL(string: vm.chatUser?.profileImageURL ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipped()
                        .cornerRadius(80)
                        .overlay(RoundedRectangle(cornerRadius: 44)
                        .stroke(Color.gray, lineWidth: 1))

                    Text(userInfo.name)
                        .font(.custom("Poppins-SemiBold", size: 18))
                        .padding(3)
                        .padding(.top, 5)
                    Text(userInfo.role)
                        .font(.system(size: 15))
                }
                .offset(y: -40)
                
                Spacer().frame(height: 10)
                
                HStack {
                    Spacer().frame(width: 30)
                    Text("Institution")
                        .font(.custom("Poppins-SemiBold", size: 18))
                        .padding(.bottom, 5)
                    Spacer()
                }
                
                HStack {
                    Spacer().frame(width: 30)
                    Text(userInfo.institution)
                        .font(.custom("Poppins-Regular", size: 15))
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .background(Color.cloud)
                        .padding(.bottom)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                
                HStack {
                    Spacer().frame(width: 30)
                    Text("Grade")
                        .font(.custom("Poppins-SemiBold", size: 18))
                        .padding(5)
                    Spacer()
                }
                
                HStack {
                    Spacer().frame(width: 30)
                    Text(userInfo.gradeLevel)
                        .font(.custom("Poppins-Regular", size: 15))
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .background(Color.cloud)
                        .padding(.bottom)
                    Spacer()
                }
                
                HStack {
                    Spacer().frame(width: 30)
                    Text("Field of Study")
                        .font(.custom("Poppins-SemiBold", size: 18))
                        .padding(5)
                    Spacer()
                }
                
                HStack {
                    Spacer().frame(width: 30)
                    Text(userInfo.fieldOfStudy)
                        .font(.custom("Poppins-Regular", size: 15))
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .background(Color.cloud)
                    Spacer()
                }
                
                Spacer().frame(height: 35)
                
                NavigationLink(destination: EditProfileView()) {
                    Text("Edit Profile")
                        .font(.custom("Poppins-Regular", size: 16))
                        .padding(15)
                        .frame(width: 130)
                        .foregroundColor(.black)
                        .background(Color("Canvas"))
                        .cornerRadius(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.vertical)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    ProfileTab().environmentObject(UserProfile())
}
