//
//  CalendarView.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/15/21.
//

import SwiftUI


//Global Constants

//Initializes months to a constant for ease of use (only February has potential changes)
let months = [
    Month(number: 1, name: "January", numDays: 31),
    //NOTE: leap years must be checked for separately
    Month(number: 2, name: "February", numDays: 28),
    Month(number: 3, name: "March", numDays: 31),
    Month(number: 4, name: "April", numDays: 30),
    Month(number: 5, name: "May", numDays: 31),
    Month(number: 6, name: "June", numDays: 30),
    Month(number: 7, name: "July", numDays: 31),
    Month(number: 8, name: "August", numDays: 31),
    Month(number: 9, name: "September", numDays: 30),
    Month(number: 10, name: "October", numDays: 31),
    Month(number: 11, name: "November", numDays: 30),
    Month(number: 12, name: "December", numDays: 31)
]


//Primary view


/*
 Bindings:
    today: Today's date in CalendarDate form
    user: The current user as a User object
 States:
    selectedMonth: The currently selected month on the calendar
    selectedYear: The currently selected year on the calendar
 */
struct CalendarView: View {
    @Binding var today: CalendarDate
    @Binding var user: User
    
    @State var selectedMonth: Month
    @State var selectedYear: Int
    
    init(today: Binding<CalendarDate>, user: Binding<User>) {
        self._today = today
        self._user = user
        self.selectedYear = today.wrappedValue.year
        //Uses getMonthsByYear to check for a possible leap year exception
        self.selectedMonth = getMonthsByYear(year: today.wrappedValue.year)[today.wrappedValue.month - 1]
    }
    
    var body: some View {
        VStack {
            CalendarMonthAndYearView(monthName: self.$selectedMonth.name, year: self.$selectedYear, theme: self.$user.theme)
            Spacer()
            CalendarMonthView(month: self.$selectedMonth, year: self.$selectedYear, today: self.$today, user: self.$user)
            Spacer()
        }.navigationTitle("Calendar").navigationBarTitleDisplayMode(.inline)
    }
}


//Primary functions



//Helper functions

/*
 This function returns the months with leap years accounted for based on the year
 Parameters:
    year: The year we want to check for a leap year
 Returns:
    returnedMonths: the resulting array of months with leap years accounted for
 */
func getMonthsByYear(year: Int) -> Array<Month> {
    var returnedMonths = months
    if(isLeapYear(year: year)) {
        returnedMonths[1].numDays = 29
    }
    return returnedMonths
}

/*
 This function checks if the given year is a leap year
 Parameters:
    year: The year we want to check for
 Returns:
    Boolean: value denoting whether or not the given year is a leap year
 */
func isLeapYear(year: Int) -> Bool{
    year % 4 == 0 ? true: false
}



/*
 This function returns the number of weeks in a given month
 Parameters:
    month: The month we want the number of weeks for
 Returns:
    calendarWeeks: The amount of calendar weeks in the given month
 */
func getNumCalendarWeeks(numDaysInMonth: Int) -> Int {
    //Gets the number of calendar weeks in a month by dividing by 7
    var calendarWeeks = numDaysInMonth / 7
    //Handles any remaining days that don't make up a full week using mod operator
    if(numDaysInMonth % 7 != 0) {
        calendarWeeks += 1
    }
    return calendarWeeks
}

/*
 This function checks a given full date, and returns whether or not the user has a journal entry for the given date
 Parameters:
    date: The exact date we are checking
    month: The month the date is in
    year: The year the month is in
 Returns:
    Bool: A boolean value denoting whether or not a journal entry exists for the given date
 */
//TODO: Create proper function to check if a date has been journaled on. Need further functionality to complete
func dateJournaled(day: Int, month: Int, year: Int) -> Bool {
    return Bool.random()
}

/*
 This function checks if the given date is today's date and if the journal has been written, and returns true if the entry still needs to be written for the current day
 Parameters:
    day: The day of the selected date
    month: The month of the selected date
    year: The year of the selected date
    today: The CalendarDate representation of today's date
 Returns:
    Bool: A boolean value denoting whether or not the journal entry for today still needs to be completed
 */
