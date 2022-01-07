//
//  ReusableViews.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/29/21.
//

import SwiftUI


//Views


//This view creates a text with 2 shadows behind it using the given colors (text = string to be shown, tc = foreground text color, stc1 = second layer shadow text color, stc2 = third layer shadow text color)
struct ShadowTextView: View {
    @Binding var text: String
    @Binding var tc: Color
    @Binding var stc: Color
    @Binding var fontType: Font
    
    init(text: Binding<String>, tc: Binding<Color>, stc: Binding<Color>, fontType: Binding<Font>) {
        self._text = text
        self._tc = tc
        self._stc = stc
        self._fontType = fontType
    }
    
    var body: some View {
        ZStack {
            Text("\(self.text)").font(self.fontType).fontWeight(.bold).foregroundColor(self.stc)
            Text("\(self.text)").font(self.fontType).fontWeight(.semibold).foregroundColor(self.tc)
        }
    }
}


//This view creates a header showing the given date (tc1 = foreground text color, tc2 = text shadow color, bgc = background color)
struct DateHeaderView: View {
    @Binding var date: CalendarDate
    @Binding var tc1: Color
    @Binding var tc2: Color
    @Binding var bgc: Color
    
    
    var body: some View {
        ShadowTextView(text: .constant("\(self.date.month)/\(self.date.day)/\(String(self.date.year))"), tc: self.$tc1, stc: self.$tc2, fontType: .constant(.title)).frame(width: 420, height: 75).background(self.bgc)
    }
}


//This view creates a button style (NOTE: This view should go inside a Button() to perform a function; text = text string, tc1 = foreground text color, tc2 = shadow text color, bgc = background text color)
struct ButtonView: View {
    @Binding var text: String
    @Binding var tc1: Color
    @Binding var tc2: Color
    @Binding var bgc: Color
    
    
    var body: some View {
        ShadowTextView(text: self.$text, tc: self.$tc1, stc: self.$tc2, fontType: .constant(.largeTitle)).frame(width: 300, height: 100).background(self.bgc).cornerRadius(10.0)
    }
}

//This view creates a red & white x button to denote deletions or cancellations
struct DeleteButtonView: View {
    var body: some View {
        Text("X").font(.title).foregroundColor(.white).frame(width: 30, height: 30).background(.red).cornerRadius(20.0)
    }
}

//This view creates a navigation toolbar item that leads to the settings page
struct NavBarSettingsView: View {
    @Binding var user: User
    
    var body: some View {
        NavigationLink(destination: SettingsView(user: self.$user)) {
            Image("settingsGear").resizable().aspectRatio(contentMode: .fit)
        }.frame(width: 50)
    }
}

//This view creates an eye that toggles an isHidden boolean value on/off
struct HiddenButtonView: View {
    @Binding var bool: Bool
    
    var body: some View {
        Button(action: {
            //Toggles isHidden boolean
            self.bool = self.bool ? false : true
        }) {
            Image("\(self.bool ? "passwordEyeGray" : "passwordEye")").resizable().frame(width: 30, height: 20).aspectRatio(contentMode: .fit)
        }
    }
}


//Debug functions


struct ReusableViews_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DateHeaderView(date: .constant(CalendarDate(day: 31, month: 12, year: 2021)), tc1: .constant(.white), tc2: .constant(.orange), bgc: .constant(.cyan))
            ShadowTextView(text: .constant("Shadow Text"), tc: .constant(.white), stc: .constant(.cyan), fontType: .constant(.title2))
            ButtonView(text: .constant("Button"), tc1: .constant(.white), tc2: .constant(.cyan), bgc: .constant(.orange))
            DeleteButtonView()
            NavBarSettingsView(user: .constant(defaultUser))
        }
    }
}
