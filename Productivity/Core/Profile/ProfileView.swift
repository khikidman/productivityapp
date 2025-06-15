//
//  ProfileView.swift
//  Productivity
//
//  Created by Khi Kidman on 6/2/25.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
    func togglePremiumStatus() {
        guard let user else { return }
        let currentValue = user.isPremium ?? false
        Task {
            try await UserManager.shared.updateUserPremiumStatus(userId: user.userId, isPremium: !currentValue)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @State var showSignInView: Bool = false
    @State private var showLinkPopup = false
    @State private var friends: [DBUser] = []
    @State private var isLoadingFriends = true
    @State private var friendRequests: [DBUser] = []
    @State private var isLoadingFriendRequests = true
    @State private var addFriendId: String = ""
    
    var body: some View {
        VStack {
            
            if let photoURL = viewModel.user?.photoUrl {
                AsyncImage(url: URL(string: photoURL)) { image in
                    image.image?.resizable()
                }
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .padding(20)
                .overlay(
                    ZStack {
                        let isPremium = viewModel.user?.isPremium ?? false
                        if isPremium {
                            Image(systemName: "star.fill").foregroundStyle(.yellow).font(.system(size: 30)).padding(6)
                        }
                    },
                    alignment: .topTrailing
                )
            }
            
            if let name = viewModel.user?.firstName {
                Text("Hello, \(name)")
                    .font(.title)
            }
            
            
            List {
                if let user = viewModel.user {
                    
                    Button {
                        viewModel.togglePremiumStatus()
                    } label: {
                        Text("User is premium: \((user.isPremium ?? false).description.capitalized)")
                    }
                    
                }
                
                Section("Friends") {
                    if isLoadingFriends {
                        ProgressView().disabled(true)
                    } else {
                        ForEach(friends, id: \.userId) { friend in
                            NavigationLink {
                                
                            } label: {
                                Label(friend.firstName ?? friend.email ?? friend.userId, systemImage: "person.fill")
                            }
                        }
                    }
                }
                Section("Requests") {
                    if isLoadingFriendRequests {
                        ProgressView().disabled(true)
                    } else {
                        ForEach(friendRequests, id: \.userId) { friendRequest in
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(friendRequest.firstName ?? friendRequest.email ?? friendRequest.userId)
                                                .fontWeight(.medium)
                                                .lineLimit(1)
                                            if let email = friendRequest.email {
                                                Text(email)
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        Spacer()
                                        Button {
                                            Task {
                                                do {
                                                    let currentUserId = try AuthenticationManager.shared.getAuthenticatedUser().uid
                                                    try await UserManager.shared.acceptFriendRequest(
                                                        from: friendRequest.userId,
                                                        to: currentUserId
                                                    )
                                                    // Optionally remove the request from the local list
                                                    friendRequests.removeAll { $0.userId == friendRequest.userId }
                                                } catch {
                                                    print("Failed to accept friend request: \(error)")
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "person.fill.badge.plus")
                                        }
                                    }
                                }
                        HStack {
                            TextField("Friend ID", text: $addFriendId)
                            Button {
                                Task {
                                    do {
                                        try await UserManager.shared.sendFriendRequest(
                                            from: AuthenticationManager.shared.getAuthenticatedUser().uid,
                                            to: addFriendId
                                        )
                                    } catch {
                                        
                                    }
                                }
                            } label: {
                                Label("Add Friend", systemImage: "person.fill.badge.plus")
                            }
                        }
                    }
                    
                }
            }
            .onAppear {
                Task {
                    do {
                        let uid = try AuthenticationManager.shared.getAuthenticatedUser().uid
                        friendRequests = try await UserManager.shared.getFriendRequests(for: uid)
                    } catch {
                        print("Error fetching friend requests: \(error)")
                    }
                    isLoadingFriendRequests = false
                }
                Task {
                    do {
                        let uid = try AuthenticationManager.shared.getAuthenticatedUser().uid
                        friends = try await UserManager.shared.getFriends(for: uid)
                        isLoadingFriends = false
                    } catch {
                        print("Error fetching friends: \(error)")
                        isLoadingFriends = false
                    }
                }
            }
        }
        
        
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showLinkPopup = true
                } label: {
                    Image(systemName: "link")
                        .font(.headline)
                }
                .alert("User ID", isPresented: $showLinkPopup) {
                    Button("Cancel", role: .cancel) { }
                    Button("Copy") {
                        if let user = viewModel.user {
                            UIPasteboard.general.string = "Hello world"
                        }
                    }
                    .foregroundStyle(.gray)
                } message: {
                    if let user = viewModel.user {
                        Text(user.userId)
                    }
                    
                }
            }
            ToolbarSpacer()
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
    }
}

#Preview {
        RootView()
            .environmentObject(TodoViewModel())
            .environmentObject(HabitViewModel())
}
