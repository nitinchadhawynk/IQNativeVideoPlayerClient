//
// Created by Thomas Christensen on 26/08/16.
// Copyright (c) 2016 Sebastian Kreutzberger. All rights reserved.
//

import Foundation
/**
* Reads the document found at the specified URL in one chunk synchonous
* and then lets the readLine function pick it line by line.
*/
class URLBufferedReader: BufferedReader {
    var _uri: URL
    var _stringReader: StringBufferedReader

    init(uri: URL,with header:[String:String]? = nil) {
        _uri = uri
        _stringReader = StringBufferedReader(string: "")
        var request1: URLRequest = URLRequest(url: _uri)
        request1.allHTTPHeaderFields = header
    
        //let response: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        
        let semaphore = DispatchSemaphore(value:0)

        URLSession.shared.dataTask(with: request1) { (httpData, response, error) in
            guard let data = httpData else { return }
            let text = String(data: data, encoding: String.Encoding.utf8)!
            self._stringReader = StringBufferedReader(string: text)
            semaphore.signal()
        }.resume()

        semaphore.wait()
//
//        do {
//
//            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returning: response)
//            let text = String(data: dataVal, encoding: String.Encoding.utf8)!
//            _stringReader = StringBufferedReader(string: text)
//        } catch {
//            print("Failed to make request for content at \(_uri)")
//        }
    }

    func close() {
        _stringReader.close()
    }

    func readLine() -> String? {
        return _stringReader.readLine()
    }

}
