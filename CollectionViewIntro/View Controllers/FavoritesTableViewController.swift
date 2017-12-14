//
//  FavoritesTableViewController.swift
//  CollectionViewIntro
//
//  Created by C4Q  on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {

    var cards = [Card]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cards = KeyedArchiverClient.manager.getCards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cards = KeyedArchiverClient.manager.getCards()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Favorite Cell", for: indexPath)
        let card = cards[indexPath.row]
        cell.textLabel?.text = card.text
        cell.imageView?.image = nil
        if let image = card.imageUrl {
            ImageAPIClient.manager.loadImage(from: image, completionHandler: {cell.imageView?.image = $0; cell.setNeedsLayout()}, errorHandler: {print($0)})
        }
        return cell
    }
}
