import Foundation
import PlaygroundSupport

protocol JSONable {
  init?(json: [String : Any])
  func toJson() -> [String : Any]
}

// TODO: Have PlaceholderPost conform to JSONable
struct PlaceholderPost {
  /*
   Instructions on completing the PlaceholderPost model
   1. look at the Docs / Postman
   2. create the instance variable
   3. parse out into 100 PlaceholdersPosts
   */
  
  let userID: Int
  let id: Int
  let title: String
  let body: String
  
  /*
   CustomStringConvertible requires a single variable to be defined: description
   
   - Why even conform to CustomStringConvertible, when we can just add a "description" variable?
   -> Because objects that conform to the protocol will let print() statements automatically know
   what should be printed by passing the object in as a sole parameter or in a string interpolation
   
   ---------------------
   example w/o protocol:
   
   let post = PlaceholderPost(userID: 1, id: 1, title: "Title", body: "Body")
   print(post) // prints PlaceholderPost(userId: 1, id: 1, title: "Title", body: "Body")
   
   ---------------------
   example w/ protocol:
   
   let post = PlaceholderPost(userID: 1, id: 1, title: "Title", body: "Body")
   print(post) // prints "TITLE: Title by USER: 1"
   
   ---------------------
   example w/o protocol, but using a variable named 'description':
   
   let post = PlaceholderPost(userID: 1, id: 1, title: "Title", body: "Body")
   print(post) // prints PlaceholderPost(userId: 1, id: 1, title: "Title", body: "Body")
   print(post.description) // prints "TITLE: Title by USER: 1"
   
   - Advanced Note: There are important implications behind the scenes with how Swift handles dynamic dispatch in print(), but that's not entirely relevant or important to know right now. Dynamic dispatch is an abstract concept, and I don't necessarily recommend spending the time to research it at this moment.
   */
  var description: String {
    return "TITLE: \(title) by USER: \(userID)"
  }
  
}

struct PlaceholderComment: JSONable{
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
    
    init?(json: [String : Any]) {
        guard let jPostId = json["postId"] as? Int,
            let jId = json["id"] as? Int,
            let jName = json["name"] as? String,
            let jEmail = json["email"] as? String,
            let jBody = json["body"] as? String else {
            return nil
        }
        self = PlaceholderComment(postId: jPostId, id: jId, name: jName, email: jEmail, body: jBody)
    }
    
    init(postId: Int, id: Int, name: String, email: String, body: String) {
        self.postId = postId
        self.id = id
        self.name = name
        self.email = email
        self.body = body
    }
    
    internal func toJson() -> [String : Any] {
        let myDict: [String: Any] = [
            "postId": self.postId,
            "id": self.id,
            "name": self.name,
            "email": self.email,
            "body": self.body]
        return myDict
    }
}

// MARK: - Morning Example (Reviewing what we know w/ URLSession)
func baselineURLSession() {
  
  // 1. Make a session w/ default configuration
  let session = URLSession(configuration: URLSessionConfiguration.default)
  
  // 2. Create our URL
  // -> Remember to Option-Click variables/parameters to understand their types
  // -> Doing so will let you know why we're doing a force unwrap here
  let url = URL(string: "https://randomuser.me/api")!
  
  // 3. Create our data task
  session.dataTask(with: url, completionHandler: { (data: Data?, _, _) in
    
    // 5. Check for data
    // -> And realistically, you would check for errors as well. But in this contrived review example we're not concerned with it
    if data != nil {
      print("YAYYYY DATA: \(data!)")
      
      do {
        
        // 6. serialize and make objects
        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        
        // -> We aren't concerned with parsing this, just making sure it works
        if let validJson = json {
          print(validJson)
        }
      }
      catch {
        print("Problem casting json: \(error)")
      }
      
    }
    
    // 4. Start our data task
  }).resume()
}

