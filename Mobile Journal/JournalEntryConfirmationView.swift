//
//  JournalEntryConfirmationView.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/16/21.
//

import SwiftUI


//Primary View


struct JournalEntryConfirmationView: View {
    @Binding var date: CalendarDate
    @Binding var user: User
    @Binding var values: Array<Float>
    @Binding var description: String
    
    
    var body: some View {
        ScrollView {
            DateHeaderView(date: self.$date, tc1: self.$user.theme.textColor, tc2: self.$user.theme.secondaryColor, bgc: self.$user.theme.primaryColor)
            ConfirmSliderValuesView(sliders: self.$user.sliders, values: self.$values, theme: self.$user.theme)
            JournalEntryDescriptionView(additionalDescription: self.$description, tc: self.$user.theme.textColor, stc: self.$user.theme.primaryColor)
            ConfirmEntryButtonView(user: self.$user, values: self.$values, description: self.$description)
        }.frame(width: 350).navigationTitle("Journal Entry Confirmation").navigationBarTitleDisplayMode(.inline)
    }
}


//Primary functions


/*
 This function will submit the journal entry and add it to the calendar
 Parameters:
    user: The user data for the user that is currently active
    sliders: The sliders used for the current journal entry
    values: The values given for each slider
    additionalDescription: The additional daily description given by the user
 Returns:
    Bool: A boolean value denoting whether or not the operation was successful
 */
func submitJournalEntry(user: User, sliders: Array<SliderData>, values: Array<Float>, additionalDescription: String) -> Bool {
    //TODO: Create a proper back-end implementation for submitting a journal entry
    return true
}


//Extracted Subviews


struct ConfirmSliderValuesView: View {
    @Binding var sliders: Array<SliderData>
    @Binding var values: Array<Float>
    @Binding var theme: Theme
    
    var body: some View {
        ForEach(0..<self.sliders.count, id: \.self) { slider in
            HStack {
                ShadowTextView(text: .constant("\(self.sliders[slider].title): "), tc: getNoBGTextColor(tc: self.theme.textColor), stc: self.$theme.secondaryColor, fontType: .constant(.title2))
                ShadowTextView(text: .constant("\(String(Int(self.values[slider])))"), tc: getNoBGTextColor(tc: self.theme.textColor), stc: self.$theme.primaryColor, fontType: .constant(.title2))
            }.padding(.top, 20)
        }
    }
}

struct ConfirmEntryButtonView: View {
    @Binding var user: User
    @Binding var values: Array<Float>
    @Binding var description: String
    
    var body: some View {
        Button(action: {
            if(submitJournalEntry(user: self.user, sliders: self.user.sliders, values: self.values, additionalDescription: self.description )) {
                //Return to calendar
            }
            else {
                //Throw error
            }
        }) {
            ButtonView(text: .constant("Confirm Entry"), tc1: self.$user.theme.textColor, tc2: self.$user.theme.primaryColor, bgc: self.$user.theme.secondaryColor)
        }
    }
}



//Debug functions


struct JournalEntryConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        JournalEntryConfirmationView(date: .constant(CalendarDate(day: 31, month: 12, year: 2021)), user: .constant(defaultUser), values: .constant(Array(repeating: 2, count: defaultSliders.count)), description: .constant("Today I saw a rainbow. It was very pretty."))
    }
}
