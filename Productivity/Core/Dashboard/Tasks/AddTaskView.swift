//
//  AddTaskView.swift
//  Productivity
//
//  Created by Khi Kidman on 5/28/25.
//

import Foundation
import SwiftUI

struct AddTaskView: View {
    @Binding var title: String
    @Binding var startTime: Date
    var onSave: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        ZStack {
            Color(.systemBackground).brightness(-0.1)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Text("New Task")
                    .font(.title2)
                    .bold()
                    .frame(alignment: Alignment(horizontal: .center, vertical: .center))
                    .padding(.vertical)
                
//                Divider()
//                    .frame(maxHeight: 2)
//                    .background(Color.primary.opacity(0.1))
                
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.top)
                
                DatePicker("Due date", selection: $startTime, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .tint(.pink)
                    .padding(.horizontal)
                    
                
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

#Preview {
    TaskView()
        .environmentObject(TodoViewModel())
}
