import Foundation

/*----------------------------------------------------
 //////////////////////////////////
    Struct to hold all the properties related
        to a Word Scramble word
 //////////////////////////////////
 -----------------------------------------------------*/
struct Word {
    let word: String
    let hint: String
    let category: String
}


/*----------------------------------------------------
 //////////////////////////////////
    Struct to hold all the properties related
        to a Word Scramble word
 //////////////////////////////////
 -----------------------------------------------------*/
class WordDatabase {
    //Each categories are iterated through with a counter
    private var categoryCounter = 0
    //List of Categories
    private static let categories = ["Entertainment", "Colours", "Websites", "Programming Languages", "Science"]
    //List of all words
    private static var ENTERTAINMENT = ["It", "Jaws", "Psycho", "Titanic", "ET", "Rocky", "Arrow", "Flash", "Frasier", "Seinfeld"]
    private static var COLOURS = ["Blue", "Red", "Indigo", "Pink", "Green", "Magenta", "Aqua", "Olive", "Maroon", "Black"]
    private static var WEBSITES = ["Youtube", "Reddit", "Facebook", "MySpace", "Discord", "Lynda", "Netflix", "Google", "Github", "Twitter"]
    private static var LANGUAGES = ["Ruby", "Perl", "Kotlin", "Swift", "Java", "Bash", "Python", "Fortran", "Haskell", "Lisp"]
    private static var SCIENCE = ["Energy", "Work", "Vector", "Pulsar", "Neutron", "Proton", "Electron", "Enzyme", "Quark", "Nebula"]
    //List of all hints
    private static var movieHints = ["Horror movie featuring a clown", "A famous thriller with a shark", "Horror film directed by Alfred Hitchcock", "Sinking Ship Film", "An alien film directed by Steven Spielberg", "Boxing Film", "Protagonist is Oliver Queen", "Protagonist is Barry Allen", "Takes place in Seattle", "A sitcom starring a famous comedian"]
    private static var colourHints = ["R:0 G:0 B:255", "R:255 G:0 B:0", "Name of a bookstore chain", "A female hip-hop artist", "R:0, G:255, B:0", "R:255, G:0, B:255", "Another name for water", "A fruit", "The first word in the name of the band that performed in the Half-time show for Superbowl 53", "R:0, G:0, B:0"]
    private static var websiteHints = ["Creators on this site get demonitized", "Origin of r/woosh", "Owned by a lizard", "Dead social media website", "Voice-chat website", "Learning website", "_______ and chill", "Search Engine", "Website for open-source code", "Preferred social media of Donald Trump"]
    private static var langaugeHints = ["A precious jewel", "Homophone of jewel found in clams", "Android's swift", "Apple's language", "A cup of coffee", "Used in Mac Terminals", "Monty ______", "Created by IBM in 1957", "Functional Language", "Language used in Quantum Computers"]
    private static var scienceHints = ["Ability to do work", "Force applied to an object that displaces", "A value with magnitude and direction", "Highly magnetized rotating neutron star", "Subatomic particle that has no charge", "Subatomic particle that has a charge of +1", "Subatomic particle that has a charge of -1", "Naturally-occuring catalyst", "6 different flavours exist", "Giant cloud of dust and gas in space"]
    