func dateIsTodayWithNoJournal(day: Int, month: Int, year: Int, today: CalendarDate) -> Bool {
    if(year == today.year) {
        if(month == today.month) {
            if(day == today.day) {
                if(!dateJournaled(day: day, month: month, year: year)) {
                    return true
                }
            }
        }
    }
    return false
}

/*
 This function gets the color for the given date depending on whether or not the user wrote a journal entry for the given day
 Parameters:
    date: The date we are checking
    month: The month the date is in
    year: The year the month is in
    theme: The current user's theme
 Returns:
    Color: The color object specified by the user's theme
 */
func getDateColor(day: Int, month: Int, year: Int, today: CalendarDate, user: User) -> Color {
    if(dateIsTodayWithNoJournal(day: day, month: month, year: year, today: today)) {
        return .yellow
    }
    if(dateJournaled(day: day, month: month, year: year)) {
        return user.theme.primaryColor
    }
    return user.theme.secondaryColor
}


//Structs


struct Month {
    var number: Int
    var name: String
    var numDays: Int
}


//Extracted Subviews


struct CalendarMonthAndYearView: View {
    @Binding var monthName: String
    @Binding var year: Int
    @Binding var theme: Theme
    
    var body: some View {
        ZStack {
            CalendarMYBGView(monthName: self.$monthName)
            CalendarMYTextView(monthName: self.$monthName, year: self.$year, theme: self.$theme)
        }
    }
}

struct CalendarMYBGView: View {
    @Binding var monthName: String
    
    var body: some View {
        Image(self.monthName).resizable().aspectRatio(contentMode: .fill).frame(height: 200)
    }
}

struct CalendarMYTextView: View {
    @Binding var monthName: String
    @Binding var year: Int
    @Binding var theme: Theme
    
    var body: some View {
        HStack {
            CalendarZStackTextView(text: self.$monthName, theme: self.$theme)
            CalendarZStackTextView(text: .constant(String(self.year)), theme: self.$theme)
        }
    }
}

struct CalendarZStackTextView: View {
    @Binding var text: String
    @Binding var theme: Theme
    
    var body: some View {
        ZStack {
            Text(self.text).font(.largeTitle).fontWeight(.bold).foregroundColor(theme.textColor)
            Text(self.text).font(.largeTitle).fontWeight(.semibold)
        }
    }
}

struct CalendarMonthView: View {
    @Binding var month: Month
    @Binding var year: Int
    @Binding var today: CalendarDate
    @Binding var user: User
    
    var body: some View {
        VStack {
            //Loops through each week in the month, adding a CalendarWeekView row for each
            ForEach(0..<getNumCalendarWeeks(numDaysInMonth: month.numDays)) { week in CalendarWeekView(week: .constant(week), month: self.$month, year: self.$year, today: self.$today, user: self.$user)
                
            }
        }
    }
}

struct CalendarWeekView: View {
    @Binding var week: Int
    @Binding var month: Month
    @Binding var year: Int
    @Binding var today: CalendarDate
    @Binding var user: User
    
    var body: some View {
        HStack {
            //Loops through each day in the week, creating a CalendarDayView for each day in the week
            ForEach(1..<8) {
                day in CalendarDayView(day: .constant(day + (self.week * 7)), month: self.$month, year: self.$year, today: self.$today, user: self.$user)
            }
        }
    }
}

struct CalendarDayView: View {
    @Binding var day: Int
    @Binding var month: Month
    @Binding var year: Int
    @Binding var today: CalendarDate
    @Binding var user: User
    
    var body: some View {
        if(self.day <= month.numDays) {
            NavigationLink(destination: DateView(selectedDate: .constant(CalendarDate(day: self.day, month: self.month.number, year: self.year)), user: self.$user)) {
                Text("\(day)").font(.title3).foregroundColor(user.theme.textColor).frame(width: 35, height: 35).background(getDateColor(day: self.day, month: self.month.number, year: self.year, today: self.today, user: self.user)).cornerRadius(30.0)
            }
        }
    }
}


//Debug functions


struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(today: .constant(CalendarDate(day: 31, month: 12, year: 2021)), user: .constant(defaultUser))
    }
}


