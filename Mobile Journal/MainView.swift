//
//  MainView.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/16/21.
//

import SwiftUI


//Global constants


let views: Array<String> = ["Log In","Registration", "Calendar","Date", "Journal Entry","Journal Entry Confirm"]

let defaultUser = User(username: "", theme: defaultTheme, journalEntries: [], sliders: defaultSliders)

let defaultTheme = Theme(textColor: .white, primaryColor: .cyan, secondaryColor: .orange)

let defaultSliders = [
    SliderData(title: "Productivity", range: 10, creatorName: "default"),
    SliderData(title: "Creativity", range: 10, creatorName: "default"),
    SliderData(title: "Enjoyment", range: 10, creatorName: "default"),
    SliderData(title: "Efficiency", range: 5, creatorName: "default"),
    SliderData(title: "Social Activity", range: 5, creatorName: "default"),
    SliderData(title: "Fitness", range: 5, creatorName: "default"),
    SliderData(title: "Hygiene", range: 5, creatorName: "default")
]


//Private constants


//dataFormatter returns the current date in a shorthand style (MM/DD/YY)
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()


//Data Structs

struct User {
    var username: String
    var theme: Theme
    var journalEntries: Array<JournalEntry>
    var sliders: Array<SliderData>
}

struct JournalEntry {
    var day: Int
    var month: Int
    var year: Int
    var sliders: Array<SliderData>
    var sliderChoices: Array<Int>
    var description: String
}

struct SliderData {
    var title: String
    var range: Int
    var creatorName: String
}

struct Theme {
    var textColor: Color
    var primaryColor: Color
    var secondaryColor: Color
}

struct CalendarDate {
    var day: Int
    var month: Int
    var year: Int
}


//Primary view


struct MainView: View {
    @State var user: User
    @State var date: CalendarDate
    
    
    init() {
        self.user = defaultUser
        //gets the fields for the current date
        let dateFields = getDateToday(formattedDate: dateFormatter.string(from: Date()))
        //parses those fields into a CalendarDate object
        self.date = CalendarDate(day: dateFields.day, month: dateFields.month, year: dateFields.year)
    }
    
    var body: some View {
        if(!userIsLoggedIn(user: self.user)) {
            NavPreLogInView( user: self.$user)
        }
        else {
            NavPostLogInView(user: self.$user, date: self.$date)
        }
    }
}


//Primary functions


/*
 This function gets the month, date, and year in integer format
 Parameters:
    formattedDate: The date as formatted by the formattedDate constant
 Returns:
    Tuple:
        month: The current month
        date: The current date
        year: The current year
 */
func getDateToday(formattedDate: String) -> (month: Int, day: Int, year: Int) {
    //Gets the date (MM/DD/YY)
    let dateFields: Array<Substring> = formattedDate.split(separator: "/")
    //Ensures the correct amount of fields were found and casts them from substring -> string -> int or returns 0 if casting fails
    if(dateFields.count == 3) {
        return (
            month: Int(String(dateFields[0])) ?? 0,
            day: Int(String(dateFields[1])) ?? 0,
            year: Int("20\(String(dateFields[2]))") ?? 0
        )
    }
    //Returns 0 if wrong number of date fields received
    else {
        return (month: 0, day: 0, year: 0)
    }
}


//Helper functions


/*
 This function returns a boolean value denoting whether a user is logged in or not
 Parameters:
    User: The user state of MainView
 Returns:
    Bool: Boolean value denoting whether there is a user logged in
 */
func userIsLoggedIn(user: User) -> Bool {
    user.username == "" ? false: true
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
            }.navigationTitle("Log In / Register").navigationBarTitleDisplayMode(.inline)
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
    @Binding var date: CalendarDate
    
    var body: some View {
        NavigationView {
            VStack {
                NavLogOutView(user: self.$user)
                NavCalendarView(user: self.$user, date: $date)
                NavJournalEntryView(user: self.$user, date: $date)
            }.navigationTitle("Navigation").navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct NavLogOutView: View {
    @Binding var user: User
    
    var body: some View {
        NavigationLink(destination: LogInView(user: self.$user)) {
            Button(action: {
                if(logOutUser()) {
                    /*TODO: continue to login page*/
                }
                else {
                    /*
                     TODO: throw error for failed logout
                     */
                }
            }) {
                NavTextView(text: "Log Out", textColor1: user.theme.textColor, textColor2: user.theme.secondaryColor, buttonColor: user.theme.primaryColor)
            }
        }
    }
}

struct NavCalendarView: View {
    @Binding var user: User
    @Binding var date: CalendarDate
    
    var body: some View {
        NavigationLink(destination: CalendarView(today: $date, user: $user)) {
            NavTextView(text: "Calendar", textColor1: user.theme.textColor, textColor2: user.theme.primaryColor, buttonColor: user.theme.secondaryColor)
        }
    }
}

struct NavJournalEntryView: View {
    @Binding var user: User
    @Binding var date: CalendarDate
    
    var body: some View {
        NavigationLink(destination: JournalEntryView(today: $date, user: $user)) {
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