// MARK: - Morning Example (Reviewing what we know w/ URLSession and applying it to URLRequest)
func newRequest() {
  
  // 1. Create our url, force unwrapping it
  let url = URL(string: "https://randomuser.me/api")!
  
  // 2. Create our request with the url and customize our requests
  // -> We specify the httpMethod as "GET" for illustrative purpose (it's already the default)
  // -> We specify a header key/value for illustrative purpose (for this API, we learned headers will be ignored if not expected or incorrect)
  var request: URLRequest = URLRequest(url: url)
  request.httpMethod = "GET"
  request.addValue("application/json", forHTTPHeaderField: "Content-Type")
  
  // 3. Create our session and data task
  // -> This time we're using dataTask(with: URLRequest), instead of dataTask(with: URL)
  let session = URLSession(configuration: URLSessionConfiguration.default)
  session.dataTask(with: request) { (data: Data?, _, _) in
    
    // 5. Check for data
    // -> Again, you should normally check for errors -- right now we don't care about it
    if data != nil {
      do {
        
        // 6. serialize and make objects
        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        
        // -> Again, We aren't concerned with parsing this, just making sure it works
        if let validJson = json {
          print(validJson)
        }
        
      }
      catch {
        print("Error parsing: \(error)")
      }
      
    }
    
    // 4. Start the data task
    }.resume()
  
}

// MARK: - Working with URLRequest and JsonPlaceholder API
func getPlaceholderRequest() {
  
  // 1. Create the URL
  let eddyTheDucksURL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
  
  // 2. Create the request and customize
  var weirdRequest = URLRequest(url: eddyTheDucksURL)
  weirdRequest.httpMethod = "GET"
  
  // 3. Create session and datatask
  let session = URLSession(configuration: URLSessionConfiguration.default)
  session.dataTask(with: weirdRequest) {( weirdData: Data?, _, weirdError: Error?) in
    
    // In the reading, they gave the URL example using Foundation types: NSURLRequest/NSMutableURLRequest
    // - Objc -
    // NSMutableURLRequest
    // NSURLRequest
    
    // - Swift -
    // URLRequest
    // let weirdRequest = URLRequest(url: eddyTheDucksURL) <--- Equiv to NSURLRequest
    // var weirdRequest = URLRequest(url: eddyTheDucksURL) <--- Equiv to NSMutableURLRequest
    
    // 5. Check for errors and data
    if weirdError != nil {
      print(weirdError!)
    }
    
    if weirdData != nil {
      do {
        
        // 6. serialize and make object
        let json = try JSONSerialization.jsonObject(with: weirdData!, options: []) as? [[String : Any]]
        
        if let validJson = json {
          print(validJson)
          
          // 7. MAKE THE WEIRD MODELS x 100
          var weirdResultArray: [PlaceholderPost] = []
          for weirdJson in validJson {
            
            // -> I haven't seen this style of guard syntax anywhere; it's just one I came up with. I like it, and happen to think it is more reable in this form. There will be developers that disagree with me, and you may be one. Ultimately, use what you think is best, but be aware that you will likely receive push back depending on who works on your code with you. What's important to note is that as long as you can make a good argument for doing something in a specific syntactic way, you may be able to persuade your team to follow your new style.
            
            // Warning: "I think it reads better" is a weak argument, as it's mostly (my) opinion.
            guard
              let userId = weirdJson["userId"] as? Int,
              let id = weirdJson["id"] as? Int,
              let title = weirdJson["title"] as? String,
              let body = weirdJson["body"] as? String
              else { return }
            
            let weirdResult = PlaceholderPost(userID: userId, id: id, title: title, body: body)
            weirdResultArray.append(weirdResult)
            
            //            print(weirdResult)
          }
          
          //          print(weirdResultArray)
        }
      }
      catch {
        print("Problem casting json: \(error)")
      }
    }
    
    // 4. Begin the task
    }.resume()
}

