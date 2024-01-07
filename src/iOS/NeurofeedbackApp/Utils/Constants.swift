//
//  Constants.swift
//  NeurofeedbackApp
//
//  Created by Shishir Mishra on 5/1/2024.
//

import Foundation

struct Constants {
    
    /// Set UserDefaults based on which environment the app is running in
    static func setUserDefaults() {
        let defaults: UserDefaults = UserDefaults.standard
        
        // make sure all previous defaults are erased
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        // INITIAL VARIABLES: THESE CAN BE CHANGED IN THE UI
        defaults.set([Dictionary<String, Any>](), forKey: "storedData")
        
    }
}
