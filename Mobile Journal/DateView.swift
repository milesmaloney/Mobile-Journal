//
//  DateView.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/16/21.
//

import SwiftUI

struct DateView: View {
    @Binding var selectedDate: CalendarDate
    @Binding var user: User
    
    var body: some View {
        VStack {
            DateHeaderView(date: self.$selectedDate, tc1: self.$user.theme.textColor, tc2: self.$user.theme.secondaryColor, bgc: self.$user.theme.primaryColor)
            Spacer()
            Text("You have selected \(selectedDate.month)/\(selectedDate.day)/\(String(selectedDate.year))")
            Spacer()
        }.navigationTitle("\(selectedDate.month)/\(selectedDate.day)/\(String(selectedDate.year))").navigationBarTitleDisplayMode(.inline).toolbar {
            NavBarSettingsView(user: self.$user)
        }
    }
}

struct DateView_Previews: PreviewProvider {
    static var previews: some View {
        DateView(selectedDate: .constant(CalendarDate(day: 31, month: 12, year: 2021)), user: .constant(defaultUser))
    }
}
