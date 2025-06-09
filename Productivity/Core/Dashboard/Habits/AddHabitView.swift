//
//  AddHabitView.swift
//  Productivity
//
//  Created by Khi Kidman on 5/28/25.
//

import Foundation
import SwiftUI

struct AddHabitView: View {
    @Binding var title: String
    @Binding var description: String
    @Binding var startTime: Date
    @State var selectedTime: Date = Date()
    @State private var iconName = "repeat"

    //IconPickerView(iconName: $iconName)
    
    var onSave: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("New Habit")
                    .font(.title2)
                    .bold()
                HStack {
                    VStack {
                        TextField("Habit Name", text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Description", text: $description)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }.padding(.trailing)
                    Menu {
                        
                    } label: {
                        Color.black.frame(width: 76, height: 76)
                            .clipShape(.rect(cornerRadius: 10))
                            .opacity(0.4)
                            .overlay {
                                ZStack() {
                                    Image(systemName: "repeat")
                                        .font(.system(size: 24))
                                        .foregroundStyle(.pink)
                                        .frame(width: 50, height: 50)
                                    Image(systemName: "chevron.down")
                                        .tint(.gray)
                                        .frame(width: 24)
                                        .padding(.top, 48)
                                }
                            }
                    }
                }.padding(.horizontal)
                
                
                DatePicker("Time", selection: $selectedTime, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(.wheel)
                    .tint(.pink)
                    .padding(.horizontal)
                    .onAppear {
                        // Convert DateComponents -> Date
                        selectedTime = startTime
                    }
                    .onChange(of: selectedTime) {
                        // Convert Date -> DateComponents
                        startTime = selectedTime
                    }
                
                HStack {
                    Button("Cancel", action: onCancel)
                        .foregroundColor(.gray)
                    Spacer()
                    Button("Save", action: onSave)
                        .foregroundStyle(.pink)
                        .bold()
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 10)
            .padding(40)
        }
    }
}
