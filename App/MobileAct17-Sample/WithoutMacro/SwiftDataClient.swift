import Foundation
import SwiftData

actor SwiftDataClient: ModelActor {
    nonisolated let modelExecutor: any ModelExecutor
    nonisolated let modelContainer: ModelContainer
    let modelContext: ModelContext

    private init(modelContainer: ModelContainer) {
        modelContext = ModelContext(modelContainer)
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
        self.modelContainer = modelContainer
    }

    func get<T: EntityConvertible>(id: UUID, from modelType: T.Type) -> T.Entity? {
        let descriptor = FetchDescriptor<T>(predicate: #Predicate {
            $0.id == id
        })
        let model = try? modelContext.fetch(descriptor).first
        return model?.entity()
    }

    func fetch<T: EntityConvertible>(descriptor: FetchDescriptor<T>) -> [T.Entity] {
        let entities = try? modelContext.fetch(descriptor).compactMap { $0.entity() }
        return entities ?? []
    }

    func insert<T: EntityConvertible>(entity: T.Entity, from modelType: T.Type) {
        let model = T.init(entity: entity)
        modelContext.insert(model)
        try? modelContext.save()
    }

    func delete<T: EntityConvertible>(id: UUID, from modelType: T.Type) {
        let descriptor = FetchDescriptor<T>(
            predicate: #Predicate {
            $0.id == id
        })
        guard let model = try? modelContext.fetch(descriptor).first else { return }
        modelContext.delete(model)
        try? modelContext.save()
    }
}

extension SwiftDataClient {
    private static let modelTypes: [any PersistentModel.Type] = [TodoModel.self]

    static let liveValue: SwiftDataClient = .init(modelContainer: modelContainer(forTest: false))
    static var testValue: SwiftDataClient { .init(modelContainer: modelContainer(forTest: true)) }

    private static func modelContainer(forTest: Bool) -> ModelContainer {
        do {
            let schema = Schema(modelTypes)
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: forTest)
            let modelContainer = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            return modelContainer
        } catch {
            fatalError("Failed to initialize SwiftDatabase: \(error)")
        }
    }
}
