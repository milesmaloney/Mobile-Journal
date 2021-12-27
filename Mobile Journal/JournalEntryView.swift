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
            Text("\(today.month)/\(today.day)/\(String(today.year))").font(.title3).fontWeight(.semibold)
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


func submitJournalEntry(user: User, sliders: Array<SliderData>, values: Array<Float>, additionalDescription: String) {
    
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
        Button(action: { submitJournalEntry(user: user, sliders: user.sliders, values: sliderValues, additionalDescription: additionalDescription)
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
        Text(userSliders[slider].title).font(.title2)
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
            Spacer()
            JournalEntrySingleSliderView(userSliders: $userSliders, sliderValues: $sliderValues, slider: .constant(slider))
            Spacer()
        }
    }
}

struct JournalEntryDescriptionView: View {
    @Binding var additionalDescription: String
    
    var body: some View {
        Text("How was your day?").font(.title2)
        TextEditor(text: $additionalDescription).frame(height: 150).border(.secondary)
    }
}



//Debug functions


struct JournalEntryView_Previews: PreviewProvider {
    static var previews: some View {
        JournalEntryView(today: .constant(CalendarDate(day: 31, month: 12, year: 2021)), user: .constant(defaultUser))
    }
}
