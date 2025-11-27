import Foundation
import Observation

@MainActor
@Observable
final class TodoStore: TodoStoreProtocol {
    private(set) var todos = [TodoEntity]()
    @ObservationIgnored var todoRepository: any TodoRepositoryProtocol

    init(todoRepository: any TodoRepositoryProtocol) {
        self.todoRepository = todoRepository

        Task { await syncTodos() }
    }

    func syncTodos() async {
        todos = await todoRepository.fetchTodos()
    }

    func insertTodo(entity: TodoEntity) async {
        await todoRepository.insertTodo(entity: entity)
        todos.append(entity)
    }

    func deleteTodo(id: UUID) async {
        await todoRepository.deleteTodo(id: id)
        todos = todos.filter { $0.id != id }
    }
}
