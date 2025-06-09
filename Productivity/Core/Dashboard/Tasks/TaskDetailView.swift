//
//  TaskDetailView.swift
//  Productivity
//
//  Created by Khi Kidman on 5/29/25.
//

import Foundation
import SwiftUI

struct TaskDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var todoVM: TodoViewModel
    @Binding var task: TodoItem
    @State private var taskIsCompleted: Bool = false
    @State private var taskTitle: String = ""
    @FocusState private var isTitleFocused: Bool
    
    var body: some View {
        NavigationStack {
            DatePicker("Due date", selection: $task.startTime, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(GraphicalDatePickerStyle())
                .tint(.pink)
                .padding(.horizontal)
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .principal) {
                TextField("Title", text: $taskTitle)
                    .multilineTextAlignment(.center)
                    .font(.headline.bold())
                    .textFieldStyle(.roundedBorder)
                    .fixedSize()
                    .frame(maxWidth: 200)
                    .focused($isTitleFocused)
                    .onSubmit { task.title = taskTitle }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    todoVM.todoItems.removeAll(where: {$0.id == task.id})
                    dismiss()
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 16))
                }
                .foregroundStyle(.pink)
            }
        }
        .onAppear {
            taskTitle = task.title
            isTitleFocused = true;
        }
        .tint(.pink)
    }
}
