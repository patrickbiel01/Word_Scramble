import Foundation
import UIKit

/*----------------------------------------------------
 //////////////////////////////////
    Additional functionality to UIAlertController
 //////////////////////////////////
 -----------------------------------------------------*/
extension UIAlertController {
    /* --------------------------
     Creates and presents alert with textfield
     -------------------------- */
    func showEndAlert(_ viewController: WordViewController, score: Int) {
        //Add textfield
        self.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter your Name"
        })
        
        //Action when 'ok' button is clicked
        self.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if let name = self.textFields?.first?.text {
                var entryName = "Anon"
                if name != "" {
                    entryName = name
                }
                //Store score and names
                let entry = Entry(name: entryName, score: score)
                entry.storeHighScore()
                //Exit from viewcontroller (Back to home screen)
                viewController.dismiss(animated: true)
            }
        }))
        
        //Present
        viewController.present(self, animated: true)
    }
}
