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
            Text("Theme Colors:")
            ColorSelector(color: self.$user.theme.primaryColor, text: .constant("Primary theme color: "))
            ColorSelector(color: self.$user.theme.secondaryColor, text: .constant("Secondary theme color: "))
            ColorSelector(color: self.$user.theme.textColor, text: .constant("Text theme color:"))
            Text("Sliders:")
        }
    }
}


//Extracted Subviews


struct ColorSelector: View {
    @Binding var color: Color
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text("\(text)")
            Text("").frame(width: 40, height: 20).background(color).border(.primary)
        }
    }
}


//Debug functions


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(user: .constant(defaultUser))
    }
}
