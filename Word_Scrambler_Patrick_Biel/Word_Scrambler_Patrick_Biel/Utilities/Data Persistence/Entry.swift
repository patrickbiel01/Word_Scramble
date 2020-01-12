import Foundation

/*----------------------------------------------------
 //////////////////////////////////
    Structure to represent an entry in the high scores
 //////////////////////////////////
 -----------------------------------------------------*/
struct Entry: Equatable {
    //Properties of a highscore: name and score
    let name: String
    let score: Int
    
    /* --------------------------
     Stores current instance of object in UserDefaults
    -------------------------- */
    func storeHighScore(){
        let userDefaults = UserDefaults.standard
       
        //Retrieve current stored scores
        guard var existingScores = userDefaults.object(forKey: Entries.SCORE_KEY) as? Array<Int> else {
            userDefaults.set([score], forKey: Entries.SCORE_KEY)
            userDefaults.set([name], forKey: Entries.NAME_KEY)
            return
        }
        
        var existingNames = userDefaults.object(forKey: Entries.NAME_KEY) as! Array<String>
        
        //Add new scores
        existingScores.append(score)
        existingNames.append(name)
        
        //Store score in User Defaults
        userDefaults.set(existingScores, forKey: Entries.SCORE_KEY)
        userDefaults.set(existingNames, forKey: Entries.NAME_KEY)
        userDefaults.synchronize()
    }
    
}