    /* --------------------------
     Function that picks a random word
     -------------------------- */
    func chooseWord() -> Word {
        //Choose category
        let category = pickCategory()
        
        var word = ""
        var hint = ""
        
        //Picks a word from each category
        switch category {
        case WordDatabase.categories[0]:
            if WordDatabase.ENTERTAINMENT.isEmpty {
                reset()
            }
            let hintWord = chooseRandWord(from: &WordDatabase.ENTERTAINMENT, and: &WordDatabase.movieHints)
            hint = hintWord.hint
            word = hintWord.word
        case WordDatabase.categories[1]:
            if WordDatabase.COLOURS.isEmpty {
                reset()
            }
            let hintWord = chooseRandWord(from: &WordDatabase.COLOURS, and: &WordDatabase.colourHints)
            hint = hintWord.hint
            word = hintWord.word
        case WordDatabase.categories[2]:
            if WordDatabase.WEBSITES.isEmpty {
                reset()
            }
            let hintWord = chooseRandWord(from: &WordDatabase.WEBSITES, and: &WordDatabase.websiteHints)
            hint = hintWord.hint
            word = hintWord.word
        case WordDatabase.categories[3]:
            if WordDatabase.LANGUAGES.isEmpty {
                reset()
            }
            let hintWord = chooseRandWord(from: &WordDatabase.LANGUAGES, and: &WordDatabase.langaugeHints)
            hint = hintWord.hint
            word = hintWord.word
        case WordDatabase.categories[4]:
            if WordDatabase.SCIENCE.isEmpty {
                reset()
            }
            let hintWord = chooseRandWord(from: &WordDatabase.SCIENCE, and: &WordDatabase.scienceHints)
            hint = hintWord.hint
            word = hintWord.word
        default:
            print("")
        }
        
        return Word(word: word, hint: hint, category: category)
    }
    
    
    /* --------------------------
     A interior function that chooses a random word from a given category
        and removes used word
     -------------------------- */
    private func chooseRandWord(from words: inout [String], and hints: inout [String]) -> Word {
        
        guard words.count == hints.count else {
            return Word(word: "", hint: "", category: "")
        }
        
        let rand = RandomWord.rand(high: words.count)
        let word = words.remove(at: rand)
        let hint = hints.remove(at: rand)
        
        return Word(word: word, hint: hint, category: "")
    }
    
    
    /* --------------------------
     Function that goes through all categories and
        chooses a category
     -------------------------- */
    private func pickCategory() -> String{
        let category = WordDatabase.categories[categoryCounter]
        
        //Keep number modular between 0...categories.count
        if categoryCounter >= 4 {
            categoryCounter = 0
        }else {
            categoryCounter += 1
        }
        
        return category
    }
    
    
    /* --------------------------
        Function that repopulates database once
            there are no more words left
     -------------------------- */
    func reset() {
        //Reset counter
        categoryCounter = 0
        //Reset words
        WordDatabase.ENTERTAINMENT = ["It", "Jaws", "Psycho", "Titanic", "ET", "Rocky", "Arrow", "Flash", "Frasier", "Seinfeld"]
        WordDatabase.movieHints = ["Horror movie featuring a clown", "A famous thriller with a shark", "Horror film directed by Alfred Hitchcock", "Sinking Ship Film", "An alien film directed by Steven Spielberg", "Boxing Film", "Protagonist is Oliver Queen", "Protagonist is Barry Allen", "Takes place in Seattle", "A sitcom starring a famous comedian"]
        WordDatabase.COLOURS = ["Blue", "Red", "Indigo", "Pink", "Green", "Magenta", "Aqua", "Olive", "Maroon", "Black"]
        WordDatabase.colourHints = ["R:0 G:0 B:255", "R:255 G:0 B:0", "Name of a bookstore chain", "A female hip-hop artist", "R:0, G:255, B:0", "R:255, G:0, B:255", "Another name for water", "A fruit", "The first word in the name of the band that performed in the Half-time show for Superbowl 53", "R:0, G:0, B:0"]
        WordDatabase.WEBSITES = ["Youtube", "Reddit", "Facebook", "MySpace", "Discord", "Lynda", "Netflix", "Google", "Github", "Twitter"]
        WordDatabase.websiteHints = ["Creators on this site get demonitized", "Origin of r/woosh", "Owned by a lizard", "Dead social media website", "Voice-chat website", "Learning website", "_______ and chill", "Search Engine", "Website for open-source code", "Preferred social media of Donald Trump"]
        WordDatabase.LANGUAGES = ["Ruby", "Perl", "Kotlin", "Swift", "Java", "Bash", "Python", "Fortran", "Haskell", "Lisp"]
        WordDatabase.langaugeHints = ["A precious jewel", "Homophone of jewel found in clams", "Android's swift", "Apple's language", "A cup of coffee", "Used in Mac Terminals", "Monty ______", "Created by IBM in 1957", "Functional Language", "Language used in Quantum Computers"]
        WordDatabase.SCIENCE = ["Energy", "Work", "Vector", "Pulsar", "Neutron", "Protron", "Electron", "Enzyme", "Quark", "Nebula"]
        WordDatabase.scienceHints = ["Ability to do work", "Force applied to an object that displaces", "A value with magnitude and direction", "Highly magnetized rotating neutron star", "Subatomic particle that has no charge", "Subatomic particle that has a charge of +1", "Subatomic particle that has a charge of -1", "Naturally-occuring catalyst", "6 different flavours exist", "Giant cloud of dust and gas in space"]
    }
}
