import UIKit
import SwiftyJSON
import Alamofire

class API {
    
    static let shared = API()
    
    func search(searchText: String, offset: Int, completion: @escaping (JSON) -> ()) {
        
        let request = "https://api.giphy.com/v1/gifs/search?api_key=XTqrUYSYlYYjsLWOoTXJY6mB3DjA8D8n&q=\(searchText)&limit=10&offset=\(offset)&rating=G&lang=en"
//        print(request)
        Alamofire.request(request, method: .get).responseJSON { response in
            if response.result.isSuccess == false {
                print("ERROR GET JSON Pagination")
                return
            } else {
                if let data = response.data {
                    let json = JSON(data)
                    completion(json)
                }
            }
        }
    }

    func loadData(urlString: String, completion: @escaping (Data) -> ()) {
        request(urlString).responseData { response in
            if response.error != nil {return}
            completion(response.data!)
        }
    }
}