// MARK: - Working with URLRequest with POST
func postPlaceholderRequest() {
  
  // 1. Create URL
  let freddyMercurysURL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
  
  // 2. Create and customize the request
  // -> Here, we change the httpMethod to POST
  // -> We additionally need to set some Data for its httpBody as this API expects that for POST requests
  var bohemianRequest = URLRequest(url: freddyMercurysURL)
  bohemianRequest.httpMethod = "POST"
  
  let bohemianBicycleBody: [String : Any] = [
    "userId" : 5,
    "title" : "Ride My Bicycle",
    "body" : "I like to ride my bicycle, I like to ride my bike."
  ]
  
  // 3. We need to convert our Dictionary into Data using JSONSerialization
  // -> Essentially, this is reversing what we've been using JSONSerialization for up to this point: instead of taking Data from a request to convert it to a dictionary, we're taking a dictionary and converting it to Data
  do {
    let bohemianData = try JSONSerialization.data(withJSONObject: bohemianBicycleBody, options: [])
    
    // 4. Set the httpBody to the value of the serialized dictionary
    bohemianRequest.httpBody = bohemianData
  }
  catch {
    print("Error creating the bohemian data: \(error)")
  }
  
  // 5. Create the session and data task
  let session = URLSession(configuration: URLSessionConfiguration.default)
  session.dataTask(with: bohemianRequest) { (data: Data?, _, bohemianError: Error?) in
    
    // 7. Check for errors and Data
    if bohemianError != nil {
      print(bohemianError!)
    }
    
    if data != nil {
      print(data!)
      
      do {
        
        // 8. serialize and make objects
        let bohemianJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
        
        if let validJson = bohemianJson {
          print("Post success:\(validJson)")
          /*
           What do we do with this data now, assuming it's valid? Well, whatever you need to do with it. In this contrived example, we don't really need to do anything. Maybe we could print out the PlaceholderPost object returned if we wanted.
           
           If this was an actual app, we might want to verify that the PlaceholderPost we sent in, is the same one we're getting back. And in performing that check, we can determine if the request was successful. From there we could decided how to proceed (alert the user, pop the view controller we're on, etc..)
           
           
           pseudo code:
           if createPlaceholder(validJson) {
           alert("All went well!")
           }
           else {
           alert("Error with posting!")
           }
           
           */
          
        }
        
      }
      catch {
        print("Error encountered parsing: \(error)")
      }
    }
    
    // 6. Launch the data task
    }.resume()
  
  
}

// TODO: Exercises
func putPlaceholderRequest() { /* later code! */ }
func deletePlaceholderRequest() {  /* later code! */ }

func postComment(){
    let url = URL(string: "http://jsonplaceholder.typicode.com/comments")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let someThing: [String: Any] = ["postId": 1,
                                    "id": 1,
                                    "name": "no idea",
                                    "email": "abc@some.com",
                                    "body": "some blabla"]
    
    do {
        let myData = try JSONSerialization.data(withJSONObject: someThing, options: [])
        request.httpBody = myData
    } catch {
        print(error)
    }
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    session.dataTask(with: request) { (ourData: Data?, _, ourError: Error?) in
        if ourError != nil{
            print(ourError.unsafelyUnwrapped)
        }
        
        if ourData != nil{
            
            do{
                let json = try JSONSerialization.jsonObject(with: ourData!, options: [])
                
                if let validJson = json as? [String: Any]{
                    let finalObject = PlaceholderComment(json: validJson)
                    
                    dump(finalObject)
                }
            }
            catch{
                print("error when serialization:\(error)")
            }
        }
    }.resume()
}

func putComment(){
    let url = URL(string: "http://jsonplaceholder.typicode.com/comments/1")!
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    
    
    
}

func deleteComment(){
    
}


//baselineURLSession()
//newRequest()
//getPlaceholderRequest()
//postPlaceholderRequest()
postComment()

/*
 Why do we need this needsIndefiniteExecution propery set to true?
 
 Well, a playground executes its code, line by line, until it reaches the end of the file. At that point, execution terminates and starts over automatically (if you have auto-run enabled. otherwise, execution just ends).
 
 Why does this matter?
 
 Execution for a playground ends the moment the last line is encountered and run. Any asynchronous tasks that are launched, but don't complete in the time Swift needs to run all of the lines of code, the playground will terminate early. So our asynchronous network call gets cancelled long before it finishes.
 By saying that a playground needs indefinite execution time, it signals that the playground needs to keep running code after the last line is reached. In that way, we ensure that an async network call has enough time to be completed
 */
PlaygroundPage.current.needsIndefiniteExecution = true
