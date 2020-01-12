import Foundation
import GameplayKit

/* ----------------------------------------------------
    Class used to represent, new, randomly chosen Word Scramble Word
 ---------------------------------------------------- */
class RandomWord {
    //Stores: Original Word, Scrambled Variation of Original
        //The hint and the category
    let word: String
    let scrambledWord: String
    let hint: String
    let category: String
    
    /* --------------------------
     Blank Initializer
     -------------------------- */
    init() {
        word = ""
        scrambledWord = ""
        hint = ""
        category = ""
    }
    
    /* --------------------------
     Creates new instance based off given Word Databse
     -------------------------- */
    init(from database: WordDatabase) {
        //Choose random word
        let wordProp = database.chooseWord()
        //Trasfer data to instance
        word = wordProp.word
        hint = wordProp.hint
        category = wordProp.category
        //Scramble word
        scrambledWord = RandomWord.scramble(word)
    }
    
    /* --------------------------
     Returns the inputted string in a new, random order
     -------------------------- */
    private static func scramble(_ word: String) -> String {
        let characters = Array(word)
        let mersenneTwister = GKMersenneTwisterRandomSource()
        let shuffled = mersenneTwister.arrayByShufflingObjects(in: characters) as! [Character]
        
        return String(shuffled)
    }
    
    /* --------------------------
     Returns a random integers between 2 numbers
     -------------------------- */
    static func rand(high: Int) -> Int {
        let mersenneTwister = GKMersenneTwisterRandomSource()
        return mersenneTwister.nextInt(upperBound: high)
    }
    
    /* --------------------------
     Returns char[] versions of Word
     -------------------------- */
    func toChar() -> [String: [Character]] {
        let wordChar = Array(word)
        let scrambledChar = Array(scrambledWord)
        
        return ["word": wordChar, "scrambled": scrambledChar]
    }
    
}
