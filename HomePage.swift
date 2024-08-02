//
//  HomePage.swift
//  FirstGen Connect
//
//  Created by 6 GO Participant on 7/3/24.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        TabView {
            Group {
                HomeTab()
                    .tabItem {
                        Label("Home", systemImage: "house")
                }
                ConnectionsTab()
                    .tabItem {
                        Label("Connections", systemImage: "graduationcap")
                    }
                MessagesTab()
                    .tabItem {
                        Label("Messages", systemImage: "ellipsis.message.fill")
                    }
                ProfileTab()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle.fill")
                    }
            }
            .toolbarBackground(Color("Cloud"), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .accentColor(.black.opacity(0.7))
    }
}

#Preview {
    HomePage().environmentObject(UserProfile())
}
