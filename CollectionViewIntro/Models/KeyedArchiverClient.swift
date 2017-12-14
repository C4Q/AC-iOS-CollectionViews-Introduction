//
//  KeyedArchiverClient.swift
//  CollectionViewIntro
//
//  Created by C4Q  on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class KeyedArchiverClient {
    private init() {}
    static let manager = KeyedArchiverClient()
    static let pathName = "FavoriteCards.plist"
    private var cards = [Card]() {
        didSet {
            saveCards()
        }
    }
    
    func add(card: Card) {
        cards.append(card)
    }
    
    func getCards() -> [Card] {
        return self.cards
    }
    
    func loadData() {
        let path = dataFilePath(withPathName: KeyedArchiverClient.pathName)
        do {
            let data = try Data(contentsOf: path)
            let cards = try PropertyListDecoder().decode([Card].self, from: data)
            self.cards = cards
        }
        catch {
            print(error)
        }
    }
    
    func saveCards() {
        let path = dataFilePath(withPathName: KeyedArchiverClient.pathName)
        do {
            let data = try PropertyListEncoder().encode(cards)
            try data.write(to: path, options: .atomic)
        }
        catch {
            print(error)
        }
    }
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // returns the path for supplied name from the dcouments directory
    private func dataFilePath(withPathName path: String) -> URL {
        return KeyedArchiverClient.manager.documentsDirectory().appendingPathComponent(path)
    }

}
