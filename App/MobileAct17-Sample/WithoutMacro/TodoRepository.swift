import Foundation
import SwiftData

struct TodoRepository: TodoRepositoryProtocol{
    let swiftDataClient: SwiftDataClient

    func fetchTodos() async -> [TodoEntity] {
        let descriptor = FetchDescriptor<TodoModel>()
        let todos: [TodoEntity] = await swiftDataClient.fetch(descriptor: descriptor)
        return todos
    }

    func insertTodo(entity: TodoEntity) async {
        await swiftDataClient.insert(entity: entity, from: TodoModel.self)
    }

    func deleteTodo(id: UUID) async {
        await swiftDataClient.delete(id: id, from: TodoModel.self)
    }
}
