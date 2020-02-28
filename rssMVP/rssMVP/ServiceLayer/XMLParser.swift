//
//  NetworkService.swift
//  rssMVP
//
//  Created by Алексей Макаров on 28.02.2020.
//  Copyright © 2020 Алексей Макаров. All rights reserved.
//

import Foundation

protocol FeedParserProtocol {
    func parseFeed(url: String, completionHandler: (([RSSItem]) -> Void)?)
}

class FeedParser: NSObject, XMLParserDelegate, FeedParserProtocol {
    
    private var rssItems: [RSSItem] = []
    private var currentElement = ""
    private var currentTitle = ""
    private var currentDescription = "" {
        didSet {
//            currentDescription = currentDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    private var currentImage = ""
    private var currentAuthor = ""
    private var parserCompletionHandler: ( ([RSSItem]) -> ())?
    
    
    func parseFeed(url: String, completionHandler: (([RSSItem]) -> Void)?) {
        self.parserCompletionHandler = completionHandler
        let request = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            // pars xml
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
    
    // MARK: - XML parser Delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        
        // meduza
        if currentElement == "item" {
            currentTitle        = ""
            currentDescription  = ""
            currentAuthor       = ""
        }
        
        if currentElement == "itunes:image" {
            currentImage = attributeDict["href"]!
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        switch currentElement {
        case "title":
            currentTitle += string
        case "author":
            currentAuthor += string
        case "description":
            currentDescription += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = RSSItem(author: currentAuthor, title: currentTitle, description: currentDescription, image: currentImage)
            self.rssItems.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
        
    }
    
}
