import Foundation
import UIKit

/*----------------------------------------------------
 //////////////////////////////////
    Class that controls all the logic for the UI control
        in the Word Scramble Game
 //////////////////////////////////
 -----------------------------------------------------*/
class GameUIController {
    //Parent ViewController
    let parent: UIViewController
    //Viewcontroller elements
    let scrambledTiles: [UIButton]
    let wordTiles: [UIImageView]
    //Labels
    let categoryLabel: UILabel
    let scoreLabel: UILabel
    //Btns
    let submitBtn: UIButton
    let hintBtn: UIButton
    let giveUpBtn: UIButton
    //Vectors for animations
    static var vectors = [UIImageView]()
    
    //Array stores order tiles stored
    /*
     orderStored:
     - Tuple that stores: (Character Chosen : Pos in Word Tiles)
     */
    var orderStored: [(Character, Int)] = []
    //Arrays that store original positions
    var originalScrambledPos = [CGPoint]()
    var originalWordTilePos = [CGPoint]()
    
    /* --------------------------
     Blank Constructor
     -------------------------- */
    init() {
        scrambledTiles = []
        wordTiles = []
        categoryLabel = UILabel()
        scoreLabel = UILabel()
        submitBtn = UIButton()
        hintBtn = UIButton()
        giveUpBtn = UIButton()
        parent = UIViewController()
    }
    
    /* --------------------------
     Import elements from parent ViewController
     -------------------------- */
    init(scrambled: [UIButton], word: [UIImageView], labels: [UILabel], functionalBtn: [UIButton], parent: UIViewController) {
        scrambledTiles = scrambled
        wordTiles = word
        for tile in wordTiles {
            originalWordTilePos.append(tile.frame.origin)
        }
        categoryLabel = labels[0]
        scoreLabel = labels[1]
        submitBtn = functionalBtn[0]
        hintBtn = functionalBtn[1]
        giveUpBtn = functionalBtn[2]
        //Populate original positions
        for tile in scrambledTiles {
            originalScrambledPos.append(tile.center)
        }
        self.parent = parent
    }
    
    /* --------------------------
     Function that sets tiles using the generated word
     -------------------------- */
    func populateUI(with wordChar: [String: [Character]]){
        let TRANSLUCENT_WHITE = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
        
        resetTiles()
        
        //Show blank tiles for characters
        var j = 0
        for _ in wordChar["word"]! {
            wordTiles[j].isHidden = false
            
            wordTiles[j].backgroundColor = TRANSLUCENT_WHITE
            j += 1
        }
        
        centerWordTiles()
        
        //Populate random tiles
        var i = 0
        for scrambledChar in wordChar["scrambled"]! {
            scrambledTiles[i].setImage(UIImage(named: "button_" + String(scrambledChar).lowercased() + "_scrambled"), for: .normal)
            scrambledTiles[i].isEnabled = true
            i += 1
        }
        
    }
    
    /* --------------------------
     Function that clears all tiles to a blank image
     -------------------------- */
    func resetTiles() {
        //Hides everything
        for index in 0..<wordTiles.count {
            wordTiles[index].image = UIImage()
            wordTiles[index].isHidden = true
            wordTiles[index].frame.origin = originalWordTilePos[index]
        }
        for scrambledBtn in scrambledTiles {
            scrambledBtn.setImage(UIImage(), for: .normal)
            scrambledBtn.isEnabled = false
        }
        orderStored = []
    }
    
    /* --------------------------
     Function that updates labels for User Game Information
     -------------------------- */
    func updateLabels(score: Int, word: RandomWord) {
        categoryLabel.text = "Category: \(word.category)"
        scoreLabel.text = "Score: \(score)"
    }
    
    /* --------------------------
     Function that is called on deleteClick, it moves tiles in answer back to original position
     -------------------------- */
    func moveTilesBack(using wordChar: [String: [Character]]) {
        if orderStored.isEmpty {
            return
        }
        
        //Remove last letter added
        let last = orderStored.removeLast()
        let lastLetter = last.0
        let lastIndex = last.1
        wordTiles[lastIndex].image = UIImage()

        //Put letter back into random tiles
        var sIndex = 0
        tileLoop: for i in 0..<scrambledTiles.count {
            var isEmpty = true
            let ALPHABET = "abcdefghijklmnopqrstuvwxyz"
            for char in ALPHABET {
                if scrambledTiles[i].image(for: .normal) == UIImage(named: "button_\(char)_scrambled") {
                    isEmpty = false
                    break
                }
            }
            
            if isEmpty {
                sIndex = i
                break tileLoop
            }
        }
        
        let image = UIImage(named: "button_\(lastLetter)_scrambled") ?? UIImage()
        Animation.delete(from: wordTiles[lastIndex], to: scrambledTiles[sIndex], with: image, using: GameUIController.vectors[sIndex])
    }
    
