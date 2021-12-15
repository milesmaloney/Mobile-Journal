//
//  CalendarView.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/15/21.
//

import SwiftUI

struct CalendarView: View {
    @State var monthOffset: Int = 0
    
    var body: some View {
        VStack {
            CalendarMonthAndYearView()
            Spacer()
            CalendarDateView()
            Spacer()
        }
    }
}

//Primary functions



//Helper functions

func getDateField() -> String {
    return getFieldsFromDate(formattedDate: dateFormatter.string(from: Date())).month
}

func getMonthField() -> String {
    return getFieldsFromDate(formattedDate: dateFormatter.string(from: Date())).month
}

func getYearField() -> String {
    return getFieldsFromDate(formattedDate: dateFormatter.string(from: Date())).year
}

func yearFieldToFullYear(year: String) -> String {
    let century: String = "20"
    return century + year
}

func monthFieldToMonthName(month: String) -> String {
    switch Int(month) {
    case 1:
        return "January"
    case 2:
        return "February"
    case 3:
        return "March"
    case 4:
        return "April"
    case 5:
        return "May"
    case 6:
        return "June"
    case 7:
        return "July"
    case 8:
        return "August"
    case 9:
        return "September"
    case 10:
        return "October"
    case 11:
        return "November"
    case 12:
        return "December"
    default:
        return "Unknown Month"
    }
}

func getCurrMonthName() -> String {
    return monthFieldToMonthName(month: getMonthField())
}

func getCurrFullYear() -> String {
    return yearFieldToFullYear(year: getYearField())
}


private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()

func getFieldsFromDate(formattedDate: String) -> (month: String, date: String, year: String) {
    //Gets the date (MM/DD/YY)
    let dateFields: Array<Substring> = formattedDate.split(separator: "/")
    if(dateFields.count == 3) {
        return (String(dateFields[0]), String(dateFields[1]), String(dateFields[2]))
    }
    else {
        return ("0","0","0")
    }
}

func getNumCalendarDays(month: String, year: String) -> Int {
    switch Int(month) {
    case 1:
        return 31
    case 2:
        //! aborts execution if year cannot be cast to int
        if(Int(year)! % 4 == 0) {
            return 29
        }
        return 28
    case 3:
        return 31
    case 4:
        return 30
    case 5:
        return 31
    case 6:
        return 30
    case 7:
        return 31
    case 8:
        return 31
    case 9:
        return 30
    case 10:
        return 31
    case 11:
        return 30
    case 12:
        return 31
    default:
        return 0
    }
}

func getOffsetMonthAndYear(month: Int, year: Int, monthOffset: Int) -> (month: Int, year: Int) {
    //Will truncate yearOffset so any year offset < 1 is negated
    let yearOffset: Int = Int(monthOffset / 12)
    //Subtracting 1 & adding back after mod ensures the months match up with no 0th month
    let monthOffsetWithinYear: Int = (monthOffset - 1 % 12) + 1
    let yearAfterOffset: Int = year + yearOffset
    let monthAfterOffset: Int = month + monthOffsetWithinYear
    return (month: monthAfterOffset, year: yearAfterOffset)
}

func getNumCalendarWeeks(month: String, year: String) -> Int {
    var calendarWeeks = getNumCalendarDays(month: month, year: year) / 7
    if(getNumCalendarDays(month: month, year: year) % 7 != 0) {
        calendarWeeks += 1
    }
    return calendarWeeks
}

//TODO: Create proper function to check if a date has been journaled on. Need further functionality to complete
func dateJournaled(date: String, month: String, year: String) -> Bool {
    return Bool.random()
}

func getDateColor(date: String, month: String, year: String) -> Color {
    if(dateJournaled(date: date, month: month, year: year)) {
        return .cyan
    }
    return .orange
}

//Extracted Subviews


struct CalendarMonthAndYearView: View {
    var body: some View {
        ZStack {
            CalendarMYBGView()
            CalendarMYTextView()
        }
    }
}

struct CalendarMYBGView: View {
    var body: some View {
        Image(getCurrMonthName()).resizable().aspectRatio(contentMode: .fill).frame(height: 300)
    }
}

struct CalendarMYTextView: View {
    var body: some View {
        HStack {
            ZStack {
                Text(getCurrMonthName()).font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                Text(getCurrMonthName()).font(.largeTitle).fontWeight(.semibold)
            }
            ZStack {
                Text(getCurrFullYear()).font(.largeTitle).fontWeight(.bold).foregroundColor(.white)
                Text(getCurrFullYear()).font(.largeTitle).fontWeight(.semibold)
            }
        }
    }
}


struct CalendarDateView: View {
    var body: some View {
        VStack {
            ForEach(0..<(getNumCalendarWeeks(month: getMonthField(), year: getYearField()))) { i in
                HStack {
                    ForEach(1..<8) { j in
                        if(j + (7 * i) <= getNumCalendarDays(month: getMonthField(), year: getYearField())) {
                            //Calendar dates go here
                            Text("\(j + (7 * i))").font(.title3).frame(width: 45, height: 45).background(getDateColor(date: ("\(j + (7 * i))"), month: getMonthField(), year: getYearField())).foregroundColor(.white).cornerRadius(30.0)
                        }
                    }
                }
            }
        }
    }
}




//Debug functions


struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
