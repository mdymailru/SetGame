//
//  ViewController.swift
//  SetGame
//
//  Created by mdy on 09.06.2021.
//

import UIKit

class ViewController: UIViewController {

  let game = Game()
  var isPlaceForCard = true {
    didSet { dealButton.isEnabled = isPlaceForCard }
  }
  
  var countOfCards: Int! {
    didSet { dealButton.setTitle("Еще 3...\(countOfCards!)", for: .normal) }
  }
  
  var indexOfSetHelp : [Int]? {
    didSet { if let indices = indexOfSetHelp {
                helpButton.setTitle("\(indices[0...2])" , for: .normal)
           } else {
            helpButton.setTitle("No Set" , for: .normal)
           }
    }
  }
  
  
  @IBOutlet var buttonCards: [UIButton]!
  
  @IBOutlet weak var helpButton: UIButton!
  @IBOutlet weak var dealButton: UIButton!
  
  @IBAction func touchButtonCard(_ sender: UIButton) {
    guard let index = buttonCards.firstIndex(of: sender),
          game.fieldCards.indices.contains(index) else { return }
    
    
    print("\(index) \(game.fieldCards[index].tag[.color]!) \(game.fieldCards[index].tag[.shape]!) \(game.fieldCards[index].tag[.count]!) \(game.fieldCards[index].tag[.fill]!)")
    
    game.chooseCard(at: index)
    updateViewFromModel()
  }
  
  @IBAction func touchDealButton(_ sender: UIButton) {
    
    if isPlaceForCard {
      countOfCards = game.dealCards(count: 3)
      updateViewFromModel()
    } else { print("no place") }
    
    //isPlaceForCard = buttonCards.count > game.fieldCards.filter({!$0.isSet}).count
  }
  
  @IBAction func touchHelp(_ sender: UIButton) {
    indexOfSetHelp = game.findSet()
    
  }
  
  
  func updateViewFromModel() {
    for index in buttonCards.indices {
      let button = buttonCards[index]
      button.backgroundColor = .black
     
      
      if game.fieldCards.indices.contains(index) {
        let card = game.fieldCards[index]
        
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        
        
        if card.isSelected {
          button.layer.borderWidth = 3.0
          button.layer.borderColor = UIColor.red.cgColor
        } else {
          button.layer.borderWidth = 0.0
        }
        
        if card.isSet {
          button.backgroundColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        }
        
        button.setAttributedTitle(getCardTitle(card: card), for: .normal)
      
      } else {
        button.setTitle(nil, for: .normal)
        button.setAttributedTitle(nil, for: .normal)
      }
     
    }
    
    isPlaceForCard = buttonCards.count > game.fieldCards.filter({!$0.isSet}).count
  }
  
  func getCardTitle(card: Card) -> NSAttributedString {
    
    let empty = NSAttributedString(string: "?", attributes: nil)
    
    var color: UIColor
    switch ColorTag.init(rawValue: card.tag[.color]!) {
      case .blue: color = .blue
      case .green: color = .systemGreen
      case .red: color = .red
      case .none: return empty
    }
    var shapeColor: UIColor
    var strokeWith: Int
    switch FillTag.init(rawValue: card.tag[.fill]!) {
      case .striped: shapeColor = UIColor.withAlphaComponent(color)(0.27); strokeWith = -5
      case .filled: shapeColor = UIColor.withAlphaComponent(color)(1); strokeWith = -5
      case .outline: shapeColor = UIColor.withAlphaComponent(color)(1); strokeWith = 5
      case .none: return empty
    }
    
    var shape: String
    switch ShapeTag.init(rawValue: card.tag[.shape]!) {
      case .circle: shape = "⚫︎"
      case .triangle: shape = "▲"
      case .square: shape = "◼︎"
      case .none: return empty
    }
    
    var str: String
    switch CountTag.init(rawValue: card.tag[.count]!) {
      case .one: str = shape
      case .two: str = shape + shape
      case .three: str = shape + shape + shape
      case .none: return empty
    }
    
    let attribute: [NSAttributedString.Key: Any] = [
      .foregroundColor: shapeColor,
      //.strokeColor: UIColor.systemOrange,
      .strokeWidth: strokeWith,
      .font: UIFont.systemFont(ofSize: 30) ]
      //.font: UIFont(name: "AppleSymbols", size: 35 )  ]
    
    return NSAttributedString(string: str, attributes: attribute)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    countOfCards = game.dealCards(count: 12)
    updateViewFromModel()
    //button.titleLabel?.lineBreakMode = .byCharWrapping
    
  }


}

