//
//  ModuleBuilder.swift
//  rssMVP
//
//  Created by Алексей Макаров on 28.02.2020.
//  Copyright © 2020 Алексей Макаров. All rights reserved.
//

import UIKit

protocol  Builder {
    static func createMainModule() -> UIViewController
}

class ModelBuilder: Builder {
    
    static func createMainModule() -> UIViewController {
        let view = MainViewController()
        let parser = FeedParser()
        let presenter = MainPresenter(view: view, parser: parser)
        view.presenter = presenter
        return view
    }
    
}
