import Foundation
import UIKit

/*----------------------------------------------------
 //////////////////////////////////
    Class that controls all the logic for the Word Scramble Game
 //////////////////////////////////
 -----------------------------------------------------*/
class GameController {
    //Hold parent ViewController
    static var viewController = WordViewController()
    
    //Instnace that controls logic for UI
    var gameUIController = GameUIController()
    
    //Game metrics
    var score = 0
    var scoreAdded = 10
    var hintClicked = false
    
    //Word-generation related properties
    var database = WordDatabase()
    var word = RandomWord()
    var wordChar = [String: [Character]]()
    
    
    /* --------------------------
     Blank Constructor
     -------------------------- */
    init() {
        
    }
    
    /* --------------------------
     Import elements from parent ViewController
     -------------------------- */
    init(scrambled: [UIButton], word: [UIImageView], labels: [UILabel], functionalBtn: [UIButton], vectors: [UIImageView]) {
        GameUIController.vectors = vectors
        gameUIController = GameUIController(scrambled: scrambled, word: word, labels: labels, functionalBtn: functionalBtn, parent: GameController.viewController)
    }
    
    /* --------------------------
     Function called at setup
     -------------------------- */
    func setup() {
        score = 0
        generateNewWord()
        gameUIController.updateLabels(score: score, word: word)
    }
    
    /* --------------------------
     Function called when submit button is clicked
     -------------------------- */
    func onSubmitClick() {
        
        let input = gameUIController.getInput()
        
        let correctWord = word.word.lowercased()
        
        if input == correctWord {
            //Give user feedback
            Toast().showAlert(backgroundColor: UIColor.white, textColor: UIColor.black, message: "Correct")
            score += scoreAdded
            //Update score labels
            gameUIController.resetTiles()
            generateNewWord()
        }else {
            score -= 3
            //Give user feedback
            Toast().showAlert(backgroundColor: UIColor.white, textColor: UIColor.black, message: "Incorrect")
            if score < 0 {
                end()
            }
        }
        
        gameUIController.updateLabels(score: score, word: word)
    }
    
    /* --------------------------
     Function called when hint button is clicked
     -------------------------- */
    func onHintClick() {
        if !hintClicked {
            scoreAdded -= 5
        }
        //Show alert hilding hint
        let alert = UIAlertController(title: "Hint:", message: word.hint, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        GameController.viewController.present(alert, animated: true, completion: nil)
        hintClicked = true
    }
    
    /* --------------------------
     Function called when crambled tile is clicked
     -------------------------- */
    func onScrambledClick(_ sender: UIButton) {
        let letterN = findLetter(sender)
        
        if let letter = letterN {
            gameUIController.updateWord(sender, letter: letter)
        }
        
    }
    
    /* --------------------------
     Function called when clear button is clicked
     -------------------------- */
    func onClearClick() {
        gameUIController.populateUI(with: wordChar)
    }
    
    /* --------------------------
     Function called when delete button is clicked
     -------------------------- */
    func onDeleteClick(_ sender: UIButton) {
        gameUIController.moveTilesBack(using: wordChar)
    }
    
    /* --------------------------
     Function called when skip button is clicked
     -------------------------- */
    func onSkipClick() {
        if score < 3 {
            Toast().showAlert(backgroundColor: UIColor.white, textColor: UIColor.black, message: "Need a Score Greater than 3")
            return
        }
        score -= 3
        generateNewWord()
        gameUIController.updateLabels(score: score, word: word)
    }
    
    /* --------------------------
     Function called at the end of the game
     -------------------------- */
    func end() {
        gameUIController.resetTiles()
        if score <= 0 {
            //Exit
            GameController.viewController.dismiss(animated: true, completion: nil)
            return
        }
        //Create alert
        let alert = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
        //Show alert
        alert.showEndAlert(GameController.viewController, score: score)
        //Reset score
        score = 0
    }
    
    /////////////////////////////////////////////////
    /*            Utility Functions             */
    ////////////////////////////////////////////////
    
    /* Function that makes new, random word and outputs it */
    private func generateNewWord(){
        word = RandomWord(from: database)
        //Retrive characters
        wordChar = word.toChar()
        gameUIController.populateUI(with: wordChar)
        scoreAdded = 10
        hintClicked = false
        printSolutions(question: word.scrambledWord, answer: word.word)
    }
    
    /* Function that returns associated Character from scrambled tile clicked */
    private func findLetter(_ sender: UIButton) -> Character? {
        let scrambledLetter = sender
        let image = scrambledLetter.image(for: .normal) ?? UIImage()
        
        return getLetter(from: image)
    }
    
    /* Function that returns associated Character from scrambled tile clicked */
    private func getLetter(from image: UIImage) -> Character? {
        var letter: Character?
        //Check all letters in alpabet and compare to button image
        let ALPHABET = "abcdefghijklmnopqrstuvwxyz"
        for char in ALPHABET {
            if image == UIImage(named: "button_\(char)_scrambled") {
                letter = char
            }
        }
        
        return letter
    }
    
     /* Function that prints the correct solutions for Baraam */
    func printSolutions(question: String, answer: String) {
        print("\n")
        print("------------------------------------------")
        print("Scrambled Combination: \(question.uppercased())")
        print("Answer: \(answer)")
        print("------------------------------------------")
    }
    
}
