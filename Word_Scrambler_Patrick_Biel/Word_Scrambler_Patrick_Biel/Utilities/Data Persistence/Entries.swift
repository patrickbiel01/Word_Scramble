import Foundation

/*----------------------------------------------------
 //////////////////////////////////
    Structure to represent all the highscores
 //////////////////////////////////
 -----------------------------------------------------*/
class Entries {
    //Holds all highscore entries
    var entries: [Entry]
    
    //Keys for UserDefaults
    public static let NAME_KEY = "namekey"
    public static let SCORE_KEY = "scorekey"
    
    /* --------------------------
     Retrieves a list of Entry from UserDefaults
     -------------------------- */
    init() {
        let userDefaults = UserDefaults.standard
        
        guard let highScoreNames = userDefaults.object(forKey: Entries.NAME_KEY) as? Array<String> else {
            entries = []
            return
        }
        guard let highScoreValues = userDefaults.object(forKey: Entries.SCORE_KEY) as? Array<Int> else {
            entries = []
            return
        }
        
        var entryData = [Entry]()
        for i in 0..<highScoreNames.count {
            entryData.append(Entry(name: highScoreNames[i], score: highScoreValues[i]))
        }
        
        entries = entryData
        
    }
    
    /* --------------------------
        Modifies current instance to be sorted according to score
     -------------------------- */
    func sort() -> Entries {
        entries = quickSort(entries).reversed()
        entries = getHighest(index: 10)
        return self
    }
    
    /* Quicksort is used to sort */
    private func quickSort(_ array: [Entry]) -> [Entry] {
        if (array.count <= 1) {
            return array;
        }
        
        let pivot = array[array.count-1]
        var left: [Entry] = []
        var right: [Entry] = []
        
        for i in 0..<array.count-1 {
            if (array[i].score < pivot.score) {
                left.append(array[i]);
            }else {
                right.append(array[i]);
            }
        }
        
        return quickSort(left) + [pivot] + quickSort(right)
    }
    
    /* --------------------------
    Function that gets 10 highest scores
    -------------------------- */
    private func getHighest(index highest: Int) -> [Entry] {
        if entries.count < 10 {
            return entries
        }
        
        let top = Array(entries[0..<highest])
        
        return top
        
    }
    
    /* --------------------------
     Returns length of entry array member
     -------------------------- */
    func count() -> Int {
        return entries.count
    }
    
    /* --------------------------
     Returns nth index of entry array member
     -------------------------- */
    func get(at index: Int) -> Entry {
        return entries[index]
    }
    
}
