# AC3.2-URLRequest_Demo
Example on how to make GET and POST requests with URLRequest
---

### Resources:
1. [Simple REST with Swift - grokswift](https://grokswift.com/simple-rest-with-swift/)
  - Scroll down a bit to see examples of `URLRequest`
  - I'm liking this blog more and more. Worth bookmarking. 
2. [HTTP GET Request example in Swift](http://swiftdeveloperblog.com/http-get-request-example-in-swift/)
  - Decent article, though it makes use of Foundation types instead of Swift types. 
3. [HTTP Request with POST Method - Stackoverflow](http://stackoverflow.com/questions/26364914/http-request-in-swift-with-post-method)
  - How to send values view `HTTPBody` in `POST` requests
4. [Completion Handlers in Swift - grokswift](https://grokswift.com/completion-handlers-in-swift/)
  - Very nice explanation of completion handlers if you need a refresher/more detail
  - Also, the example uses JSONPlaceholder as well, so good place to get used to it
5. [Building URLs with URLComponent and URLQueryItems](https://grokswift.com/building-urls/)

### References: 
1. [URLRequest - Apple Doc](https://developer.apple.com/reference/foundation/urlrequest)
2. [JSONPlaceholder](https://jsonplaceholder.typicode.com/)
3. [JSONPlaceholder Github (better docs)](https://github.com/typicode/jsonplaceholder)
4. [Updating NSURLSession to Swift 3](https://grokswift.com/updating-nsurlsession-to-swift-3-0/)
  - Shows you the changes to `URLSession` from Swift 2.0 -> 3.0

### Advanced:
1. [Making a POST Request in Swift - Jameson Quave](http://jamesonquave.com/blog/making-a-post-request-in-swift/)
  - Shows you how to set up a fake endpoint in Ruby as well

---
### Lesson Objectives

1. Briefly review `URLSession` and making a simple request
2. Introduce `URLRequest` making a simple `GET` request to a familiar API (randomUser)
3. Make another `GET URLRequest` with a new API (jsonPlaceholder)
4. Make our first `POST` request on jsonPlaceholder
  - Encounter serialization with the `.httpBody` property
    
---
### Lesson Notes:

**SEE PLAYGROUND FOR INFO**

---
### Exercises:

All of these are optional, and are provided for you to get a better understanding for today's lesson. I highly encourage completing #1, at least one example for #2 (one "example" meaning four functions for a single endpoint), at least one example for #3 and all of #4. 

1. Complete the two addition, currently empty, functions in the playground to demonstrate making a `PATCH/PUT` and `DELETE` request on the `/posts` endpoint
2. Create 4 functions (one each for `GET, POST, PUT/PATCH, DELETE`) for any number of additional endpoints (`/users, /albums, /todos, etc`) until you feel confident in using `URLRequest` and serializing `Dictionary`s for the `httpBody` property of your request. 
3. Instead of doing 4 functions per endpoint, refactor your code into just a single function. 
  - To handle the different possibilities of data, make use of default parameter values and optional parameter values
4. Implement the `JSONable` protocol on the `PlaceholderPost` model
  - If you did exercise #2, make sure the models you create for the endpoints you use also conform to `JSONable` AND `CustomStringConvertable`
