//
//  HomePageTab.swift
//  FirstGen Connect
//
//  Created by 6 GO Participant on 7/3/24.
//

import SwiftUI
import Firebase
import UIKit


struct HomeTab: View {
    @ObservedObject private var vm = MainMessagesViewModel()
    @EnvironmentObject var userInfo: UserProfile
    @State private var showNewPostView = false
    @State var posts = [Post(fullName: "Steve White", role: "Mentor", date: "2h", profileImageName: "sunflower",
                             caption: "Hi! Nice to meet everyone! I'm a currently a Junior in Mechanical Engineering here at UIUC!"),
                        Post(fullName: "Stephanie Applegate", role: "Mentee", date: "1d", profileImageName: "penguin",
                             caption: "Hello! I'm a freshman MechE major looking for some help in ME 170."),
                        Post(fullName: "Colin Smith", role: "Mentor", date: "1d", profileImageName: "chalk",
                             caption: "Hello! I'm a Senior in MechE, currently doing research——connect with me if you have any questions :)"),
                        Post(fullName: "Lucy Franklin", role: "Mentor", date: "2d", profileImageName: "sandollar",
                             caption: "Hi! I'm a Senior double majoring in MechE and CS! Connect with me if you need guidance regarding either fields!"),
                        Post(fullName: "Daniel Barker", role: "Mentee", date: "2d", profileImageName: "lotus", caption: "Hi everyone! I'm a sophomore in Mechanical Engineering! Looking for some advice in regards to internships")]
    var body: some View {
        NavigationView {
            VStack (spacing: 0) {
                HStack {
                    Image("logo")
                        .resizable()
                        .frame(width: 65, height: 65)
                        .padding(.horizontal)
                        .offset(y: -10)
                    
                    Text("FirstGen Connect")
                        .font(.custom("Poppins-SemiBold", size: 21))
                    Spacer()
                    
                    Button {
                        showNewPostView.toggle()
                        Task {
                            // Delay the task by 1 second:
                            try await Task.sleep(nanoseconds: 1_000_000_000)
                            // Perform our operation
                            posts.insert(Post(fullName: userInfo.name, role: userInfo.role, date: "0s", profileImageName: "leaves", caption: "Hi! Nice to meet everyone!"), at: 0)
                        }
                    } label: {
                        Image(systemName: "square.and.pencil.circle.fill")
                            .foregroundColor(Color("Canvas"))
                            .font(.system(size: 45))
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                            .foregroundColor(Color("Canvas"))
                    }
                    .offset(y: -5)
                    .fullScreenCover(isPresented: $showNewPostView) {
                        NewPostView()
                    }
                    Spacer().frame(width: 20)
                }
                .frame(maxWidth: .infinity)
                .background(Color("Cloud"))
                
                
                ScrollView {
                    ForEach ($posts, id: \.self) { $post in
                        VStack(alignment: .leading) {
                            //profile image + user info + post
                            HStack(alignment: .top, spacing: 12) {
                                if post.fullName == "Steve White" {
                                    NavigationLink(destination: MockProfileView()) {
                                        Image(post.profileImageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 45, height: 45)
                                            .clipShape(Circle())
                                    }
                                } else {
                                    Image(post.profileImageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 45, height: 45)
                                        .clipShape(Circle())
                                }
                                //user info & post caption
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(post.fullName)
                                            .font(.custom("Poppins-SemiBold", size: 15))
                                        
                                        Text(post.role)
                                            .font(.custom("Poppins-Regular", size: 11))
                                            .foregroundColor(.black.opacity(0.6))
                                        
                                        Spacer()
                                        
                                        Text(post.date)
                                            .font(.custom("Poppins-Regular", size: 14))
                                            .foregroundColor(.gray)
                                        
                                        Button(action: {}, label: {
                                            Image(systemName: "ellipsis")
                                                .foregroundColor(.gray)
                                        })
                                    }
                                    //post caption
                                    Text(post.caption)
                                        .font(.subheadline)
                                }
                            }
                            // action buttons
                            HStack (spacing: 16) {
                                Button {
                                    
                                } label: {
                                    Image(systemName: "bubble.left")
                                        .font(.subheadline)
                                        
                                }
                                Button {
                                    
                                } label: {
                                    Image(systemName: "heart")
                                        .font(.subheadline)
                                }
                                
                                Spacer()

                            }
                            .padding([.leading, .trailing], 50)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 8)
                            .foregroundColor(.gray)
                            Divider()
                        }
                        .padding()
                    }
                }
            }
        }
    }
}


#Preview {
    HomeTab().environmentObject(UserProfile())
}
