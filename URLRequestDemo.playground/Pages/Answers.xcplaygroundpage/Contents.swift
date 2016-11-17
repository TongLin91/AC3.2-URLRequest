
import Foundation
import PlaygroundSupport

struct PlaceholderPost{
    var userId: Int
    var id: Int
    var title: String
    var body: String
}

func baselineURLSession(){

let session = URLSession(configuration: URLSessionConfiguration.default)

let url = URL(string: "https://randomuser.me/api")!

session.dataTask(with: url, completionHandler: { (data: Data?, _, _) in
    
    if data != nil{
        print("Yayyyyyy Data: \(data!)")
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
            
            if let validjson = json{
                print(validjson)
            }
            
        } catch{
            print("Problem casting json")
        }
    }
    
}).resume()

}

func newRequest(){
    let url = URL(string: "https://randomuser.me/api")!
    var request: URLRequest = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    session.dataTask(with: request) { (data: Data?, _, error: Error?) in
        
        if error != nil{
            print("Error: \(error!)")
        }
        if data != nil{
            print("Yayyyyyy Data: \(data!)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                
                if let validjson = json{
                    print(validjson)
                }
                
            } catch{
                print("Problem casting json")
            }
        }
    }.resume()
}

func getPlaceholderRequest(){
    let url = URL(string: "http://jsonplaceholder.typicode.com/posts")
    var request = URLRequest(url: url!)
    request.httpMethod = "GET"
    
    var finalPosts = [PlaceholderPost]()
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    session.dataTask(with: request) { (data: Data?, _, _) in
        if data != nil{
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: Any]]
                if let validjson = json{
                    print(validjson)
                    
                    for singleData in validjson{
                        guard let userId = singleData["userId"] as? Int,
                            let id = singleData["id"] as? Int,
                            let title = singleData["title"] as? String,
                            let body = singleData["body"] as? String else{
                                return
                        }
                        finalPosts.append(PlaceholderPost(userId: userId, id: id, title: title, body: body))
                    }
                    print(finalPosts)
                    
                }
            }catch{
                print("Error here")
            }
        }
    }.resume()
}

func postPlaceholderRequest(){
    let url = URL(string: "http://jsonplaceholder.typicode.com/posts")
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    
    let something: [String: Any] = ["userId": 5, "title": "alalalall", "body": "Hula Hula"]
    
    do {
        let myData = try JSONSerialization.data(withJSONObject: something, options: [])
        
        request.httpBody = myData
        
    } catch  {
        print(error)
    }
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    session.dataTask(with: request) { (data: Data?, _, someError: Error?) in
        
        if someError != nil{
            print(someError!)
        }
        
        if data != nil{
            print(data!)
            
            do {
                let finalJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                
                if let wowData = finalJson{
                    print(wowData)
                }
                
            } catch{
                print(error)
            }
            
        }
        
    }.resume()
    
}

func deletePlaceholderRequest(){}


//baselineURLSession()
//newRequest()
//getPlaceholderRequest()
postPlaceholderRequest()
PlaygroundPage.current.needsIndefiniteExecution = true

