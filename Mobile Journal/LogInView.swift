//
//  ContentView.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/14/21.
//

import SwiftUI
import CoreData

struct LogInView: View {
    @Binding var user: User
    
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack {
            LogInTitleView(theme: self.$user.theme)
            LogInEmailView(email: self.$email)
            LogInPasswordView(password: self.$password)
            LogInButtonView(user: self.$user, email: self.$email, password: self.$password)
            LogInRegisterView(theme: self.$user.theme)
        }.navigationTitle("Log In").navigationBarTitleDisplayMode(.inline).padding()
    }
}


//Primary functions


//Helper functions


//Extracted subviews


struct LogInTitleView: View {
    @Binding var theme: Theme
    
    var body: some View {
        ZStack {
            LogInTitleBGView()
            LogInTitleTextView(theme: self.$theme)
        }.padding(.bottom, 100)
    }
}


struct LogInTitleTextView: View {
    @Binding var theme: Theme
    
    var body: some View {
        ZStack {
            Text("Mobile Journal").font(.largeTitle).fontWeight(.bold).foregroundColor(self.theme.textColor).padding(.top, 100)
            Text("Mobile Journal").font(.largeTitle).fontWeight(.semibold).foregroundColor(.black).padding(.top, 100)
        }
    }
}

struct LogInTitleBGView: View {
    var body: some View {
        Image("orangeSwoosh").resizable().aspectRatio(contentMode: .fill)
    }
}

struct LogInEmailView: View {
    @Binding var email: String
    
    var body: some View {
        HStack {
            Text("E-mail:").font(.body)
            TextField("Required", text: self.$email).disableAutocorrection(true).autocapitalization(.none)
        }
    }
}

struct LogInPasswordView: View {
    @Binding var password: String
    @State var isHidden: Bool = true
    
    var body: some View {
        HStack {
            Text("Password: ").font(.body)
            if(isHidden) {
                SecureField("Required", text: self.$password).disableAutocorrection(true).autocapitalization(.none)
            }
            else {
                TextField("Required", text: self.$password).disableAutocorrection(true).autocapitalization(.none)
            }
            HiddenButtonView(bool: self.$isHidden)
        }
    }
}

struct LogInButtonView: View {
    @Binding var user: User
    @Binding var email: String
    @Binding var password: String
    @State var alertIsPresented: Bool = false
    @State var alert: Alert = Alert(title: Text("Error"), message: Text("ERROR: Log-in not yet attempted. Please restart the app and try again."))
    
    var body: some View {
        Button(action: {
            let result = logInUser(email: self.email, password: self.password)
            if(result.success) {
                self.alert = Alert(title: Text("Log-in Successful"), message: Text("You have logged in successfully!"))

                //TODO: Continue to logged-in views
            }
            else {
                self.alert = Alert(title: Text("Log-in failed"), message: Text(result.errorString))
            }
            self.alertIsPresented = true
        }) {
            ButtonView(text: .constant("Log In"), tc1: self.$user.theme.textColor, tc2: self.$user.theme.secondaryColor, bgc: self.$user.theme.primaryColor)
        }.alert(isPresented: self.$alertIsPresented) {
            self.alert
        }
        
    }
}

struct LogInRegisterView: View {
    @Binding var theme: Theme
    
    var body: some View {
        NavigationLink(destination: RegistrationView(theme: self.$theme)) {
            Text("Don't have an account? Register here!").font(.subheadline).fontWeight(.semibold).foregroundColor(self.theme.secondaryColor)
        }
    }
}

//Debug functions

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LogInView(user: .constant(defaultUser)).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).previewInterfaceOrientation(.portrait)
        }
    }
}
