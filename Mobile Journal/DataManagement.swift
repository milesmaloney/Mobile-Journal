//
//  DataManagement.swift
//  Mobile Journal
//
//  Created by Miles Maloney on 12/21/21.
//

import Foundation



import FirebaseFirestore


//Global constants


let db = Firestore.firestore()


//Primary functions


/*
 This function adds a user to the database
 Parameters:
    user: The user data struct being added to the database
Returns:
    Tuple:
        success: A boolean value denoting whether or not the operation succeeded
        errorString: A string to return any possible errors
 */
func addUserDataToDB(user: User) -> (success: Bool, errorString: String) {
    var success: Bool = false
    var errorString: String = ""
    
    
    var ref: DocumentReference? = nil
    ref = db.collection("users").addDocument(data: [
        "username": user.username,
        "theme": user.theme,
        "sliders": user.sliders,
        "journalEntries": user.journalEntries
    ]) { error in
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
 Gets the user data of the current user's username
 Parameters:
    username: The username of the current user for finding the proper data in the database
 Returns:
    Any: Returns false if the operation fails and the document's data if the operation succeeds
 */
func getUserDataFromDB(username: String) -> Any {
    var returnValue: Any =  false as Any
    
    let ref = db.collection("users").document(username)
    ref.getDocument { (document, error) in
        if let document = document, document.exists {
            returnValue = document.data() as Any
        } else {
            returnValue = false as Any
        }
    }
    return returnValue
}
