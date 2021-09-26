//
//  NetworkService.swift
//  NextRead
//
//  Created by Javier Fransiscus on 14/09/21.
//

import Foundation


class NetworkRequest: NSObject {
    
    
    func requestDataFromAPI(completion: @escaping (BookModel)->()){
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
    
    
    func requestDataFromAPIWithQuery(query: String, completion: @escaping (BookModel)->()){
        URLSession.shared.dataTask(with: URL(string: "\(Constant.BASE_URL)\(query)&langRestrict=en")!) { data, response, error in
            do{
                if let data = data{
                    let jsonDecoder = JSONDecoder()
                    
                    let dataResponse = try jsonDecoder.decode(BookModel.self, from: data)
                    
                    completion(dataResponse)
                    
                }
            }catch {}
            
        }.resume()
    }
    
    
}
