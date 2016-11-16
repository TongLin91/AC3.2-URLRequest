//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

/*
 What is the CustomStringConvertible protocol? Glad you asked
 
 Conforming to this protocol means you need to implement the "description" property, which is a computerd
 value that is used in places where a description of an object is printed out... such as anywhere you call print()
 */
struct PlaceholderPost: CustomStringConvertible {
  let body: String
  let title: String
  let id: Int
  let userID: Int
  
  var description: String {
    return "\(self.title) by user  \(self.userID)"
  }
}

// GET Request
func getAllPosts() {
  
  // create a new URLRequest
  var getRequest = URLRequest(url: URL(string: "http://jsonplaceholder.typicode.com/posts/")!)
  
  // set the HTTP method
  getRequest.httpMethod = "GET"
  
  // add header fields
  getRequest.addValue("application/json", forHTTPHeaderField: "Content-Type") // this API specifically asks that we pass this header key/value
  
  // y'all know this part... ❤️
  // create a new session
  let session = URLSession(configuration: URLSessionConfiguration.default)
  
  // this is slightly different: we use dataTask(with: URLRequest) instead of dataTask(with: URL)
  session.dataTask(with: getRequest) { (data: Data?, urlResponse: URLResponse?, error: Error?) in
    
    if error != nil {
      print(error!)
    }
    
    if urlResponse != nil {
      print(urlResponse!)
    }
    
    if data != nil {
      do {
        let jsonData = try JSONSerialization.jsonObject(with: data!, options: [])
        
        // be aware that casting a single post will fail, as the return type is [String : AnyObject]
        guard let parsedJson = jsonData as? [[String : AnyObject]] else {
          print("ERROR attempting to cast Any to [[String:AnyObject]]")
          return
        }
        
        var returnedPosts = [PlaceholderPost]()
        for postJson in parsedJson {
          guard
            let body = postJson["body"] as? String,
            let title = postJson["title"] as? String,
            let id = postJson["id"] as? Int,
            let userID = postJson["userId"] as? Int else {
              print("Error parsing post keys")
              return
          }
          
          let newPost = PlaceholderPost(body: body, title: title, id: id, userID: userID)
          returnedPosts.append(newPost)
        }
        
        //        print(returnedPosts)
      }
      catch {
        print("error occured parsing: \(error)")
      }
    }
    }.resume()
  
}

// POST Request
func postNewPost() {
  var postRequest = URLRequest(url: URL(string: "http://jsonplaceholder.typicode.com/posts/")!)
  postRequest.httpMethod = "POST"
  postRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
  let httpBodyDict: [String : Any] = [
    "title" : "Test Title",
    "body" : "THis is the body of the text!!",
    "userId" : 1
  ]
  
  do {
    let jsonData = try JSONSerialization.data(withJSONObject: httpBodyDict, options: [])
    
    postRequest.httpBody = jsonData
  }
  catch {
    print("Error attempting to convert dictionary to data")
  }
  
  let session = URLSession(configuration: URLSessionConfiguration.default)
  session.dataTask(with: postRequest) { (data: Data?, urlResponse: URLResponse?, error: Error?) in
    
    if error != nil {
      print(error!)
    }
    
    if urlResponse != nil {
      print(urlResponse!)
    }
    
    if data != nil {
      
      do {
        let jsonData = try JSONSerialization.jsonObject(with: data!, options: [])
        
        guard let parsedJsonData = jsonData as? [String : AnyObject] else {
          print("Error casting Any to [String : AnyObject]")
          return
        }
        
        guard let title = parsedJsonData["title"] as? String,
          let body = parsedJsonData["body"] as? String,
          let id = parsedJsonData["id"] as? Int,
          let userId = parsedJsonData["userId"] as? Int else {
            print("Error parsing post")
            return
        }
        
        let newPost = PlaceholderPost(body: body, title: title, id: id, userID: userId)
        print(newPost)
      }
      catch {
        print("error occured parsing: \(error)")
      }
    }
    }.resume()
  
}

//let urlComponents = URLComponents(string: "http://jsonplaceholder.typicode.com/posts/")
//print(urlComponents)

//print(urlComponents?.host)
//print(urlComponents?.password)
//print(urlComponents?.path)
//print(urlComponents?.port)
//print(urlComponents?.scheme)
//print(urlComponents?.url)
//print(urlComponents?.string)
//print(urlComponents?.user)



// uncomment as needed (will cause some performance issues)
//getAllPosts()
postNewPost()

// uncommon the below to allow this playground to work properly
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
