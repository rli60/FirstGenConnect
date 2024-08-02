//
//  EditProfileView2.swift
//  FirstGen Connect
//
//  Created by 6 GO Participant on 7/9/24.
//

import SwiftUI

struct OutlineStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}

struct EditProfileView: View {
    @EnvironmentObject var userProfile: UserProfile
    
    //Options
    @State var institutions: [String] = ["               ", "NOT LISTED", "University of California-Berkeley", "University of Illinois at Urbana-Champaign", "University of Illinois Chicago", "University of Kansas", "University of Michigan- Ann Arbor", "University of Pennsylvania", "University of Rochester", "University of San Diego", "University of Wisconsin-Madison"]
    let gradeLevels = ["               ", "Freshman", "Sophomore", "Junior", "Senior"]
    let fieldsOfStudy = ["               ", "Accounting", "Advertising", "Aerospace Engineering", "Anthropology", "Architecture", "Art History", "Biology", "Business Administration", "Chemistry", "Civil Engineering", "Communications", "Computer Engineering", "Computer Science", "Criminal Justice", "Economics", "Education", "Electrical Engineering", "Engineering - Other", "English Literature", "Environmental Science", "Finance", "Graphic Design", "History", "Information Technology", "International Relations", "Journalism", "Marketing", "Mathematics", "Mechanical Engineering", "Music", "Nursing", "Philosophy", "Physics", "Political Science", "Pre-Med", "Psychology", "Sociology", "Statistics", "Theater"]
    let allRoles = ["               ", "Mentee", "Mentor"]
    
    var filteredRoles: [String] { //prevents freshman from being a mentor
        if userProfile.gradeLevel == "Freshman" {
            return ["               ", "Mentee"]
        } else {
            return allRoles
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    //@State var profileSaved: Bool? = false

 var body: some View {
        NavigationView {
            ZStack {
                Image("background2") //background image
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer().frame(height: 90) //controls space from the top
                    
                    // Header
                    Text("Edit Profile")
                        .font(.custom("Poppins-Semibold", size: 30))
                        
                    
                    Spacer().frame(height: 0.1) //space below the header
                    
                    // Content
                    VStack(alignment: .leading, spacing: 7) {
                        
                        // First and Last Name
                        Text("First and Last Name")
                            .font(.custom("Poppins-Regular", size: 18)) +
                        Text("*")
                            .foregroundColor(.red)
                        TextField("Name", text: $userProfile.name)
                            .font(.custom("Poppins-Regular", size: 16))
                            .padding(4)
                            .frame(width: 300, height: 35)
                            .modifier(OutlineStyle())
                            .background(Color("Cloud"))
                            .cornerRadius(10)
                            .padding(.bottom)
                        
                        // Institution (DROP DOWN)
                        Text("Institution")
                            .font(.custom("Poppins-Regular", size: 18)) +
                        Text("*")
                            .foregroundColor(.red)
                        Picker("Institution", selection: $userProfile.institution) {
                            ForEach(institutions, id: \.self) {
                                Text($0)
                            }
                        }
                        .font(.custom("Poppins-Regular", size: 16))
                        .accentColor(.black)
                        .modifier(OutlineStyle())
                        .background(Color("Cloud"))
                        .cornerRadius(10)
                        .padding(.bottom)
                        
                        // Grade level (DROP DOWN)
                        Text("Grade Level")
                            .font(.custom("Poppins-Regular", size: 18)) +
                        Text("*")
                            .foregroundColor(.red)
                        Picker("Grade Level", selection: $userProfile.gradeLevel) {
                            ForEach(gradeLevels, id: \.self) {
                                Text($0)
                            }
                        }
                        .font(.custom("Poppins-Regular", size: 16))
                        .accentColor(.black)
                        .modifier(OutlineStyle())
                        .background(Color("Cloud"))
                        .cornerRadius(10)
                        .padding(.bottom)
                        
                        // Field(s) of Study (DROP DOWN)
                        Text("Field of Study")
                            .font(.custom("Poppins-Regular", size: 18)) +
                        Text("*")
                            .foregroundColor(.red)
                        
                        Picker("Field(s) of Study", selection: $userProfile.fieldOfStudy) {
                            ForEach(fieldsOfStudy, id: \.self) {
                                Text($0)
                            }
                            .foregroundColor(Color.black)
                        }
                        .font(.custom("Poppins-Regular", size: 16))
                        .accentColor(.black)
                        .modifier(OutlineStyle())
                        .background(Color("Cloud"))
                        .cornerRadius(10)
                        .padding(.bottom)
                        
                        // Role (DROP DOWN)
                        Text("Role")
                            .font(.custom("Poppins-Regular", size: 18)) +
                        Text("* ")
                            .foregroundColor(.red) +
                        Text("(Mentors must be at least a sophomore)")
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(.gray)
                        Picker("Role", selection: $userProfile.role) {
                            ForEach(filteredRoles, id: \.self) {
                                Text($0)
                            }
                        }
                        .font(.custom("Poppins-Regular", size: 16))
                        .accentColor(.black)
                        .modifier(OutlineStyle())
                        .background(Color("Cloud"))
                        .cornerRadius(10)
                        
                        Spacer().frame(height: 10)
                        
                        // Save Button
                        Button(action: {
                            // Save action
                            saveProfile()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Save")
                                .font(.custom("Poppins-Regular", size: 16))
                                .padding(8)
                                .frame(width: 80) // Fixed width for the button
                                .modifier(OutlineStyle())
                                .background(Color("Canvas"))
                                .foregroundColor(.black) // Text color
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity) // Expand the button to fill available space
                                .padding(.horizontal) // Add horizontal padding to center the button
                        }
                    }
                    .padding()
                    .cornerRadius(10) //rounded corners
                    .padding() //padding around the form
                    
                    Spacer() //space at the bottom
                }
            }
        }
        //.navigationBarHidden(true) //hides default navigation bar title
        .navigationBarBackButtonHidden(true)
    }
    
    func saveProfile() {
        //save the profile
        //self.profileSaved = true
        print("Profile saved: \(userProfile)")
        print(userProfile.name, userProfile.institution, userProfile.fieldOfStudy, userProfile.gradeLevel)
    }
}

#Preview {
    EditProfileView().environmentObject(UserProfile())
}

