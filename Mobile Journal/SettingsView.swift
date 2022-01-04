//
//  SettingsView.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/31/21.
//

import SwiftUI


//Structs


struct SliderString {
    var title: String
    var range: String
    var creatorName: String
}


//Primary View


struct SettingsView: View {
    @Binding var user: User
    @State var newUser: User
    //Creates an array of slider string structs to hold the Slider data as editable strings
    @State var newSliderArray: Array<SliderString>
    
    init(user: Binding<User>) {
        self._user = user
        self.newUser = user.wrappedValue
        //Maps the new slider array to string representations of the original
        self.newSliderArray = user.wrappedValue.sliders.map({
            return SliderString(title: $0.title, range: String($0.range), creatorName: $0.creatorName)
        })
    }
    
    var body: some View {
        ScrollView {
            SettingsColorView(theme: self.$newUser.theme)
            Spacer()
            SettingsSlidersView(username: self.$newUser.username, newSliders: self.$newSliderArray)
            Spacer()
            SettingsApplyButtonView(user: self.$user, newUser: self.$newUser, newSliders: self.$newSliderArray)
            Spacer()
        }.navigationTitle("Settings").navigationBarTitleDisplayMode(.inline)
    }
}


//Primary functions


/*
 This function will apply changes to the settings to the current user's configuration after validating the strings entered to the sliders
 Parameters:
    user (inout): The primary user object holding the current active user's data
    newUser: The copied user object used to store changes to the user's data
    newSliders: The SliderString objects obtained from the editted sliders
 Returns:
    Bool: A boolean value denoting whether the operation was a success
 */
func applySettingsChanges(user: inout User, newUser: User, newSliders: Array<SliderString>) -> Bool {
    var finalSliders: Array<SliderData>
    if(validateSliders(newSliderArray: newSliders)) {
        finalSliders = newSliders.map({
            return SliderData(title: $0.title, range: Int($0.range)!, creatorName: $0.creatorName)
        })
    }
    else {
        return false
    }
    user = newUser
    user.sliders = finalSliders
    return true
}

/*
 This function deletes one instance of the given slider from the slider array
 Parameters:
    slider: The slider to be removed
    sliderArray (inout): The array for the slider to be removed from
 Returns:
    Bool: A boolean value denoting whether the operation was a success
 */
func deleteSlider(slider: SliderString, sliderArray: inout Array<SliderString>) -> Bool{
    var newSliderArray = sliderArray.filter{$0.title != slider.title || $0.range != slider.range || $0.creatorName != slider.creatorName}
    //Ensures specifically one slider was removed
    if(newSliderArray.count == sliderArray.count - 1) {
        sliderArray = newSliderArray
        return true
    }
    else if(newSliderArray.count < sliderArray.count - 1){
        //Adds back any redundant removals for exactly matching sliders so only one slider gets removed on any deletion
        while(newSliderArray.count != sliderArray.count - 1) {
            newSliderArray.append(SliderString( title: slider.title, range: slider.range, creatorName: slider.creatorName))
        }
        return true
    }
    else {
        return false
    }
}

/*
 This function adds a new slider to the slider array containing the current user's sliders
 Parameters:
    sliderArray: The array containing the sliders for the current user
    username: The user's username to mark the creator as the current user
 Returns:
    Bool: A boolean valued denoting whether the operation was a success
 */
func addSlider(sliderArray: inout Array<SliderString>, username: String) -> Bool{
    sliderArray.append(SliderString(title: "", range: "1", creatorName: username))
    return true
}

/*
 This function validates the strings entered by the user for the slider title and range
 Parameters:
    newSliderArray: The array of the user's new sliders as a result of the settings editing
 Returns:
    Bool: A boolean value denoting whether the sliders in the newSliderArray are all valid
 */
func validateSliders(newSliderArray: Array<SliderString>) -> Bool {
    for slider in newSliderArray {
        //Checks if the slider range can't be cast as an int (unexpected characters)
        if(Int(slider.range) == nil) {
            return false
        }
        //Checks if the slider title is repeated at all
        if(newSliderArray.filter{$0.title == slider.title}.count != 1) {
            return false
        }
    }
    return true
}


//Extracted Subviews


struct SettingsColorView: View {
    @Binding var theme: Theme
    
    var body: some View {
        Text("Theme Colors:").font(.title).padding(.top, 50).padding(.bottom, 10)
        ColorPicker("Primary theme color: ", selection: self.$theme.primaryColor).frame(width: 250)
        ColorPicker("Secondary theme color: ", selection: self.$theme.secondaryColor).frame(width: 250)
        ColorPicker("Text theme color:", selection: self.$theme.textColor).frame(width: 250)
    }
}

struct SettingsSlidersView: View {
    @Binding var username: String
    @Binding var newSliders: Array<SliderString>
    
    var body: some View {
        Text("Sliders:").font(.title).padding(.top, 50).padding(.bottom, 10)
        VStack {
            ForEach (self.$newSliders, id: \.self.title) { slider in
                SettingsSingleSliderView( newSliders: self.$newSliders, newSlider: slider)
            }
            SettingsSliderAddButton(sliders: self.$newSliders, username: self.$username)
        }
    }
}

struct SettingsSingleSliderView: View {
    @Binding var newSliders: Array<SliderString>
    @Binding var newSlider: SliderString
    
    var body: some View {
        VStack {
            HStack {
                TextEditor(text: self.$newSlider.title).frame(width: 150).border(.primary)
                Text(": from 0 to ")
                TextEditor(text: self.$newSlider.range).frame(width: 50).border(.primary).keyboardType(.decimalPad)
                SettingsSliderDeleteButton(slider: self.$newSlider, sliders: self.$newSliders)
            }
            Text("Created by \(newSlider.creatorName)").font(.footnote).foregroundColor(.gray)
        }
    }
}

struct SettingsSliderDeleteButton: View {
    @Binding var slider: SliderString
    @Binding var sliders: Array<SliderString>
    
    var body: some View {
        Button(action: {
            if(deleteSlider(slider: self.slider, sliderArray: &self.sliders)) {
                //Inform user \(self.slider.title) has been removed successfully
            }
            else {
                //Inform user of error
            }
        }) {
            DeleteButtonView()
        }
    }
}

struct SettingsSliderAddButton: View {
    @Binding var sliders: Array<SliderString>
    @Binding var username: String
    
    var body: some View {
        Button(action: {
            if(addSlider(sliderArray: &self.sliders, username: self.username)) {
                //continue
            }
            else {
                //Inform user of error
            }
        }) {
            Text("+").font(.title).fontWeight(.semibold).foregroundColor(.white).frame(width: 420, height: 50).background(Color(UIColor.lightGray))
        }
    }
}

struct SettingsApplyButtonView: View {
    @Binding var user: User
    @Binding var newUser: User
    @Binding var newSliders: Array<SliderString>
    
    var body: some View {
        Button(action: {
            if(applySettingsChanges(user: &self.user, newUser: self.newUser, newSliders: self.newSliders)) {
                //Return to previous page
            }
            else {
                //Inform user of error
            }
        }) {
            ButtonView(text: .constant("Apply Changes"), tc1: self.$user.theme.textColor, tc2: self.$user.theme.secondaryColor, bgc: self.$user.theme.primaryColor).padding(.top, 50).padding(.bottom, 10)
        }
    }
}


//Debug functions


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(user: .constant(defaultUser))
    }
}
