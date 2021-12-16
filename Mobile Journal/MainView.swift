//
//  MainView.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/16/21.
//

import SwiftUI

//Global variables
var activeView: String = "Log In"
var user: String = ""
var selectedDate: String = ""
var hasJournaledToday: Bool = false

//Global constants
let views: Array<String> = ["Log In","Registration", "Calendar","Date", "Journal Entry","Journal Entry Confirm"]

struct MainView: View {
    @Binding var activeView: String
    init() {
        self._activeView = .constant("Log In")
    }
    var body: some View {
        if(self.activeView == "Log In") {
            LogInView()
        }
        else if(self.activeView == "Registration") {
            RegistrationView()
        }
        else {
            NavigationView {
                NavigationLink(destination: LogInView()) {
                    Button(action: logOut) {
                        Text("Log Out")
                    }
                }
                NavigationLink(destination: CalendarView()) {
                    Button(action: {changeActiveView(newView: "Calendar")}) {
                        Text("Calendar")
                    }
                }
                NavigationLink(destination: JournalEntryView()) {
                    Button(action: {changeActiveView(newView: "Journal Entry")}) {
                        Text("Today's Journal Entry")
                    }
                }
            }
        }
    }
}

func changeActiveView(newView: String) -> Void {
    activeView = newView
}

func logOut() -> Void{
    user = ""
    changeActiveView(newView: "Log In")
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
