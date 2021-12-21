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
    
    @State var username: String = "1"
    @State var password: String = ""
    
    var body: some View {
        VStack {
            LogInTitleView(theme: self.$user.theme)
            LogInUsernameView(username: self.$username)
            LogInPasswordView(password: self.$password)
            LogInButtonView(user: self.$user, username: self.$username, password: self.$password)
            LogInRegisterView(theme: self.$user.theme)
        }.navigationTitle("Log In").navigationBarTitleDisplayMode(.inline).padding()
    }
}


//Primary functions

/*This function will return a boolean value denoting whether or not the user was successfully logged in*/
func logIn(username: String, password: String, user: inout User) -> Bool {
    //TODO: replace if conditional with proper log-in
    if(username != "") {
        user = User(username: username, passwordHash: getPasswordHash(username: username), theme: defaultUser.theme, journalEntries: defaultUser.journalEntries)
        return true
    }
    return false
}

//TODO: Query user data for password hash upon completion of database handler
func getPasswordHash(username: String) -> String {
    return defaultUser.passwordHash
}


//Helper functions

func writeToFile(fileName: String, toWrite: [String]) -> Bool {
    let file = fileName
    let text = toWrite.joined()
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

        let fileURL = dir.appendingPathComponent(file)

        do {
            try text.write(to: fileURL, atomically: false, encoding: .utf8)
            return true
        }
        catch {return false}
    }
    return false
}

func readFromFile(fileName: String) -> String {
    let file = fileName

    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

        let fileURL = dir.appendingPathComponent(file)
        
        do {
            let text = try String(contentsOf: fileURL, encoding: .utf8)
            return text
        }
        catch {return ""}
    }
    return ""
}



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

struct LogInUsernameView: View {
    @Binding var username: String
    
    var body: some View {
        HStack {
            Text("Username:").font(.body)
            TextField("Required", text: self.$username).disableAutocorrection(true)
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
    @Binding var username: String
    @Binding var password: String
    
    var body: some View {
        Button(action: {
            if(logIn(username: self.username, password: self.password, user: &self.user)) {
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
