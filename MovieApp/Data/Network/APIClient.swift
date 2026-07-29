import Foundation
import Combine

protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: TMDBEndpoint) -> AnyPublisher<T, NetworkError>
}

final class APIClient: APIClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    func request<T: Decodable>(_ endpoint: TMDBEndpoint) -> AnyPublisher<T, NetworkError> {
        guard let url = endpoint.url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: url)
            .mapError { NetworkError.requestFailed($0) }
            .tryMap { data, response in
                guard let http = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                guard (200...299).contains(http.statusCode) else {
                    throw NetworkError.httpError(http.statusCode)
                }
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error -> NetworkError in
                if let netErr = error as? NetworkError { return netErr }
                return NetworkError.decodingFailed(error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
