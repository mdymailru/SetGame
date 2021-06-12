//
//  Model.swift
//  SetGame
//
//  Created by mdy on 10.06.2021.
//

import Foundation


struct Card: Equatable {
  
  var isSelected = false
  var tag = [Tags: String]()
  var isSet = false
  
  static func == (lhs: Card, rhs: Card) -> Bool {
    return lhs.tag == rhs.tag
  }
  
}

class Game {
  
  var cards = [Card]()           //max 81
  var selectedCards = [Int]()  //max 3
  var fieldCards = [Card]()      //max 24
  
  func chooseCard(at index: Int) {
    guard fieldCards.indices.contains(index),        //card no in game field
          !fieldCards[index].isSet else { return }   //card in Set
    
    var card = fieldCards[index]
    
    if fieldCards[index].isSelected {
      selectedCards.remove(at: selectedCards.firstIndex(of: index)!)
      fieldCards[index].isSelected = false
      
    } else {
      fieldCards[index].isSelected = true
      selectedCards.append(index)
    }
    
    if selectedCards.count == 3 {
      
      if isSet() {
        fieldCards[index].isSet = true
        selectedCards.forEach { fieldCards[$0].isSet = true }
        print("set: \(selectedCards)")
      } else {
        print("no set: \(selectedCards)")
      }
      selectedCards.forEach { fieldCards[$0].isSelected = false }
      selectedCards.removeAll()
    }
  }
  
  func dealCards(count: Int) -> Int {
     
    guard cards.count >= count else { return cards.count }
    
    for _ in 1...count {
      let newCardFromDeal = cards.remove(at: cards.indices.randomElement()!)
      
      if let emptyCardPlace = fieldCards.filter{$0.isSet}.first {
        fieldCards[fieldCards.firstIndex(of: emptyCardPlace)!] = newCardFromDeal
      } else {
         fieldCards.append(newCardFromDeal)
      }
    }
    return cards.count
  }
  
  
  func isSet() -> Bool {
    var set: Set<String> = []
    
    for tag in Tags.allCases {
      selectedCards.forEach { set.insert(fieldCards[$0].tag[tag]!) }
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

