//
//  Model.swift
//  SetGame
//
//  Created by mdy on 10.06.2021.
//

import Foundation


struct Card {
  
  var isSelected = false
  var tag = [Tags: String]()
  var isSet = false
  
}

class Game {
  
  var cards = [Card]()           //max 81
  var selectedCards = [Card]()   //max 3
  var fieldCards = [Card]()      //max 24
  
  func chooseCard(at index: Int) {
    guard fieldCards.indices.contains(index),        //card no in game field
          !fieldCards[index].isSet else { return }   //card in Set
    
    let card = fieldCards[index]
    
    if fieldCards[index].isSelected {
      fieldCards[index].isSelected = false
      
    } else {
      fieldCards[index].isSelected = true
      selectedCards.append(card)
    }
    
    if selectedCards.count == 3 {
      
      if isSet() {
        fieldCards[index].isSet = true
        print("set")
        
      }
      selectedCards.removeAll()
      
    }
  }
  
  func dealCards(count: Int) -> Int {
     
    guard cards.count >= count else { return cards.count }
    for _ in 1...count {
      fieldCards.append(cards.remove(at: cards.indices.randomElement()!))
    }
    return cards.count
  }
  
  
  func isSet() -> Bool {
    var set: Set<String> = []
    
    for tag in Tags.allCases {
      selectedCards.forEach { set.insert($0.tag[tag]!) }
      guard set.count != 2 else { return false }
      set.removeAll()
      
    }
    return true
  }
  
  
  
  
  
  init() {
    for fillTag in FillTag.allCases {
      for countTag in CountTag.allCases {
        for colorTag in ColorTag.allCases {
          for shapeTag in ShapeTag.allCases {
            var card = Card()
            card.tag[.fill] = fillTag.rawValue
            card.tag[.count] = countTag.rawValue
            card.tag[.color] = colorTag.rawValue
            card.tag[.shape]  = shapeTag.rawValue
            self.cards.append(card)
          }
        }
      }
    }
  }

}


enum Tags: CaseIterable {
  case color
  case shape
  case count
  case fill
      
}

enum ColorTag: String, CaseIterable {
  case green
  case red
  case blue
}

enum ShapeTag: String, CaseIterable {
  case circle
  case triangle
  case square
}

enum CountTag: String, CaseIterable {
  case one
  case two
  case three
}

enum FillTag: String, CaseIterable {
  case filled
  case striped
  case outline
}

