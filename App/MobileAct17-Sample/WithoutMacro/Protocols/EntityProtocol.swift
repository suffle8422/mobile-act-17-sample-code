import Foundation

protocol EntityProtocol: Sendable, Codable, Hashable, Identifiable {
    var id: UUID { get }
}
