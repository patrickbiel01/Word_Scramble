import UIKit

/*----------------------------------------------------
 //////////////////////////////////
    Class to control view on Game Screen
 //////////////////////////////////
 -----------------------------------------------------*/
class WordViewController: UIViewController {
    
    //Buttons
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var hintBtn: UIButton!
    @IBOutlet weak var giveUpBtn: UIButton!
    //Tiles that hold user's word
    @IBOutlet weak var word1: UIImageView!
    @IBOutlet weak var word2: UIImageView!
    @IBOutlet weak var word3: UIImageView!
    @IBOutlet weak var word4: UIImageView!
    @IBOutlet weak var word5: UIImageView!
    @IBOutlet weak var word6: UIImageView!
    @IBOutlet weak var word7: UIImageView!
    @IBOutlet weak var word8: UIImageView!
    //Tiles that hold scrambled word
    @IBOutlet weak var scrambled1: UIButton!
    @IBOutlet weak var scrambled2: UIButton!
    @IBOutlet weak var scrambled3: UIButton!
    @IBOutlet weak var scrambled4: UIButton!
    @IBOutlet weak var scrambled5: UIButton!
    @IBOutlet weak var scrambled6: UIButton!
    @IBOutlet weak var scrambled7: UIButton!
    @IBOutlet weak var scrambled8: UIButton!
    //Labels
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    //Vectors for animations
    @IBOutlet var animationVectors: [UIImageView]!
    
    //Contains logic for ViewControllers
    var game = GameController()
    
    
    /* --------------------------
     Function called when view first appears: Setup Code
     -------------------------- */
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup Game elements
        let wordTiles: [UIImageView] = [word1, word2, word3, word4, word5, word6, word7, word8]
        let scrambledTiles: [UIButton] = [scrambled1, scrambled2, scrambled3, scrambled4, scrambled5, scrambled6, scrambled7, scrambled8]
        for button in scrambledTiles {
            //Assign drag and drop functionality to all buttons
            button.addTarget(self,
                             action: #selector(drag(control:event:)),
                             for: UIControlEvents.touchDragInside)
            button.addTarget(self,
                             action: #selector(drag(control:event:)),
                             for: [UIControlEvents.touchDragExit,
                                   UIControlEvents.touchDragOutside])
            //Give top priority in Z position
            button.layer.zPosition = 1000
        }
        
        //Setup game
        game = GameController(scrambled: scrambledTiles, word: wordTiles, labels: [categoryLabel, scoreLabel], functionalBtn: [submitBtn, hintBtn, giveUpBtn], vectors: animationVectors)
        GameController.viewController = self
        game.setup()
    }
    
    /* --------------------------
     Function thats called when a random scrambled tile is clicked
     -------------------------- */
    @IBAction func scrambleClick(_ sender: UIButton) {
        var pos = sender.center
        sender.center = CGPoint(x: pos.x + 1, y: pos.y + 1)
        game.onScrambledClick(sender)
        pos = sender.center
        sender.center = pos
    }
    
    /* --------------------------
     Function thats called when "Submit" button is clicked
     -------------------------- */
    @IBAction func submitClick(_ sender: Any) {
        game.onSubmitClick()
    }
    
    /* --------------------------
     Function thats called when "Hint" button is clicked
     -------------------------- */
    @IBAction func hintClick(_ sender: Any) {
        game.onHintClick()
    }
    
    /* --------------------------
     Function thats called when "Clear" button is clicked
     -------------------------- */
    @IBAction func clearClick(_ sender: Any) {
        game.onClearClick()
    }
    
    /* --------------------------
     Function thats called when "Delete" button is clicked
     -------------------------- */
    @IBAction func deleteClick(_ sender: Any) {
        game.onDeleteClick(sender as! UIButton)
    }
    
    /* --------------------------
     Function thats called when "Skip" button is clicked
     -------------------------- */
    @IBAction func skipWord(_ sender: UIButton) {
        game.onSkipClick()
    }
    
    /* --------------------------
     Function thats called when "Give Up" button is clicked
     -------------------------- */
    @IBAction func endClick(_ sender: Any) {
        game.end()
    }
    
    /* Function that updates button position on drag */
    @objc func drag(control: UIControl, event: UIEvent) {
        let scrambledTiles: [UIButton] = [scrambled1, scrambled2, scrambled3, scrambled4, scrambled5, scrambled6, scrambled7, scrambled8]
        //Retrieve touch location
        if let center = event.allTouches?.first?.location(in: self.view) {
            //Used for center-touch, move to first bug
            for tile in scrambledTiles {
                if center == tile.center {
                    control.center = CGPoint(x: center.x + 1, y: center.y + 1)
                    return
                }
            }
            //Update button to touch pos
            control.center = center
        }
    }
    
    /* Function that removes soft keyboard after use */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
