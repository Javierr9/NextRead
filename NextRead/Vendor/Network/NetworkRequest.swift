//
//  NetworkService.swift
//  NextRead
//
//  Created by Javier Fransiscus on 14/09/21.
//

import Foundation


class NetworkRequest: NSObject {
    
    
    func requestBookFromApi(completion: @escaping (BookModel)->()){
        //Initiate URL Session Request
        URLSession.shared.dataTask(with: URL(string: Constant.TEST_URL)!) { data, response, error in
            do{
                if let data = data{
                    let jsonDecoder = JSONDecoder()
                    
                    let dataResponse = try jsonDecoder.decode(BookModel.self, from: data)
                    
                    completion(dataResponse)
                    
                }
            }catch {}
        }.resume()
    }
    
    func requestDataFromApiWith(searchQuery query: String, completion: @escaping (BookModel)->()){
        guard let urlRequest = URL(string: "\(Constant.BASE_URL)\(query)&langRestrict=en") else {return}
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            do{
                if let data = data{
                    let jsonDecoder = JSONDecoder()
                    
                    let dataResponse = try jsonDecoder.decode(BookModel.self, from: data)
                    
                    completion(dataResponse)
                    
                }
            }catch {
                print("error in requestBookFromAPIWith searchQuery \(error.localizedDescription) ")
            }
            
        }.resume()
    }
    
    func requestBookFromAPIWith(bookId id: String, completion: @escaping (BookDataModel)->()){
        guard let urlRequest = URL(string: "\(Constant.ID_URL)\(id)") else {return}
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            do{
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    
                    let dataResponse = try jsonDecoder.decode(BookDataModel.self, from: data)
                    completion(dataResponse)
                }
            }catch{
                print("error in requestBookFromAPIWith bookId \(error.localizedDescription) ")
            }
        }.resume()
    }
    
}
