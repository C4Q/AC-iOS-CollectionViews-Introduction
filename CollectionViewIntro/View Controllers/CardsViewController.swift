//
//  ViewController.swift
//  CollectionViewIntro
//
//  Created by C4Q  on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit


class CardsViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cards = [Card]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var searchTerm = "" {
        didSet {
            loadCards(from: searchTerm)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSearchTermToMostRecent()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.searchBar.delegate = self
    }

    func setSearchTermToMostRecent() {
        if let str = UserDefaults.standard.object(forKey: "mostRecentSearch") as? String {
            self.searchTerm = str
            self.searchBar.text = str
        }
    }
    
    func loadCards(from str: String) {
        CardAPIClient.manager.getCards(matching: str, completionHandler: {self.cards = $0}, errorHandler: {print($0)})
    }
    //If you intend on segueing from a Collection View Cell
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedIndexPath = self.collectionView.indexPathsForSelectedItems?[0] {
            let row = selectedIndexPath.row
            
        }
    }
    
}

extension CardsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            self.searchTerm = text
            UserDefaults.standard.set(text, forKey: "mostRecentSearch")
        }
        searchBar.resignFirstResponder()
    }
}

extension CardsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2, height: collectionView.bounds.height / 2)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = cards[indexPath.row]
        KeyedArchiverClient.manager.add(card: card)
        let alertVC = UIAlertController(title: "Added", message: "Added to favorites", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

extension CardsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card Cell", for: indexPath) as? CardCollectionViewCell else {
            //TO DO (Handle this failure)
            return UICollectionViewCell()
        }
        let card = cards[indexPath.row]
        cell.nameLabel.text = card.name
        cell.cardImageView.image = nil
        if let imageUrl = card.imageUrl {
            ImageAPIClient.manager.loadImage(from: imageUrl,
                                             completionHandler: {
                                                cell.cardImageView.image = $0
                                                cell.setNeedsLayout()},
                                             errorHandler: {print($0)})
        }
        return cell
    }
}

