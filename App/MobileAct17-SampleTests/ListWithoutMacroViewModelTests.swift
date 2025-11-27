//
//  ListWithoutMacroViewModelTests.swift
//  MobileAct17-Sample
//
//  Created by Ibuki Onishi on 2025/11/16.
//

import Foundation
import Testing
import Observation
@testable import MobileAct17_Sample

@MainActor
struct ListWithoutMacroViewModelTests {
    @Test("初期化時にtodoStoreが正しく設定される")
    func testInitialization() {
        let mockStore = MockTodoStore()
        let viewModel = ListWithoutMacroViewModel(todoStore: mockStore)

        #expect(viewModel.todoStore as? MockTodoStore === mockStore)
        #expect(viewModel.isShownInsertAlert == false)
        #expect(viewModel.newTodoTitle == "")
    }

    @Test("todosプロパティがtodoStore.todosを返す")
    func testTodosProperty() {
        let initialTodos = [
            TodoEntity(id: UUID(), content: "Todo 1"),
            TodoEntity(id: UUID(), content: "Todo 2")
        ]
        let mockStore = MockTodoStore(initialTodos: initialTodos)
        let viewModel = ListWithoutMacroViewModel(todoStore: mockStore)

        let todos = viewModel.todos

        #expect(todos.count == 2)
        #expect(todos[0].id == initialTodos[0].id)
        #expect(todos[1].id == initialTodos[1].id)
    }

    @Test("todosプロパティがtodoStoreの状態変化を反映する")
    func testTodosPropertyReflectsStoreChanges() async {
        let mockStore = MockTodoStore()
        let viewModel = ListWithoutMacroViewModel(todoStore: mockStore)

        #expect(viewModel.todos.isEmpty)

        let newTodo = TodoEntity(id: UUID(), content: "新しいTodo")
        await mockStore.insertTodo(entity: newTodo)

        #expect(viewModel.todos.count == 1)
        #expect(viewModel.todos[0].id == newTodo.id)
    }

    @Test("insertTodoがtodoStore.insertTodoを呼ぶ")
    func testInsertTodo() async {
        let mockStore = MockTodoStore()
        let viewModel = ListWithoutMacroViewModel(todoStore: mockStore)
        let newTodo = TodoEntity(id: UUID(), content: "テストTodo")

        await viewModel.insertTodo(todoEntity: newTodo)

        #expect(mockStore.insertTodoCallCount == 1)
    }

    @Test("複数のTodoを挿入できる")
    func testInsertMultipleTodos() async {
        let mockStore = MockTodoStore()
        let viewModel = ListWithoutMacroViewModel(todoStore: mockStore)
        let todo1 = TodoEntity(id: UUID(), content: "Todo 1")
        let todo2 = TodoEntity(id: UUID(), content: "Todo 2")

        await viewModel.insertTodo(todoEntity: todo1)
        await viewModel.insertTodo(todoEntity: todo2)

        #expect(mockStore.insertTodoCallCount == 2)
        #expect(viewModel.todos.count == 2)
    }

    @Test("deleteTodoがtodoStore.deleteTodoを呼ぶ")
    func testDeleteTodo() async {
        let initialTodo = TodoEntity(id: UUID(), content: "削除されるTodo")
        let mockStore = MockTodoStore(initialTodos: [initialTodo])
        let viewModel = ListWithoutMacroViewModel(todoStore: mockStore)

        await viewModel.deleteTodo(id: initialTodo.id)

        #expect(mockStore.deleteTodoCallCount == 1)
    }

    @Test("複数のTodoから特定のTodoを削除できる")
    func testDeleteSpecificTodo() async {
        let todo1 = TodoEntity(id: UUID(), content: "Todo 1")
        let todo2 = TodoEntity(id: UUID(), content: "Todo 2")
        let todo3 = TodoEntity(id: UUID(), content: "Todo 3")
        let mockStore = MockTodoStore(initialTodos: [todo1, todo2, todo3])
        let viewModel = ListWithoutMacroViewModel(todoStore: mockStore)

        await viewModel.deleteTodo(id: todo2.id)

        #expect(mockStore.deleteTodoCallCount == 1)
        #expect(viewModel.todos.count == 2)
        let ids = viewModel.todos.map { $0.id }
        #expect(ids.contains(todo1.id))
        #expect(!ids.contains(todo2.id))
        #expect(ids.contains(todo3.id))
    }

    @Test("挿入と削除を組み合わせた操作が正しく動作する")
    func testInsertAndDeleteCombination() async {
        let mockStore = MockTodoStore()
        let viewModel = ListWithoutMacroViewModel(todoStore: mockStore)
        let todo1 = TodoEntity(id: UUID(), content: "Todo 1")
        let todo2 = TodoEntity(id: UUID(), content: "Todo 2")

        await viewModel.insertTodo(todoEntity: todo1)
        await viewModel.insertTodo(todoEntity: todo2)
        await viewModel.deleteTodo(id: todo1.id)

        #expect(mockStore.insertTodoCallCount == 2)
        #expect(mockStore.deleteTodoCallCount == 1)
        #expect(viewModel.todos.count == 1)
        #expect(viewModel.todos[0].id == todo2.id)
    }
}

@MainActor
@Observable
final class MockTodoStore: TodoStoreProtocol {
    private(set) var todos: [TodoEntity] = []

    private(set) var insertTodoCallCount = 0
    private(set) var deleteTodoCallCount = 0

    init(initialTodos: [TodoEntity] = []) {
        self.todos = initialTodos
    }

    func insertTodo(entity: TodoEntity) async {
        insertTodoCallCount += 1
        todos.append(entity)
    }

    func deleteTodo(id: UUID) async {
        deleteTodoCallCount += 1
        todos = todos.filter { $0.id != id }
    }
}

