import SwiftUI
import SwiftData

struct ListWithMacroView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var todos: [TodoModel]
    @State private var isShownInsertAlert = false
    @State private var newTodoTitle: String = ""

    var body: some View {
        List(todos, id: \.self) { todo in
            Text(todo.content)
                .swipeActions(edge: .trailing) {
                    Button(
                        role: .destructive,
                        action: { deleteTodo(todoModel: todo) },
                        label: { Label("削除", systemImage: "trash") }
                    )
                }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(
                    action: { isShownInsertAlert = true },
                    label: {
                        Image(systemName: "plus")
                    }
                )
            }
        }
        .alert("TODOの新規作成", isPresented: $isShownInsertAlert) {
            TextField("タイトル", text: $newTodoTitle)
            Button(
                role: .cancel,
                action: { newTodoTitle = "" },
                label: { Text("キャンセル") }
            )
            Button(
                action: {
                    let model = TodoModel(id: UUID(), content: newTodoTitle)
                    insertTodo(todoModel: model)
                },
                label: { Text("確定") }
            )
        }
    }

    private func insertTodo(todoModel: TodoModel) {
        modelContext.insert(todoModel)
    }

    private func deleteTodo(todoModel: TodoModel) {
        modelContext.delete(todoModel)
    }
}
