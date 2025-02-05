//
//  NetworkService.swift
//  CryptoStatistics
//
//  
//

// https://data.messari.io/api/v1/assets/«тутмонета»/metrics

import Foundation
import Combine

//MARK: - INetworkService
protocol INetworkService {
    func getData<T: Decodable>(
        with urlString: String,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
    /// Structured Concurrency
//    func getData<T: Decodable>(
//        with urlString: String
//    ) async throws -> T
    /// Combine
//    func getData<T: Decodable>(
//        with urlString: String
//    ) -> AnyPublisher<T, NetworkError>
}

//MARK: - NetworkService
final class NetworkService: INetworkService {

    //MARK: Combine
/*
    func getData<T: Decodable>(with urlString: String) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkError.urlError)
                .eraseToAnyPublisher()
        }

        guard let request = buildRequest(url: url) else {
            return Fail(error: NetworkError.requestError)
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: request)

            .tryMap { data, response -> Foundation.Data in
                if let error = self.checkResponseCode(response) {
                    throw error
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { _ in NetworkError.decodingError }
            .eraseToAnyPublisher()
    }

    //MARK: Async Await

    func getData<T: Decodable>(with urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.urlError
        }

        guard let request = buildRequest(url: url) else {
            throw NetworkError.requestError
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        if let error = checkResponseCode(response) {
            throw error
        }
        do {
            let convertedData = try JSONDecoder().decode(T.self, from: data)
            return convertedData
        } catch {
            throw NetworkError.decodingError
        }
    }
*/
    //MARK: Completion

    func getData<T: Decodable>(
        with urlString: String,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlError))
            return
        }

        guard let request = buildRequest(url: url) else {
            completion(.failure(.requestError))
            return
        }

        let task = createDataTask(with: request, completion: { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
        task.resume()
    }
}

//MARK: - Private methods
private extension NetworkService {

    func buildRequest(url: URL) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPType.get.rawValue
        return request
    }

    func createDataTask(with request: URLRequest, completion: @escaping (Result<Foundation.Data, NetworkError>) -> Void) -> URLSessionDataTask {
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(error as! NetworkError))
            } else if let responseErrorCode = self?.checkResponseCode(response) {
                completion(.failure(responseErrorCode))
            } else if let data = data {
                completion(.success(data))
            }
        }
        
        return dataTask
    }

    func checkResponseCode(_ response: URLResponse?) -> NetworkError? {
        guard let response = response as? HTTPURLResponse else {
            return .responseError
        }
        switch response.statusCode {
        case 200...299:
            return nil
        case 400...499:
            return .clientError(response.statusCode)
        case 500...599:
            return .serverError(response.statusCode)
        default:
            return .invalidResponseCode(response.statusCode)
        }
    }
}

