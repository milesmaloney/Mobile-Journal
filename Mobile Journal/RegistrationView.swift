//
//  SwiftUIView.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/14/21.
//

import SwiftUI

struct RegistrationView: View {
    @State var email: String = ""
    @State var username: String = ""
    @State var password: String = ""
    @State var passwordConfirm: String = ""
    
    var body: some View {
        VStack {
            RegistrationTitleView()
            HStack {
                Text("E-mail:")
                TextField("Required", text: $email).disableAutocorrection(true)
            }.padding()
            HStack {
                Text("Username:")
                TextField("Required", text: $username).disableAutocorrection(true)
            }.padding()
            HStack {
                Text("Password:")
                TextField("Required (8+ characters, 1 uppercase character, 1 lowercase character)", text: $password)
            }.padding()
            Text("Password must contain 8 or more characters, at least 1 uppercase character, and at least 1 lowercase character.").font(.footnote).foregroundColor(.gray)
            HStack {
                Text("Confirm Password:")
                TextField("Required", text: $password)
            }.padding()
            Text("Passwords must match.").font(.footnote).foregroundColor(.gray)
            Button(action: {createAccount(email: email, username: username, password: password, passwordConfirm: passwordConfirm)}) {
                Text("Create Account").font(.headline).fontWeight(.bold).frame(width: 200, height: 50).foregroundColor(.white).background(.orange).cornerRadius(10.0)
            }
        }.padding()
    }
}


func createAccount(email: String, username: String, password: String, passwordConfirm: String) -> (Bool, Int){
    return (true, 0)
}


struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}

struct RegistrationTitleView: View {
    var body: some View {
        ZStack {
            RegistrationTitleBGView()
            RegistrationTitleTextView()
        }
    }
}

struct RegistrationTitleTextView: View {
    var body: some View {
        ZStack {
            Text("Registration").font(.largeTitle).fontWeight(.bold).foregroundColor(.black).padding(.top, 100)
            Text("Registration").font(.largeTitle).fontWeight(.semibold).foregroundColor(.orange).padding(.top, 100)
            
        }
    }
}

struct RegistrationTitleBGView: View {
    var body: some View {
        Image("blueSwoosh").resizable().aspectRatio(contentMode: .fill)
    }
}
