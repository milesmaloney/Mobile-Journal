//
//  SettingsView.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/31/21.
//

import SwiftUI


//Primary View


struct SettingsView: View {
    @Binding var user: User
    
    var body: some View {
        ScrollView {
            SettingsColorView(theme: self.$user.theme)
            Spacer()
            SettingsSliderView(sliders: self.$user.sliders)
            Spacer()
            SettingsApplyButtonView(user: self.$user)
            
        }
    }
}


//Primary functions


/*
 This function will apply changes to the settings to the current user's configuration
 */
func applySettingsChanges(user: User) {
    
}


//Extracted Subviews


struct SettingsColorView: View {
    @Binding var theme: Theme
    
    var body: some View {
        Text("Theme Colors:")
        ColorSelector(color: self.$theme.primaryColor, text: .constant("Primary theme color: ")).frame(width: 250)
        ColorSelector(color: self.$theme.secondaryColor, text: .constant("Secondary theme color: ")).frame(width: 250)
        ColorSelector(color: self.$theme.textColor, text: .constant("Text theme color:")).frame(width: 250)
    }
}

struct ColorSelector: View {
    @Binding var color: Color
    @Binding var text: String
    
    var body: some View {
        ColorPicker("\(self.text)", selection: self.$color)
    }
}

struct SettingsSliderView: View {
    @Binding var sliders: Array<SliderData>
    
    var body: some View {
        Text("Sliders:")
        VStack {
            ForEach (self.sliders, id: \.self.title) { slider in
                HStack {
                    TextEditor(text: .constant("\(slider.title)")).border(.primary)
                    Text(": from 0 to ")
                    TextEditor(text: .constant("\(String(slider.range))")).border(.primary).keyboardType(.decimalPad)
                }
            }
        }
    }
}

struct SettingsApplyButtonView: View {
    @Binding var user: User
    
    var body: some View {
        Button(action: {
            applySettingsChanges(user: self.user)
        }) {
            ButtonView(text: .constant("Apply Changes"), tc1: self.$user.theme.textColor, tc2: self.$user.theme.secondaryColor, bgc: self.$user.theme.primaryColor)
        }
    }
}


//Debug functions


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(user: .constant(defaultUser))
    }
}
