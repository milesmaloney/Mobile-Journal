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
    
    @State var email: String = "1"
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
            TextField("Required", text: self.$email).disableAutocorrection(true)
        }
    }
}

struct LogInPasswordView: View {
    @Binding var password: String
    
    var body: some View {
        HStack {
            Text("Password: ").font(.body)
            TextField("Required", text: self.$password).disableAutocorrection(true)
        }
    }
}

struct LogInButtonView: View {
    @Binding var user: User
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        Button(action: {
            if(logInUser(email: self.email, password: self.password).success) {
                //TODO: Continue to logged-in views
            }
            else {
                //TODO: Throw an error and edit the page accordingly
            }
        }) {
            Text("Log In").font(.headline).fontWeight(.bold).frame(width: 200, height: 50).foregroundColor(self.user.theme.textColor).background(self.user.theme.primaryColor).cornerRadius(10.0).padding(.top, 20)
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
        LogInView(user: .constant(defaultUser)).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).previewInterfaceOrientation(.portrait)
    }
}
