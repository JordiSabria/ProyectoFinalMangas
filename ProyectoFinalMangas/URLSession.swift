//
//  URLSession.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 3/1/24.
//

import Foundation

extension URLSession {
    func getData(from url: URL, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (Data, HTTPURLResponse) {
        do {
            let (data, response) = try await URLSession.shared.data(from: url, delegate: delegate)
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noHTTP
            }
            return (data, response)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.general(error)
        }
    }
    
//    func getData(for url: URLRequest, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (Data, HTTPURLResponse) {
//        do {
//            let (data, response) = try await URLSession.shared.data(for: url, delegate: delegate)
//            guard let response = response as? HTTPURLResponse else {
//                throw NetworkError.noHTTP
//            }
//            return (data, response)
//        } catch let error as NetworkError {
//            throw error
//        } catch {
//            throw NetworkError.general(error)
//        }
//    }
    func getData(for url: URLRequest, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (Data, HTTPURLResponse) {
        let intentosMaximos = 3
        var intentos = 0
        var datos: (Data, URLResponse)
        while intentos < intentosMaximos{
            do {
                datos = try await URLSession.shared.data(for: url, delegate: delegate)
                guard let response = datos.1 as? HTTPURLResponse else {
                    throw NetworkError.noHTTP
                }
                return (datos.0, response)
            } catch let error as NetworkError {
                throw error
            } catch let error as URLError where error.code == .timedOut {
                intentos += 1
                if intentos == intentosMaximos {
                    throw NetworkError.general(error)
                }
            } catch {
                throw NetworkError.general(error)
            }
        }
        throw NetworkError.retryLimitReached
    }
}
