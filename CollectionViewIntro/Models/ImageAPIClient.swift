//
//  ImageAPIClient.swift
//  CollectionViewIntro
//
//  Created by C4Q  on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
import UIKit



class ImageAPIClient {
    private init() {}
    static let manager = ImageAPIClient()
    func loadImage(from urlStr: String,
                   completionHandler: @escaping (UIImage) -> Void,
                   errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else {errorHandler(AppError.badURL(str: urlStr)); return}
        let completion = {(data: Data) in
            guard let onlineImage = UIImage(data: data) else {errorHandler(AppError.invalidImage); return}
            completionHandler(onlineImage)
        }
        NetworkHelper.manager.performDataTask(with: URLRequest(url: url),
                                              completionHandler: completion,
                                              errorHandler: errorHandler)
    }
}