//    @State var institutions: [String] = ["               ", "NOT LISTED", "Alabama State University", "American University", "Arizona State University", "Arrupe College of Loyola University Chicago", "Auburn University", "Agustana College", "Aurora University", "Baldwin Wallace University", "Barnard College", "Beloit College", "Boston University", "Brandeis University", "Brown University", "Cal Poly", "California Baptist University", "Carleton College", "Carthage College", "Case Western Reserve University", "Chapman University", "Clemson University", "Colgate University", "Columbia College Chicago", "Columbia University in the City of New York", "Concordia University-Chicago", "Connecticut College", "Cornell University", "Dartmouth College", "DePaul University", "DePauw University", "Dominican University", "Drexel University", "Eastern Illinois University", "Elon University", "Embry-Riddle Aeronautical University-Daytona Beach", "Emerson College", "Emory University", "Fisher College", "Fisk University", "Florida Agricultural and Mechanical University", "Florida Atlantic University", "Florida State University", "Fordham University", "Franklin and Marshall College", "Georgetown University", "Georgia Institute of Technology-Main Campus", "Grand Valley State University", "Harold Washington College", "Harry S. Truman College", "Harvey Mudd College", "Hobart William Smith Colleges", "Howard University", "Illinois Institute of Technology", "Illinois State University", "Illinois Wesleyan University", "Indiana University-Bloomington", "Iowa State University", "Kendall College", "Kennedy-King College", "Kent State University at Kent", "Kenyon College", "Knox College", "Lake Forest College", "Lawrence University", "Lehigh University", "Lewis University", "Lincoln College of Technology-Melrose Park", "Loyola Marymount University", "Loyola University Chicago", "Macalester College", "Malcolm X College", "Marquette University", "Massachusetts College of Pharmacy in Health Sciences", "Miami University Oxford", "Michigan State University", "Milwaukee Area Technical College", "Milwaukee Institute of Art & Design", "Milwaukee School of Engineering", "Montana State University", "Morehouse College", "National Lewis University", "New York University", "North Carolina A&T State University", "North Carolina State University at Raleigh", "North Park University", "Northeastern Illinois University", "Northeastern University", "Northern Arizona University", "Northern Illinois University", "Northwestern State University of Louisiana", "Northwestern University", "Oakton Community College", "Oberlin College", "Occidental College", "Ohio State University-Main Campus", "Olivet Nazarene University", "Parkland College", "Pennsylvania State University-Penn State Main Campus", "Point Blank Music School", "Pomona College", "Pratt Institute-Main", "Princeton University", "Purdue University-Main Campus", "Reed College", "Rice University", "Richard J. Daley College", "Rochester Institute of Technology", "Roger Williams University", "Roosevelt University", "Rose-Hulman Institute of Technology", "Saint Louis University", "San Diego State University", "Savannah College of Art & Design", "School of the Art Institute of Chicago", "Smith College", "Southern Illinois University-Carbondale", "Southern Illinois University-Edwardsville", "St. John’s College", "Stanford University", "Suffolk University", "Syracuse University", "Temple University", "Tennessee State University", "Texas A&M University-College Station", "The College of Wooster", "The New School", "The University of Alabama", "The University of North Carolina at Chapel Hill", "The University of Tampa", "The University of Tennessee-Knoxville", "The University of Texas at Austin", "Trinity College Dublin", "Triton College", "Tulane University of Louisiana", "United States Coast Guard Academy", "United States Merchant Marine Academy", "United States Naval Academy", "University College Dublin", "University of Arizona", "University of California-Berkeley", "University of California-Los Angeles", "University of California-San Diego", "University of California-Santa Barbara", "University of Central Florida", "University of Chicago", "University of Colorado Boulder", "University of Dayton", "University of Delaware", "University of Denver", "University of Florida", "University of Hartford", "University of Illinois at Urbana-Champaign", "University of Illinois Chicago", "University of Indianapolis", "University of Iowa", "University of Kansas", "University of Maryland-College Park", "University of Massachusetts-Amherst", "University of Miami", "University of Michigan-Ann Arbor", "University of Minnesota-Twin Cities", "University of Missouri-Columbia", "University of Nebraska-Lincoln", "University of Notre Dame", "University of Oregon", "University of Pennsylvania", "University of Pittsburgh-Pittsburgh Campus", "University of Rochester", "University of San Diego", "University of San Francisco", "University of South Carolina-Columbia", "University of South Florida-Main Campus", "University of Southern California", "University of Southern Maine", "University of Sydney", "University of Vermont", "University of Virginia-Main Campus", "University of Washington-Seattle Campus", "University of Wisconsin-Madison", "University of Wisconsin-Superior", "Valparaiso University", "Vanderbilt University", "VanderCook College of Music", "Virginia Tech", "Washington University in St Louis", "Webster University", "Wheaton College", "Wilbur Wright College", "William Rainey Harper College", "Worcester Polytechnic Institute", "Xavier University", "Yale University"]
