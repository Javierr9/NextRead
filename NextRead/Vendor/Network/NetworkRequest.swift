//
//  NetworkService.swift
//  NextRead
//
//  Created by Javier Fransiscus on 14/09/21.
//

import Foundation
import SVProgressHUD

class NetworkRequest: NSObject {
    func requestBookFromApi(completion: @escaping (BookModel) -> Void) {
        // Initiate URL Session Request
        URLSession.shared.dataTask(with: URL(string: Constant.TEST_URL)!) { data, _, _ in
            do {
                if let data = data {
                    let jsonDecoder = JSONDecoder()

                    let dataResponse = try jsonDecoder.decode(BookModel.self, from: data)

                    completion(dataResponse)
                }
            } catch {}
        }.resume()
    }

    func requestDataFromApiWith(searchQuery query: String, completion: @escaping (BookModel) -> Void) {
        guard let urlRequest = URL(string: "\(Constant.BASE_URL)\(query)&langRestrict=en") else { return }
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            do {
                if let data = data {
                    let jsonDecoder = JSONDecoder()

                    let dataResponse = try jsonDecoder.decode(BookModel.self, from: data)

                    completion(dataResponse)
                }
            } catch {
                print("error in requestBookFromAPIWith searchQuery \(error.localizedDescription) ")
            }

        }.resume()
    }

    func requestBookFromApiWith(bookId id: String, completion: @escaping (BookDataModel) -> Void) {
        guard let urlRequest = URL(string: "\(Constant.ID_URL)\(id)") else { return }
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            do {
                if let data = data {
                    let jsonDecoder = JSONDecoder()

                    let dataResponse = try jsonDecoder.decode(BookDataModel.self, from: data)
                    completion(dataResponse)
                }
            } catch {
                print(String(describing: error))
            }
        }.resume()
    }

    func requestSimilarBookFromApiWith(bookId id: String, completion: @escaping ([BookRecommendationDataModel]) -> Void) {
        guard let urlRequest = URL(string: "\(Constant.SIMILARBOOKS_URL)\(id)") else { return }

        var request = URLRequest(url: urlRequest)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { data, _, error in
            do {
                if let data = data {
                    let jsonDecoder = JSONDecoder()

                    let dataResponse = try jsonDecoder.decode([BookRecommendationDataModel].self, from: data)
                    print(dataResponse)
                    completion(dataResponse)
                }
            } catch {
                print(String(describing: error))
            }
        }.resume()
    }
}
