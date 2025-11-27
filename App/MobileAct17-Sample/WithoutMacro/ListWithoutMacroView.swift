import SwiftUI

struct ListWithoutMacroView: View {
    @State private var viewModel: ListWithoutMacroViewModel

    init(viewModel: ListWithoutMacroViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List(viewModel.todos, id: \.self) { todo in
            Text(todo.content)
                .swipeActions(edge: .trailing) {
                    Button(
                        role: .destructive,
                        action: {
                            Task { await viewModel.deleteTodo(id: todo.id) }
                        },
                        label: { Label("削除", systemImage: "trash") }
                    )
                }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(
                    action: { viewModel.isShownInsertAlert = true },
                    label: {
                        Image(systemName: "plus")
                    }
                )
            }
        }
        .alert("TODOの新規作成", isPresented: $viewModel.isShownInsertAlert) {
            TextField("タイトル", text: $viewModel.newTodoTitle)
            Button(
                role: .cancel,
                action: { viewModel.newTodoTitle = "" },
                label: { Text("キャンセル") }
            )
            Button(
                action: {
                    Task {
                        let entity = TodoEntity(id: UUID(), content: viewModel.newTodoTitle)
                        await viewModel.insertTodo(todoEntity: entity)
                    }
                },
                label: { Text("確定") }
            )
        }
    }
}
