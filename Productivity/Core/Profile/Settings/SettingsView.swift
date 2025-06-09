//
//  SettingsView.swift
//  Productivity
//
//  Created by Khi Kidman on 5/31/25.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
            
                        
            Button {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Log out")
                    .foregroundStyle(.red)
            }
            
            
        }
        .onAppear {
            viewModel.loadAuthProviders()
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}

extension SettingsView {
    private var emailSection: some View {
        Section {
            Button {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("Password Reset Successful")
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Reset Password")
                    .foregroundStyle(.blue)
            }
            
            Button {
                Task {
                    do {
                        try await viewModel.updatePassword(password: "Hello1232")
                        print("Password Reset Successful")
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Update Password")
                    .foregroundStyle(.blue)
            }
            
            Button {
                Task {
                    do {
                        try await viewModel.updateEmail(email: "Hello1232@gmail.com")
                        print("Email Reset Successful")
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Update Email")
                    .foregroundStyle(.blue)
            }
        } header: {
            Text("Email")
        }
    }
}
