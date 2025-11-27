import Foundation
import Observation

@MainActor
@Observable
final class ListWithoutMacroViewModel {
    let todoStore: any TodoStoreProtocol
    var isShownInsertAlert = false
    var newTodoTitle: String = ""

    init(todoStore: any TodoStoreProtocol) {
        self.todoStore = todoStore
    }

    var todos: [TodoEntity] { todoStore.todos }

    func insertTodo(todoEntity: TodoEntity) async {
        await todoStore.insertTodo(entity: todoEntity)
        newTodoTitle = ""
    }

    func deleteTodo(id: UUID) async {
        await todoStore.deleteTodo(id: id)
    }

}
