import Foundation
import UIKit

/*----------------------------------------------------
 //////////////////////////////////
    Class that contains Game Animations 
 //////////////////////////////////
 -----------------------------------------------------*/
class Animation {
    /* --------------------------
     Animates a scrambled tiles to move back the original position
     -------------------------- */
    static func delete(from wordTile: UIImageView, to destination: UIButton, with pic: UIImage, using vector: UIImageView) {
        
        //Retrieve position of destination
        let destinationP = destination.frame.origin

        //Retrieve position of pile
        let tileP = wordTile.frame.origin

        //Use ImageView as vector
        vector.frame.origin = tileP
        vector.image = pic
        
        //Hide button
        destination.setImage(pic, for: .normal)
        destination.isHidden = true

        //Animate card to destination
        UIView.animate(withDuration: 0.45, animations: {
            //Set position for transformation
            let moveTransform = CGAffineTransform(translationX: destinationP.x - tileP.x, y: destinationP.y - tileP.y)
            let scaleTransform = CGAffineTransform(scaleX: (destination.frame.width/wordTile.frame.width), y: (destination.frame.height/wordTile.frame.height))
            let comboTransform = moveTransform.concatenating(scaleTransform)
            vector.transform = comboTransform
        }){ (_) in
            /* After animation is done */
            wordTile.image = UIImage()
            destination.isEnabled = true
            destination.isHidden = false
            //Set destination image to image parameter
             destination.setImage(pic, for: .normal)
            //Restore vector's previous state
            vector.transform = CGAffineTransform.identity
            vector.image = UIImage()
        }
        
    }
}
