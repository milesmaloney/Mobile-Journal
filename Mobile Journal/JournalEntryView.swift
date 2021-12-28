//
//  JournalEntryView.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/16/21.
//

import SwiftUI


//Primary View


struct JournalEntryView: View {
    @Binding var today: CalendarDate
    @Binding var user: User
    
    @State var sliderValues: [Float]
    @State var additionalDescription: String
    
    init(today: Binding<CalendarDate>, user: Binding<User>) {
        self._today = today
        self._user = user
        self.sliderValues = Array(repeating: 0, count: user.wrappedValue.sliders.count)
        self.additionalDescription = ""
    }
    
    var body: some View {
        ScrollView {
            Text("\(today.month)/\(today.day)/\(String(today.year))").font(.title).fontWeight(.semibold).foregroundColor(user.theme.textColor).frame(width: 375, height: 75).background(user.theme.primaryColor)
            Spacer()
            JournalEntrySlidersView(userSliders: $user.sliders, sliderValues: $sliderValues)
            Spacer()
            JournalEntryDescriptionView(additionalDescription: $additionalDescription)
            
            Spacer()
            JournalEntrySubmitButtonView(user: $user, sliderValues: $sliderValues, additionalDescription: $additionalDescription)
            Spacer()
        }.frame(width: 350).navigationTitle("Journal Entry").navigationBarTitleDisplayMode(.inline)
        
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
    return true
}


//Extracted Subviews


struct JournalEntrySubmitTextView: View {
    @Binding var theme: Theme
    
    var body: some View {
        ZStack {
            Text("Submit").font(.largeTitle).fontWeight(.bold).frame(width: 250, height: 100).foregroundColor(theme.primaryColor).background(theme.secondaryColor).cornerRadius(20.0)
            Text("Submit").font(.largeTitle).fontWeight(.semibold).frame(width: 250, height: 100).foregroundColor(theme.textColor)
        }
    }
}

struct JournalEntrySubmitButtonView: View {
    @Binding var user: User
    @Binding var sliderValues: Array<Float>
    @Binding var additionalDescription: String
    
    var body: some View {
        Button(action: {
            if (submitJournalEntry(user: user, sliders: user.sliders, values: sliderValues, additionalDescription: additionalDescription)) {
            //CONTINUE
            }
            else {
               //TODO: handle error submitting journal entry
            }
        }) {
            JournalEntrySubmitTextView(theme: $user.theme)
        }
    }
}

struct JournalEntrySingleSliderView: View {
    @Binding var userSliders: Array<SliderData>
    @Binding var sliderValues: Array<Float>
    @Binding var slider: Int
    
    var body: some View {
        Text(userSliders[slider].title).font(.title2).padding(.top, 50)
        HStack {
            Text("0").foregroundColor(.gray)
            Slider(value: $sliderValues[slider], in: 0...Float(userSliders[slider].range), step: 1.0) {
            }.frame(width: 250, height: 20)
            Text("\(String(userSliders[slider].range))").foregroundColor(.gray)
        }
        Text("\(Int(sliderValues[slider]))")
    }
}

struct JournalEntrySlidersView: View {
    @Binding var userSliders: Array<SliderData>
    @Binding var sliderValues: Array<Float>
    
    
    var body: some View {
        ForEach(0..<userSliders.count, id: \.self) { slider in
            JournalEntrySingleSliderView(userSliders: $userSliders, sliderValues: $sliderValues, slider: .constant(slider))
        }
    }
}

struct JournalEntryDescriptionView: View {
    @Binding var additionalDescription: String
    
    var body: some View {
        Text("How was your day?").font(.title2).padding(.top, 25)
        TextEditor(text: $additionalDescription).frame(height: 150).border(.secondary).padding(.bottom, 25)
    }
}



//Debug functions


struct JournalEntryView_Previews: PreviewProvider {
    static var previews: some View {
        JournalEntryView(today: .constant(CalendarDate(day: 31, month: 12, year: 2021)), user: .constant(defaultUser))
    }
}
