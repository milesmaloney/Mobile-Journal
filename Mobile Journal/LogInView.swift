//
//  ContentView.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/14/21.
//

import SwiftUI
import CoreData

struct LogInView: View {
    
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack {
            LogInTitleView()
            HStack {
                Text("Username:").font(.body)
                TextField("Required", text: $username).disableAutocorrection(true)
            }
            HStack {
                Text("Password: ").font(.body)
                TextField("Required", text: $password).disableAutocorrection(true)
            }
            
            Button(action: {logIn(username: username, password: password)}) {
                LogInButtonView()
            }
            Button(action: {register()}) {
                LogInRegisterView()
            }
        }.padding()
    }
}


//Primary functions

/*Temporarily, all data will be stored in a file in json format*/
/*TODO: Create user creation function to be called here*/
func register() {

    print("Navigating to registration...")
}

/*TODO: Create user login function to be called here*/
func logIn(username: String, password: String) {
    print("Username: \(username)\nPassword: \(password)")
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

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()



//Extracted subviews


struct LogInTitleView: View {
    var body: some View {
        ZStack {
            LogInTitleBGView()
            LogInTitleTextView()
        }.padding(.bottom, 100)
    }
}


struct LogInTitleTextView: View {
    var body: some View {
        ZStack {
            Text("Mobile Journal").font(.largeTitle).fontWeight(.bold).foregroundColor(.white).padding(.top, 100)
            Text("Mobile Journal").font(.largeTitle).fontWeight(.semibold).foregroundColor(.black).padding(.top, 100)
        }
    }
}

struct LogInTitleBGView: View {
    var body: some View {
        Image("orangeSwoosh").resizable().aspectRatio(contentMode: .fill)
    }
}

struct LogInButtonView: View {
    var body: some View {
        Text("Log In").font(.headline).fontWeight(.bold).frame(width: 200, height: 50).foregroundColor(.white).background(.cyan).cornerRadius(10.0).padding(.top, 20)
    }
}

struct LogInRegisterView: View {
    var body: some View {
        Text("Don't have an account? Register here!").font(.subheadline).fontWeight(.semibold).foregroundColor(.orange)
    }
}

//Debug functions

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).previewInterfaceOrientation(.portrait)
    }
}
