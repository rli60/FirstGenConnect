//
//  MentorsTab.swift
//  FirstGen Connect
//
//  Created by 6 GO Participant on 7/3/24.
//

import SwiftUI

struct Mentor: Identifiable { //controls user information
    var id = UUID()
    var name: String
    var profileImage: String
    var role: String
}

struct ConnectionsTab: View {
    @EnvironmentObject var userProfile: UserProfile
    @State private var suggestedMentors: [Mentor] = []
    @State private var scrollPosition: Int? = nil
    @State private var showAlert: Bool = false
    @State private var selectedMentor: Mentor?
    @State var shouldNavigateToChatLogView = false
    @State var chatUser = ChatUser(uid: "oTnii8clQdblojJvnS7ogIMqDRj2", email: "swhite1@illinois.edu", profileImageURL: "https://firebasestorage.googleapis.com:443/v0/b/firstgen-connect.appspot.com/o/oTnii8clQdblojJvnS7ogIMqDRj2?alt=media&token=753ae879-2e8f-4d02-aad3-68e99f055e6a")

    var body: some View {
        NavigationView {
            ZStack {
                //BACKGROUND
                Image("background1")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack (spacing: 0) {
                    Divider()
                    Color("Cloud")
                }
                .offset(y: -135)
                .frame(maxWidth: .infinity, maxHeight: 265)
                //Divider()
                //LABEL
                VStack {
                    Text("Connections")
                        .font(.custom("Poppins-SemiBold", size: 30))
                        .foregroundColor(.black)//txt color
                        .padding()
                        .frame(maxWidth: 300, minHeight: 50)//frame
                        .background(Color.canvas)
                        .cornerRadius(10)
                        .padding(.top, 50)//space from the top (temp)
                        .offset(y: 10)
                    
                    Text("Suggested Connections")
                        .font(.custom("Poppins-Regular", size: 20))
                        .offset(y: 25)
                    
                    //HORIZONTAL SCROLLING PFPS
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(suggestedMentors.prefix(5)) { mentor in //only show top 5 in scroll view
                                VStack {
                                    if mentor.name == "Steve White" {
                                        NavigationLink(destination: MockProfileView()) {
                                            Image(mentor.profileImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 80, height: 80)
                                                .clipShape(Circle())
                                        }
                                    } else {
                                        Button {
                                            
                                        } label: {
                                            Image(mentor.profileImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 80, height: 80)
                                                .clipShape(Circle())
                                        }
                                    }
                                    
                                    Text(mentor.name)
                                        .font(.custom("Poppins-Regular", size: 14))
                                        .foregroundColor(.black)
                                        .padding(.top, 5)
                                    
                                    Text(mentor.role) //role label
                                        .font(.custom("Poppins-Regular", size: 12))
                                        .foregroundColor(.gray)
                                    
                                    NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                                        ChatLogView(chatUser: self.chatUser)
                                    }
                                    
                                   
                                    Button(action: {
                                        selectedMentor = mentor
                                        showAlert = true
                                    }) {
                                        Text("Add")
                                            .font(.custom("Poppins-Regular", size: 14))
                                            .foregroundColor(.black)
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 20)
                                            .background(Color.canvas)
                                            .cornerRadius(10)
                                    }
                                    .alert(isPresented: $showAlert) {
                                        Alert(
                                            title: Text("Add \(selectedMentor?.name ?? "")"),
                                            message: Text("Would you like to add \(selectedMentor?.name ?? "") and start messaging them?"),
                                            primaryButton: .default(Text("Yes")) {
                                                // Add your add and messaging functionality here
                                                self.shouldNavigateToChatLogView.toggle()
                                            },
                                            secondaryButton: .cancel()
                                        )
                                    }
                                }
                                .frame(width: 100, height: 200)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding(10)
                                .id(mentor.id)
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    
                    //List of Suggested Mentors with Message Button
                    VStack {
                        ForEach(suggestedMentors.dropFirst(5).prefix(2), id: \.id) { mentor in //Show next 2 in bottom list
                            HStack {
                                Image(mentor.profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .padding(.leading, 10)
                                
                                VStack(alignment: .leading) {
                                    Text(mentor.name)
                                        .font(.custom("Poppins-Regular", size: 16))
                                        .foregroundColor(.black)
                                    
                                    Text(mentor.role) //Role label
                                        .font(.custom("Poppins-Regular", size: 14))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    selectedMentor = mentor
                                    showAlert = true
                                }) {
                                    Image(systemName: "bubble.right")
                                        .font(.title)
                                        .foregroundColor(.canvas)
                                        .bold()
                                }
                                .padding(.trailing, 20)
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("Message \(selectedMentor?.name ?? "")"),
                                        message: Text("Would you like to send a message to \(selectedMentor?.name ?? "")?"),
                                        primaryButton: .default(Text("Yes")) {
                                            //add your messaging functionality here
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                            }
                            .padding(.vertical, 40)//controls entire frame (watch it)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)//drop shadow
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom, 75) //add padding to bottom to avoid blocking the tab bar
            }
            .onAppear {
                loadSuggestedMentors()
            }
        }
    }
    
    func loadSuggestedMentors() {
        print("User's field of study: ", userProfile.fieldOfStudy)
        if userProfile.fieldOfStudy == "Computer Science" {
            suggestedMentors = [
                //5 SCROLL OPTIONS
                Mentor(name: "John Doe", profileImage: "johnDoe", role: "Mentor"),
                Mentor(name: "Jane Doe", profileImage: "janeDoe", role: "Mentor"),
                Mentor(name: "Lennox Roach", profileImage: "piano", role: "Mentor"),
                Mentor(name: "Nancy Lee", profileImage: "sunflower", role: "Mentor"),
                Mentor(name: "Oliver Green", profileImage: "sandollar", role: "Mentor"),
                //BOTTOM LIST
                Mentor(name: "Eve Martinez", profileImage: "penguin", role: "Mentee"), // Bottom list mentor
                Mentor(name: "Angel Garcia", profileImage: "lotus", role: "Mentee") // Bottom list mentor
            ]
        } else if userProfile.fieldOfStudy == "Mathematics" {
            suggestedMentors = [
                //5 SCROLL OPTIONS
                Mentor(name: "Fred Bauer", profileImage: "chalk", role: "Mentor"),
                Mentor(name: "Angel Garcia", profileImage: "sandollar", role: "Mentor"),
                Mentor(name: "Nicole Johnson", profileImage: "zebra", role: "Mentor"),
                Mentor(name: "Amy Williams", profileImage: "johnDoe", role: "Mentor"),
                Mentor(name: "Jason Bohr", profileImage: "piano", role: "Mentor"),
                //BOTTOM LIST
                Mentor(name: "Sara Bach", profileImage: "penguin", role: "Mentee"), // Bottom list mentor
                Mentor(name: "Almasa Pecanin", profileImage: "lotus", role: "Mentee") // Bottom list mentor
            ]
        } else { //Standard ones!
            suggestedMentors = [
                //5 SCROLL OPTIONS
                Mentor(name: "Steve White", profileImage: "sunflower", role: "Mentor"),
                Mentor(name: "Colin Smith", profileImage: "chalk", role: "Mentor"),
                Mentor(name: "Lucy Franklin", profileImage: "sandollar", role: "Mentor"),
                Mentor(name: "Danny Rollins", profileImage: "piano", role: "Mentor"),
                Mentor(name: "Niels Bohr", profileImage: "zebra", role: "Mentor"),
                //BOTTOM LIST
                Mentor(name: "Stephanie Applegate", profileImage: "penguin", role: "Mentee"), // Bottom list mentor
                Mentor(name: "Daniel Barker", profileImage: "lotus", role: "Mentee") // Bottom list mentor
            ]
        }
    }
}

#Preview {
    ConnectionsTab().environmentObject(UserProfile())
}
