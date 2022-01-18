//
//  Auth.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/21/21.
//

import Foundation
import Firebase
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
    
    var errorString: String = "False error"
    var success: Bool = true
    
    if(password == passwordConfirm) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                errorString = error!.localizedDescription
                success = false
                return
            }
            let newUser: User = User(username: username, theme: defaultTheme, journalEntries: [], sliders: defaultSliders)
            //if(addUserDataToDB(user: newUser).success) {
            //}
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
    
    var errorString: String = "False error"
    var success: Bool = true
    
    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
        guard let user = authResult?.user, error == nil else {
            errorString = error!.localizedDescription
            success = false
            return
        }
    }
    return (success: success, errorString: errorString)
}

/*
 This function logs out a user
 Parameters:
    None: returns the current user in the auth variable to defaults
 Returns:
    Bool: A boolean value denoting whether or not the log-out was successful (only returns a bool and not a tuple because any errors thrown by this function would not be user-caused)
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


//Debug functions


func debugLogIn(email: String, password: String, user: inout User) -> Bool {
    if(email == "" && password == "") {
        return false
    }
    user.username = "debug"
    return true
}

func debugLogOut(user: inout User) -> Bool {
    user = defaultUser
    return true
}
