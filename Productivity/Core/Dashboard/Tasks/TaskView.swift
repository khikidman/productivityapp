//
//  TaskView.swift
//  Productivity
//
//  Created by Khi Kidman on 5/10/25.
//

import SwiftUI
import Charts
import UniformTypeIdentifiers



struct TaskView: View {
    
    @State private var showAddTask = false
    @State private var searchContent: String = ""
    @State private var newTaskTitle = ""
    @State private var newTaskStartTime = Date()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    @EnvironmentObject var todoVM: TodoViewModel
    
    var body: some View {
        NavigationStack {
            List($todoVM.todoItems) { $todoItem in
                if let index = todoVM.todoItems.firstIndex(where: { $0.id == todoItem.id }) {
                    let todoItem = $todoVM.todoItems[index] // manually bind to the item
                    
                    if (searchContent.isEmpty || todoItem.title.wrappedValue.localizedCaseInsensitiveContains(searchContent)) {
                        HStack(alignment: .center, spacing: 16) {
                            Button(action: {
                                todoItem.completed.wrappedValue.toggle()
                                Task {
                                    try? await Task.sleep(nanoseconds: 500_000_000)
                                    await MainActor.run {
                                        withAnimation {
                                            todoVM.todoItems.remove(at: index)
                                        }
                                    }
                                }
                            }) {
                                Image(systemName: todoItem.wrappedValue.completed ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(.pink)
                                    .font(.system(size: 20))
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(todoItem.wrappedValue.title)
                                    .font(.headline)
                                
                                Text(dateFormatter.string(from: todoItem.wrappedValue.startTime) + (todoItem.wrappedValue.startTime < Date() ? " - Overdue" : ""))
                                    .font(.subheadline)
                                    .foregroundColor({
                                        let startTime = todoItem.wrappedValue.startTime
                                        let now = Date()
                                        
                                        if startTime < now {
                                            return .pink.opacity(0.6) // overdue
                                        } else if startTime <= now.addingTimeInterval(3600) {
                                            return .pink // due today or within past 24h
                                        } else {
                                            return .gray // upcoming
                                        }
                                    }())
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                todoVM.todoItems.remove(at: index)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                            
                            NavigationLink {
                                TaskDetailView(task: $todoItem)
                                    .environmentObject(todoVM)
                                    
//                                    .tint(.pink)
                            } label: {
                                Image(systemName: "slider.horizontal.3")
                            }
                            .tint(.blue)
                        }
                        .listRowSeparator(.automatic)
                    }
                }
            }
            .searchable(text: $searchContent, placement: .navigationBarDrawer(displayMode: .always))
            .listStyle(.plain)
            .navigationTitle("Tasks")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddTask = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.pink)
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showAddTask) {
                AddTaskView(
                    title: $newTaskTitle,
                    startTime: $newTaskStartTime,
                    onSave: {
                        let newItem = TodoItem(title: newTaskTitle, startTime: newTaskStartTime)
                        todoVM.todoItems.append(newItem)
                        newTaskTitle = ""
                        newTaskStartTime = Date()
                        showAddTask = false
                    },
                    onCancel: {
                        showAddTask = false
                    }
                )
            }
        }
    }
}

#Preview {
    TaskView()
        .environmentObject(TodoViewModel())
}
