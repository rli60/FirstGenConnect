//
//  MockProfileView.swift
//  FirstGen Connect
//
//  Created by 6 GO Participant on 7/23/24.
//

import SwiftUI

struct MockProfileView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack (spacing: 0){
                Rectangle()
                    .ignoresSafeArea()
                    .foregroundColor(Color("Canvas"))
                    .frame(height: 130)
                Group {
                    Image("sunflower")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipped()
                        .cornerRadius(80)
                        .overlay(RoundedRectangle(cornerRadius: 44)
                        .stroke(Color.gray, lineWidth: 1))

                    Text("Steve White")
                        .font(.custom("Poppins-SemiBold", size: 18))
                        .padding(3)
                        .padding(.top, 5)
                    Text("Mentor")
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
                    Text("University of Illinois at Urbana-Champaign")
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
                    Text("Junior")
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
                    Text("Mechanical Engineering")
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
                Spacer()
            }
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
}

#Preview {
    MockProfileView().environmentObject(UserProfile())
}
