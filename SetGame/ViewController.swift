//
//  ViewController.swift
//  SetGame
//
//  Created by mdy on 09.06.2021.
//

import UIKit

class ViewController: UIViewController {

  let game = Game(fieldSize: 24)
  var isPlaceForCard = true {
    didSet { dealButton.isEnabled = isPlaceForCard }
  }
  var indexOfSetHelp : [Int]? {
    didSet { if let indices = indexOfSetHelp {
                    helpButton.setTitle("\(indices[0...2])" , for: .normal)
           } else { helpButton.setTitle("No Set" , for: .normal) }
    }
  }
  var infoTitle = "" {
    didSet { infoLabel.text = infoTitle }
  }
  
  @IBOutlet var buttonCards: [UIButton]!
  @IBOutlet weak var infoLabel: UILabel!
  
  @IBOutlet weak var helpButton: UIButton!
  @IBOutlet weak var dealButton: UIButton!
  
  @IBAction func swipeAction(_ sender: UISwipeGestureRecognizer) {
    touchDealButton(dealButton)
  }
  
  @IBAction func touchButtonCard(_ sender: UIButton) {
    guard let index = buttonCards.firstIndex(of: sender) else { return }
    game.chooseCard(at: index)
    updateViewFromModel()
  }
  
  @IBAction func touchDealButton(_ sender: UIButton) {
    if game.dealCards() {
      updateViewFromModel()
      helpButton.setTitle("Help", for: .normal)
    }
  }
  
  @IBAction func touchHelp(_ sender: UIButton) {
    indexOfSetHelp = game.findSet()
    updateViewFromModel()
  }
  
  func updateViewFromModel() {
    for index in buttonCards.indices {
      let button = buttonCards[index]
      
      if let card = game.fieldCards[index] {
        
        button.backgroundColor = App.inFieldCardBackColor
        button.layer.cornerRadius = 8
        
        if card.isSelected {
          button.layer.borderWidth = 3.0
          button.layer.borderColor = UIColor.red.cgColor
        } else {
          if card.isHelp {
            button.layer.borderWidth = 3.0
            button.layer.borderColor = UIColor.yellow.cgColor
          } else {
            button.layer.borderWidth = 0.0
          }
        }
        if card.isSet { //card button in Set
          button.backgroundColor = App.inSetCardBackColor
          helpButton.setTitle("Help", for: .normal)
        }
        
        button.setAttributedTitle(getCardTitle(card: card), for: .normal)
      
      } else {                                         //no use card button
        button.setTitle(nil, for: .normal)
        button.setAttributedTitle(nil, for: .normal)
        button.layer.borderWidth = 0.0
        button.backgroundColor = App.noUseCardBackColor
      }
      infoTitle = game.failInfo ?? ""
    }
    
    dealButton.setTitle("?????? 3 ????: \(game.countDealCards)", for: .normal)
    isPlaceForCard = (buttonCards.count > game.fieldCards.compactMap({$0}).filter({!$0.isSet}).count) &&
                      game.countDealCards != 0
  }
  
  private func getCardTitle(card: Card) -> NSAttributedString {
    
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
      case .circle: shape = "??????"
      case .triangle: shape = "???"
      case .square: shape = "??????"
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
    
    let _ = game.dealCards(count: 12)
    updateViewFromModel()
    
  }


}

