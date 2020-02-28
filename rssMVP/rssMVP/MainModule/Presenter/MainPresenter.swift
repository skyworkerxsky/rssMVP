//
//  MainPresenter.swift
//  rssMVP
//
//  Created by Алексей Макаров on 28.02.2020.
//  Copyright © 2020 Алексей Макаров. All rights reserved.
//

import Foundation

protocol MainViewProtocol: class {
    func success()
    func failure(error: Error)
}

protocol MainViewPrecenterProtocol: class {
    init(view: MainViewProtocol, parser: FeedParserProtocol)
    func getData()
    var rssItems: [RSSItem]? { get set }
}

class MainPresenter: MainViewPrecenterProtocol {
    
    weak var view: MainViewProtocol?
    let parser: FeedParserProtocol!
    var rssItems: [RSSItem]?
    var arrayItems: [RSSItem]?
    
    required init(view: MainViewProtocol, parser: FeedParserProtocol) {
        self.view = view
        self.parser = parser
        getData()
    }
    
    func getData() {
        let feedParser = FeedParser()
        feedParser.parseFeed(url: "https://meduza.io/rss/podcasts/meduza-v-kurse") { [weak self] (items) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.rssItems = items
                self.view?.success()
            }
        }
    }
    
}


