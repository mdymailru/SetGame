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
  var isHelp = false
  
  static func == (lhs: Card, rhs: Card) -> Bool {
    return lhs.tag == rhs.tag
  }
  
}

class Game {
  
  var cards = [Card]()           //max 81
  var indicesOfSelected = [Int]()    //max 3
  var fieldCards = [Card?]()      //max 24
  var indicesOfHelp = [Int]()    //max 3
  //var indicesOfMatched = [Int]()
  var failInfo: String?
  var countDealCards: Int
  
  func chooseCard(at index: Int) {
    guard let card = fieldCards[index],             //card in field
             !card.isSet else { return }            //card in Set
    console(index)
    failInfo = nil
    
    if card.isHelp { //hide selection of help cards
      indicesOfHelp.forEach { fieldCards[$0]!.isHelp = false }
      indicesOfHelp.removeAll()
    }
    
    if fieldCards.compactMap({$0}).filter({$0.isSet}).count > 2 {
      if !dealCards() {
        indicesOfSelected.forEach { fieldCards[$0]?.isSelected = false ; fieldCards[$0] = nil }
        indicesOfSelected.removeAll()
      }
    }
    
    if card.isSelected {
      indicesOfSelected.remove(at: indicesOfSelected.firstIndex(of: index)!)
      fieldCards[index]!.isSelected = false
    } else {
      fieldCards[index]!.isSelected = true
      indicesOfSelected.append(index)
      
      if indicesOfSelected.count == 3 {
        if isSet(indicesOfSelected) {
          indicesOfSelected.forEach { fieldCards[$0]?.isSet = true }
        }
      }
      
      if indicesOfSelected.count == 4 {
        
        indicesOfSelected.forEach { fieldCards[$0]?.isSelected = false }
        fieldCards[index]!.isSelected = true
        indicesOfSelected.removeFirst(3)
        
      }
      
    }
    
  }
  
  func dealCards(count: Int = 3) -> Bool {
     
    guard countDealCards >= count else { return false }
    
    for _ in 1...count {
      let newCardFromDeal = cards.remove(at: cards.indices.randomElement()!)
      
      
      if let emptyCardPlace = fieldCards.filter({$0?.isSet ?? false}).first {
        fieldCards[fieldCards.firstIndex(of: emptyCardPlace)!] = newCardFromDeal
        
      } else {
         //fieldCards.append(newCardFromDeal)
        if let index = fieldCards.indices.filter({fieldCards[$0] == nil}).randomElement() {
          fieldCards[index] = newCardFromDeal
        } 
      }
    }
    countDealCards = cards.count
    return true
  }
  
  
  func isSet(_ indexForSearchCards: [Int]) -> Bool {
    var set = Set<String>()
    
    for tag in Tags.allCases {
      //indexForSearchCards.forEach { set.insert(fieldCards[$0].tag[tag]!) }
      
      var tagFail = ""
      for index in indexForSearchCards {
        let result = set.insert(fieldCards[index]!.tag[tag]!)
        if !result.inserted { tagFail = result.memberAfterInsert }
      }
        guard set.count != 2 else { failInfo = "\(tag): 2 \(tagFail)"; return false }
        set.removeAll()
    }
    failInfo = nil
    return true
  }
  
 //findSet
  
  func findSet() -> [Int]? {
    
    let indexInGameCards = fieldCards.indices.filter { !(fieldCards[$0]?.isSet ?? true) }
    
    let m = 3
    let n = indexInGameCards.count
    var a = [Int]()
    var indexOfSearchSetCards = [Int]()
    var exit = false
    
    indicesOfSelected.forEach { fieldCards[$0]?.isSelected = false }
    indicesOfSelected.removeAll()
    
    func gen(_ num: Int, _ last: Int) {
        if num == m {
            for i in 0..<m {
              indexOfSearchSetCards.append(indexInGameCards[(a[i] - 1)])
            }
          if isSet(indexOfSearchSetCards) {
            indexOfSearchSetCards.forEach {
              fieldCards[$0]!.isHelp = true
              print("\($0) \(fieldCards[$0]!)")
            }
            indicesOfHelp = indexOfSearchSetCards
            exit = true
            return
          } else {
            indexOfSearchSetCards.removeAll()
          }
          print(a[0..<m])
          
        }
        for i in (last + 1)..<(n + 1) {
            guard !exit else {return}
            a.append(i)
            gen(num + 1, i)
            a.removeLast(1)
        }
    }
    
    gen(0, 0)
    return exit ? indexOfSearchSetCards : nil
  }
  
  private func console(_ index: Int) {
    print("\(index) \(fieldCards[index]!.tag[.color]!) "
                 + "\(fieldCards[index]!.tag[.shape]!) "
                 + "\(fieldCards[index]!.tag[.count]!) "
                 + "\(fieldCards[index]!.tag[.fill]!)")
  }
  
  
  init(fieldSize: Int) {
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
    self.countDealCards = cards.count
    
    //for _ in 0..<fieldSize { fieldCards.append(nil) }
    self.fieldCards = Array<Card?>(repeating: nil, count: fieldSize)
    
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

