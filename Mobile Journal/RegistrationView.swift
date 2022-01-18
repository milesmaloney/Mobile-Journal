//
//  SwiftUIView.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/14/21.
//

import SwiftUI
import FirebaseAuth


//Primary View


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
        }.navigationTitle("Registration").navigationBarTitleDisplayMode(.inline)
    }
}


//Primary functions


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
            TextField("Required", text: self.$email).disableAutocorrection(true).autocapitalization(.none)
        }.padding(.horizontal)
    }
}

struct RegistrationUsernameView: View {
    @Binding var username: String
    
    var body: some View {
        HStack {
            Text("Username:")
            TextField("Required", text: self.$username).disableAutocorrection(true).autocapitalization(.none)
        }.padding(.horizontal)
    }
}

struct RegistrationPasswordView: View {
    @Binding var password: String
    @State var isHidden: Bool = true
    
    var body: some View {
        VStack {
            HStack {
                Text("Password:")
                if(isHidden) {
                    SecureField("Required (8+ characters, 1 uppercase character, 1 lowercase character)", text: self.$password).disableAutocorrection(true).autocapitalization(.none)
                }
                else {
                    TextField("Required (8+ characters, 1 uppercase character, 1 lowercase character)", text: self.$password).disableAutocorrection(true).autocapitalization(.none)
                }
                HiddenButtonView(bool: self.$isHidden)
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
    @State var isHidden: Bool = true
    
    var body: some View {
        VStack {
            HStack {
                Text("Confirm Password:")
                if(isHidden) {
                    SecureField("Required", text: self.$passwordConfirm).disableAutocorrection(true).autocapitalization(.none)
                }
                else {
                    TextField("Required", text: self.$passwordConfirm).disableAutocorrection(true).autocapitalization(.none)
                }
                HiddenButtonView(bool: self.$isHidden)
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
    @State var alertIsPresented: Bool = false
    @State var alert: Alert = Alert(title: Text("Error"), message: Text("ERROR: Registration was not yet expected. Please restart your app and try again."))
    
    var body: some View {
        Button(action: {
            let result = registerUser(email: self.email, username: self.username, password: self.password, passwordConfirm: self.passwordConfirm)
            if(result.success)
            {
                //Inform user registration was successful
                self.alert = Alert(title: Text("User registration was successful!"), message: Text("\(self.username) was successfully registered to the e-mail \(self.email)!"))
            }
            else {
                //Inform user registration was unsuccessful
                self.alert = Alert(title: Text("User registration failed."), message: Text("\(result.errorString)"))
            }
            self.alertIsPresented = true
        }) {
            ButtonView(text: .constant("Create Account"), tc1: self.$theme.textColor, tc2: self.$theme.primaryColor, bgc: self.$theme.secondaryColor)
        }.alert(isPresented: self.$alertIsPresented) {
            self.alert
        }
    }
}

//Debug functions


struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(theme: .constant(defaultTheme))
    }
}
