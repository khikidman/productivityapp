//
//  AuthenticationViewModel.swift
//  Productivity
//
//  Created by Khi Kidman on 6/2/25.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
 
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
}
