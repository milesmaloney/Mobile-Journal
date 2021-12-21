//
//  DateView.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/16/21.
//

import SwiftUI

struct DateView: View {
    @Binding var selectedDate: CalendarDate
    
    var body: some View {
        VStack {
            Text("You have selected \(selectedDate.month)/\(selectedDate.day)/\(String(selectedDate.year))")
        }.navigationTitle("\(selectedDate.month)/\(selectedDate.day)/\(String(selectedDate.year))").navigationBarTitleDisplayMode(.inline)
    }
}

struct DateView_Previews: PreviewProvider {
    static var previews: some View {
        DateView(selectedDate: .constant(CalendarDate(day: 31, month: 12, year: 2021)))
    }
}
