//
//  UserProfile.swift
//  FirstGen Connect
//
//  Created by 6 GO Participant on 7/15/24.
//

import Foundation
import SwiftUI

class UserProfile: ObservableObject {
    //USED FOR 'EDIT PROFILE' (Type: Strings)
    @Published var name: String
    @Published var school: String
    @Published var email: String
    @Published var bio: String
    @Published var institution: String
    @Published var gradeLevel: String
    @Published var fieldOfStudy: String
    @Published var role: String

    //FORMAT FOR 'EDIT PROFILE'
    init(name: String = "", school: String = "", email: String = "", bio: String = "", institution: String = "", gradeLevel: String = "", fieldOfStudy: String = "", role: String = "") {
        self.name = name
        self.school = school
        self.email = email
        self.bio = bio
        self.institution = institution
        self.gradeLevel = gradeLevel
        self.fieldOfStudy = fieldOfStudy
        self.role = role
    }
}
