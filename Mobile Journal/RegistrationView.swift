//
//  SwiftUIView.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/14/21.
//

import SwiftUI

struct RegistrationView: View {
    @Binding var theme: Theme
    
    @State var email: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var passwordConfirm: String = ""
    
    var body: some View {
        VStack {
            RegistrationTitleView(theme: self.$theme)
            RegistrationEmailView(email: self.$email)
            RegistrationUsernameView(username: self.$username)
            RegistrationPasswordView(password: self.$password)
            RegistrationConfirmPWView(passwordConfirm: self.$passwordConfirm)
            RegistrationButtonView(email: self.$email, username: self.$username, password: self.$password, passwordConfirm: self.$passwordConfirm, theme: self.$theme)
        }
    }
}


//Primary functions


func createAccount(email: String, username: String, password: String, passwordConfirm: String) -> Bool{
    return true
}


//Extracted Subviews

//Title views
struct RegistrationTitleView: View {
    @Binding var theme: Theme
    
    var body: some View {
        ZStack {
            RegistrationTitleBGView()
            RegistrationTitleTextView(theme: self.$theme)
        }.frame(height: 200)
    }
}

struct RegistrationTitleTextView: View {
    @Binding var theme: Theme
    
    var body: some View {
        ZStack {
            Text("Registration").font(.largeTitle).fontWeight(.bold).foregroundColor(.black).padding(.top, 100)
            Text("Registration").font(.largeTitle).fontWeight(.semibold).foregroundColor(self.theme.secondaryColor).padding(.top, 100)
            
        }
    }
}

struct RegistrationTitleBGView: View {
    var body: some View {
        Image("blueSwoosh").resizable().aspectRatio(contentMode: .fill)
    }
}

//TextField views
struct RegistrationEmailView: View {
    @Binding var email: String
    
    var body: some View {
        HStack {
            Text("E-mail:")
            TextField("Required", text: self.$email).disableAutocorrection(true)
        }.padding(.horizontal)
    }
}

struct RegistrationUsernameView: View {
    @Binding var username: String
    
    var body: some View {
        HStack {
            Text("Username:")
            TextField("Required", text: self.$username).disableAutocorrection(true)
        }.padding(.horizontal)
    }
}

struct RegistrationPasswordView: View {
    @Binding var password: String
    
    var body: some View {
        VStack {
            HStack {
                Text("Password:")
                TextField("Required (8+ characters, 1 uppercase character, 1 lowercase character)", text: self.$password)
            }.padding(.horizontal)
            RegistrationPasswordFootnoteView()
        }
    }
}

struct RegistrationPasswordFootnoteView: View {
    var body: some View {
        Text("Password must contain 8 or more characters, at least 1 uppercase character, and at least 1 lowercase character.").font(.footnote).foregroundColor(.gray).padding(.horizontal)
    }
}

struct RegistrationConfirmPWView: View {
    @Binding var passwordConfirm: String
    
    var body: some View {
        VStack {
            HStack {
                Text("Confirm Password:")
                TextField("Required", text: self.$passwordConfirm)
            }.padding(.horizontal)
            RegistrationConfirmPWFootnoteView()
        }
    }
}

struct RegistrationConfirmPWFootnoteView: View {
    var body: some View {
        Text("Passwords must match.").font(.footnote).foregroundColor(.gray)
    }
}

//Button views
struct RegistrationButtonView: View {
    @Binding var email: String
    @Binding var username: String
    @Binding var password: String
    @Binding var passwordConfirm: String
    @Binding var theme: Theme
    
    var body: some View {
        Button(action: {if(createAccount(email: self.email, username: self.username, password: self.password, passwordConfirm: self.passwordConfirm))
            {
                //Inform user registration was successful
            }
            else {
                //Inform user registration was unsuccessful
            }
        }) {
            Text("Create Account").font(.headline).fontWeight(.bold).frame(width: 200, height: 50).foregroundColor(self.theme.textColor).background(self.theme.secondaryColor).cornerRadius(10.0)
        }
    }
}

//Debug functions


struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(theme: .constant(defaultTheme))
    }
}


