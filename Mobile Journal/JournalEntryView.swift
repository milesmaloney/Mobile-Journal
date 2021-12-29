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
            DateHeaderView(date: self.$today, tc1: self.$user.theme.textColor, tc2: self.$user.theme.primaryColor, bgc: self.$user.theme.secondaryColor)
            Spacer()
            JournalEntrySlidersView(userSliders: self.$user.sliders, sliderValues: self.$sliderValues, theme: self.$user.theme)
            Spacer()
            JournalEntryDescriptionView(additionalDescription: self.$additionalDescription, tc:  self.$user.theme.textColor, stc: self.$user.theme.secondaryColor)
            Spacer()
            JournalEntrySubmitButtonView(date: self.$today, user: self.$user, sliderValues: self.$sliderValues, additionalDescription: self.$additionalDescription)
            Spacer()
        }.frame(width: 350).navigationTitle("Journal Entry").navigationBarTitleDisplayMode(.inline)
        
    }
}


//Primary functions


//Helper functions


func getNoBGTextColor(tc: Color) -> Binding<Color> {
    if(tc == .white) {
        return .constant(.black)
    }
    else {
        return .constant(tc)
    }
}


//Extracted Subviews


struct JournalEntrySubmitButtonView: View {
    @Binding var date: CalendarDate
    @Binding var user: User
    @Binding var sliderValues: Array<Float>
    @Binding var additionalDescription: String
    
    var body: some View {
        NavigationLink(destination: JournalEntryConfirmationView(date: self.$date, user: self.$user, values: self.$sliderValues, description: self.$additionalDescription)) {
            ButtonView(text: .constant("Submit Entry"), tc1: self.$user.theme.textColor, tc2: self.$user.theme.secondaryColor, bgc: self.$user.theme.primaryColor)
        }
    }
}

struct JournalEntrySingleSliderView: View {
    @Binding var userSliders: Array<SliderData>
    @Binding var sliderValues: Array<Float>
    @Binding var slider: Int
    @Binding var theme: Theme
    
    var body: some View {
        ShadowTextView(text:  self.$userSliders[slider].title, tc: getNoBGTextColor(tc: self.theme.textColor), stc: self.$theme.primaryColor, fontType: .constant(.title2)).padding(.top, 50)
        HStack {
            Text("0").foregroundColor(.gray)
            Slider(value: self.$sliderValues[slider], in: 0...Float(self.userSliders[slider].range), step: 1.0) {
            }.frame(width: 250, height: 20)
            Text("\(String(self.userSliders[slider].range))").foregroundColor(.gray)
        }
        Text("\(Int(self.sliderValues[slider]))")
    }
}

struct JournalEntrySlidersView: View {
    @Binding var userSliders: Array<SliderData>
    @Binding var sliderValues: Array<Float>
    @Binding var theme: Theme
    
    
    var body: some View {
        ForEach(0..<self.userSliders.count, id: \.self) { slider in
            JournalEntrySingleSliderView(userSliders: self.$userSliders, sliderValues: self.$sliderValues, slider: .constant(slider), theme: self.$theme)
        }
    }
}

struct JournalEntryDescriptionView: View {
    @Binding var additionalDescription: String
    @Binding var tc: Color
    @Binding var stc: Color
    
    var body: some View {
        ShadowTextView(text: .constant("How was your day?"), tc: getNoBGTextColor(tc: self.tc), stc: self.$stc, fontType: .constant(.title2)).padding(.top, 25)
        TextEditor(text: $additionalDescription).frame(height: 150).border(.secondary).padding(.bottom, 25)
    }
}



//Debug functions


struct JournalEntryView_Previews: PreviewProvider {
    static var previews: some View {
        JournalEntryView(today: .constant(CalendarDate(day: 31, month: 12, year: 2021)), user: .constant(defaultUser))
    }
}