    /* --------------------------
     Function that adds a scrambled tile to the answer
     -------------------------- */
    func updateWord(_ sender: UIButton, letter: Character) {
        //Create list with all letters submitted
        var filledIndexes = [Int]()
        for i in 0..<orderStored.count {
            filledIndexes.append(orderStored[i].1)
        }
        
        var isOverWord = false
        //Add letter to answer if random tile is positioned over answer tile
        var counter = 0
        for tile in wordTiles {
            if tile.isHidden {
               counter += 1
               continue
            }
            if isOccupied(tile) {
                counter += 1
                continue
            }
            
            if sender.frame.contains(tile.center) {
                sender.setImage(UIImage(), for: .normal)
                sender.isEnabled = false
                orderStored.append((letter, counter))
                filledIndexes.append(counter)
                for index in 0..<wordTiles.count {
                    //Is empty
                    if !filledIndexes.contains(index) {
                        wordTiles[index].image = UIImage()
                        continue
                    }
                    //Get character from orderStored
                    var character: Character = "0"
                    for f in 0..<filledIndexes.count {
                        if index == filledIndexes[f] {
                            character = orderStored[f].0
                        }
                    }
                    let image = UIImage(named: "button_\(character)") ?? UIImage()
                    wordTiles[index].image = image
                }
                isOverWord = true
                break
            }
            counter += 1
        }
        
        //End of hover is not positioned over any tile
        //Reset tile to original position
        if !isOverWord {
            var pos = 0
            for i in 0..<scrambledTiles.count {
                let matchingImage = scrambledTiles[i].image(for: .normal) == sender.image(for: .normal)
                let isOriginalLocation = scrambledTiles[i].center == originalScrambledPos[i]
                if matchingImage && !isOriginalLocation {
                    pos = i
                    break
                }
            }
            sender.center = originalScrambledPos[pos]
        }
    }
    
    /* --------------------------
     Function that retrieves a string from the answer tiles
     -------------------------- */
    func getInput() -> String {
        var input = ""
        
        //Iterate through tiles to get submitted letters
        for word in wordTiles {
            let image = word.image ?? UIImage()
            let ALPHABET = "abcdefghijklmnopqrstuvwxyz"
            for char in ALPHABET {
                if image == UIImage(named: "button_\(char)") {
                    input.append(char)
                }
            }
        }
        
        input = input.lowercased()
        
        return input
        
    }
    
    /* --------------------------
     Function that checks if a given WordTile contains a letter or not
     -------------------------- */
    func isOccupied(_ tile: UIImageView) -> Bool {
        var occupied = false
        
        let ALPHABET = "abcdefghijklmnopqrstuvwxyz"
        for char in ALPHABET {
            if tile.image == UIImage(named: "button_\(char)") {
                occupied = true
            }
        }
        
        return occupied
        
    }
    
    /* --------------------------
     Function that centers all visible Word Tiles
        to center of the screen
     -------------------------- */
    func centerWordTiles() {
        var visibleTiles = [UIImageView]()
        for tile in wordTiles {
            if !tile.isHidden {
                visibleTiles.append(tile)
            }
        }
        
        let SCREEN_WIDTH: CGFloat = 414
        
        //Divide into 2 components: left & right
        let middle: Int = visibleTiles.count / 2
        visibleTiles[middle].center = CGPoint(x: SCREEN_WIDTH / 2, y: visibleTiles[middle].center.y)
        let middlePos = visibleTiles[middle].center
        
        //Populate left side from middle to first
        var vIndex = middle
        for posFromMid in 0...middle {
            var newPosX: CGFloat = 0
            if visibleTiles.count % 2 == 0 {
                 newPosX = (middlePos.x - 0.75 + 25) - CGFloat(50 * posFromMid)
            }else {
                newPosX = middlePos.x - CGFloat(50 * posFromMid)
            }
            visibleTiles[vIndex].center = CGPoint(x: newPosX, y: visibleTiles[vIndex].center.y)
            vIndex -= 1
        }

        //Populate right from middle to end
        vIndex = middle
        for posFromMid in 0..<visibleTiles.count-middle {
            var newPosX: CGFloat = 0
            if visibleTiles.count % 2 == 0 {
                newPosX = (middlePos.x + 0.75 + 25) + CGFloat(50 * posFromMid)
            }else {
                newPosX = middlePos.x + CGFloat(50 * posFromMid)
            }
            visibleTiles[vIndex].center = CGPoint(x: newPosX, y: visibleTiles[vIndex].center.y)
            vIndex += 1
        }

    }
    
}
