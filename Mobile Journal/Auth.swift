//
//  Auth.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/21/21.
//

import Foundation
import FirebaseAuth


/*
 This function registers a user to the Firebase authentication server
 Parameters:
    email: The user's email used to sign up, verify, and log in
    password: The user's password
    confirmPassword: The user's password confirmation
 Returns:
    Tuple:
        success: Boolean value denoting whether the registration succeeded
        errorString: A string containing any possible errors that occurred
 */
func registerUser(email: String, username: String, password: String, passwordConfirm: String) -> (success: Bool, errorString: String) {
    
    var errorString: String = ""
    var success: Bool = false
    
    if(password == passwordConfirm) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if(error != nil) {
                errorString = error!.localizedDescription
            }
            else {
                var newUser: User = User(username: username, theme: defaultTheme, journalEntries: [], sliders: defaultSliders)
                if(addUserDataToDB(user: newUser).success) {
                    success = true
                }
            }
        }
        return (success: success, errorString: errorString)
    }
    else {
        return (success: false, errorString: "Passwords do not match. Please try again.")
    }
}

/*
 This function logs in a user with their email and password
 Parameters:
    email: The email the user used to sign up
    password: The password typed in the password field by the user
 Returns:
    Tuple:
        success: A boolean value denoting whether the log-in succeeded
        errorString: A string containing any potential errors that occurred
 */
func logInUser(email: String, password: String) -> (success: Bool, errorString: String){
    
    var errorString: String = ""
    var success: Bool = false
    
    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
        if(error != nil) {
            errorString = error!.localizedDescription
        }
        else {
            success = true
        }
    }
    return (success: success, errorString: errorString)
}

/*
 This function logs out a user
 Parameters:
    None: returns the current user in the auth variable to defaults
 Returns:
    Bool: A boolean value denoting whether or not the log-out was successful
 */
func logOutUser() -> Bool {
    do {
        try Auth.auth().signOut()
        return true
    } catch let signOutError as NSError {
        print("Error signing out: %@", signOutError)
        return false
    }
}
