//
//  MainView.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/16/21.
//

import SwiftUI


//Global constants


let views: Array<String> = ["Log In","Registration", "Calendar","Date", "Journal Entry","Journal Entry Confirm"]

let defaultUser = User(username: "", passwordHash: "NO_PASSWORD", theme: defaultTheme, journalEntries: [])

let defaultTheme = Theme(textColor:z .red, primaryColor: .purple, secondaryColor: .green)


//Main view


struct MainView: View {
    @State var user: User
    
    
    init() {
        self.user = defaultUser
    }
    
    var body: some View {
        if(!userIsLoggedIn(user: self.user)) {
            NavPreLogInView( user: self.$user)
        }
        else {
            NavPostLogInView(user: self.$user)
        }
    }
}


//Primary functions



func logOut(user: inout User) -> Void{
    user = defaultUser
}


//Helper functions


func userIsLoggedIn(user: User) -> Bool {
    user.username == "" ? false: true
}

//Data Structs

struct User {
    var username: String
    var passwordHash: String
    var theme: Theme
    var journalEntries: Array<JournalEntry>
}

struct JournalEntry {
    var day: Int
    var month: Int
    var year: Int
    var sliders: Array<Slider>
    var sliderChoices: Array<Int>
    var description: String
}

struct Slider {
    var title: String
    var range: Int
    var creatorName: String
}

struct Theme {
    var textColor: Color
    var primaryColor: Color
    var secondaryColor: Color
}

//Extracted Subviews (high level to low level)

//Pre-log in views
struct NavPreLogInView: View {
    @Binding var user: User
    
    var body: some View {
        NavigationView {
            VStack {
                NavLogInView(user: self.$user)
                NavRegistrationView(user: self.$user)
            }
        }
    }
}

struct NavLogInView: View {
    @Binding var user: User
    
    var body: some View {
        NavigationLink(destination: LogInView(user: self.$user)) {
            NavTextView(text: "Log In", textColor1: self.user.theme.textColor, textColor2: self.user.theme.secondaryColor, buttonColor: self.user.theme.primaryColor)
        }
    }
}

struct NavRegistrationView: View {
    @Binding var user: User
    
    var body: some View {
        NavigationLink(destination: RegistrationView(theme: self.$user.theme)) {
            NavTextView(text: "Register", textColor1: self.user.theme.textColor, textColor2: self.user.theme.primaryColor, buttonColor: self.user.theme.secondaryColor)
        }
    }
}

//Post-log in views
struct NavPostLogInView: View {
    @Binding var user: User
    
    var body: some View {
        NavigationView {
            VStack {
                NavLogOutView(user: self.$user)
                NavCalendarView(user: self.$user)
                NavJournalEntryView(user: self.$user)
            }
        }
    }
}

struct NavLogOutView: View {
    @Binding var user: User
    
    var body: some View {
        NavigationLink(destination: LogInView(user: self.$user)) {
            Button(action: {
                logOut(user: &self.user)
            }) {
                NavTextView(text: "Log Out", textColor1: user.theme.textColor, textColor2: user.theme.secondaryColor, buttonColor: user.theme.primaryColor)
            }
        }
    }
}

struct NavCalendarView: View {
    @Binding var user: User
    
    var body: some View {
        NavigationLink(destination: CalendarView()) {
            NavTextView(text: "Calendar", textColor1: user.theme.textColor, textColor2: user.theme.primaryColor, buttonColor: user.theme.secondaryColor)
        }
    }
}

struct NavJournalEntryView: View {
    @Binding var user: User
    
    var body: some View {
        NavigationLink(destination: JournalEntryView()) {
            NavTextView(text: "Journal Entry", textColor1: user.theme.textColor, textColor2: user.theme.secondaryColor, buttonColor: user.theme.primaryColor)
        }
    }
}

//General views
struct NavTextView: View {
    var text: String
    var textColor1: Color
    var textColor2: Color
    var buttonColor: Color
    
    var body: some View {
        ZStack {
            Text("\(text)").font(.largeTitle).fontWeight(.bold).foregroundColor(textColor2).frame(width: 300, height: 100).background(buttonColor).cornerRadius(10.0)
            Text("\(text)").font(.largeTitle).fontWeight(.semibold).foregroundColor(textColor1)
        }
    }
}


//Debug functions


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
