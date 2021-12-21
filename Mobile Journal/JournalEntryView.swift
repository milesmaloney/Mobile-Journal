//
//  JournalEntryView.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/16/21.
//

import SwiftUI

struct JournalEntryView: View {
    @Binding var today: CalendarDate
    
    var body: some View {
        VStack {
            Text("JOURNAL_ENTRY_VIEW_PLACEHOLDER")
        }.navigationTitle("Journal Entry").navigationBarTitleDisplayMode(.inline)
        
    }
}

struct JournalEntryView_Previews: PreviewProvider {
    static var previews: some View {
        JournalEntryView(today: .constant(CalendarDate(day: 31, month: 12, year: 2021)))
    }
}
