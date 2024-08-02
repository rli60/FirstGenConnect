//
//  NewPostView.swift
//  FirstGen Connect
//
//  Created by 6 GO Participant on 7/17/24.
//

import SwiftUI

struct NewPostView: View {
    @State var caption = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(Color(.black))
                }
                
                Spacer()
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Post")
                        .font(.custom("Poppins-Regular", size: 16))
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color("Canvas"))
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            .padding()
            
            HStack (alignment: .top) {
                TextField("Create a post!", text: $caption, axis: .vertical)
                    .font(.custom("Poppins-Regular", size: 16))
                .padding()
            }
            Spacer()
            .padding()
        }
    }
}

#Preview {
    NewPostView().environmentObject(UserProfile())
}
