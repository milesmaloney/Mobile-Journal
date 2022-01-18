//
//  MainView.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/16/21.
//

import SwiftUI


//Global constants


let views: Array<String> = ["Log In","Registration", "Calendar","Date", "Journal Entry","Journal Entry Confirm"]

let defaultUser = User(username: "default", theme: defaultTheme, journalEntries: [], sliders: defaultSliders)

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
    @State var isLoggedIn: Bool = false
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
        if(!isLoggedIn) {
            NavPreLogInView(user: self.$user, isLoggedIn: self.$isLoggedIn)
        }
        else {
            NavPostLogInView(user: self.$user, date: self.$date, isLoggedIn: self.$isLoggedIn)
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




//Extracted Subviews (high level to low level)

//Pre-log in views
struct NavPreLogInView: View {
    @Binding var user: User
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                NavLogInView(user: self.$user, isLoggedIn: self.$isLoggedIn)
                NavRegistrationView(user: self.$user)
            }.navigationTitle("Log In / Register").navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct NavLogInView: View {
    @Binding var user: User
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        NavigationLink(destination: LogInView(user: self.$user, isLoggedIn: self.$isLoggedIn)) {
            ButtonView(text: .constant("Log In"), tc1: self.$user.theme.textColor, tc2: self.$user.theme.secondaryColor, bgc: self.$user.theme.primaryColor)
        }
    }
}

struct NavRegistrationView: View {
    @Binding var user: User
    
    var body: some View {
        NavigationLink(destination: RegistrationView(theme: self.$user.theme)) {
            ButtonView(text: .constant("Register"), tc1: self.$user.theme.textColor, tc2: self.$user.theme.primaryColor, bgc: self.$user.theme.secondaryColor)
        }
    }
}

//Post-log in views
struct NavPostLogInView: View {
    @Binding var user: User
    @Binding var date: CalendarDate
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                NavLogOutView(user: self.$user, isLoggedIn: self.$isLoggedIn)
                NavCalendarView(user: self.$user, date: self.$date)
                NavJournalEntryView(user: self.$user, date: self.$date)
                NavSettingsView(user: self.$user)
            }.navigationTitle("Navigation").navigationBarTitleDisplayMode(.inline).toolbar {
                NavBarSettingsView(user: self.$user)
            }
        }
    }
}

struct NavLogOutView: View {
    @Binding var user: User
    @Binding var isLoggedIn: Bool
    @State var alert: Alert = Alert(title: Text("Error"), message: Text("ERROR: Log-out not yet meant to be attempted. Please restart the app and try again."))
    @State var alertIsPresented: Bool = false
    
    var body: some View {
        NavigationLink(destination: LogInView(user: self.$user, isLoggedIn: self.$isLoggedIn)) {
            Button(action: {
                let result = logOutUser()
                if(result.success) {
                    self.alert = Alert(title: Text("Logged out successfully"), message: Text("You have been successfully logged out."), dismissButton: .default(Text("Dismiss"), action: {
                        self.isLoggedIn = false
                    }))
                }
                else {
                    self.alert = Alert(title: Text("Log out failed"), message: Text(result.errorString))
                }
                self.alertIsPresented = true
            }) {
                ButtonView(text: .constant("Log Out"), tc1: self.$user.theme.textColor, tc2: self.$user.theme.secondaryColor, bgc: self.$user.theme.primaryColor)
            }.alert(isPresented: self.$alertIsPresented) {
                self.alert
            }
        }
    }
}

struct NavCalendarView: View {
    @Binding var user: User
    @Binding var date: CalendarDate
    
    var body: some View {
        NavigationLink(destination: CalendarView(today: self.$date, user: self.$user)) {
            ButtonView(text: .constant("Calendar"), tc1: self.$user.theme.textColor, tc2: self.$user.theme.primaryColor, bgc: self.$user.theme.secondaryColor)
        }
    }
}

struct NavJournalEntryView: View {
    @Binding var user: User
    @Binding var date: CalendarDate
    
    var body: some View {
        NavigationLink(destination: JournalEntryView(today: self.$date, user: self.$user)) {
            ButtonView(text: .constant("Journal Entry"), tc1: self.$user.theme.textColor, tc2: self.$user.theme.secondaryColor, bgc: self.$user.theme.primaryColor)
        }
    }
}

struct NavSettingsView: View {
    @Binding var user: User
    
    var body: some View {
        NavigationLink(destination: SettingsView(user: self.$user)) {
            ButtonView(text: .constant("Settings"), tc1: self.$user.theme.textColor, tc2: self.$user.theme.primaryColor, bgc: self.$user.theme.secondaryColor)
        }
    }
}


//Debug functions


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
