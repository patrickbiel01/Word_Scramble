import UIKit

/*----------------------------------------------------
 //////////////////////////////////
    Class to control view on Leaderboard Screen
 //////////////////////////////////
 -----------------------------------------------------*/
class LeaderboardViewController: UIViewController, UITableViewDataSource {
    //Tableview object
    @IBOutlet weak var tableView: UITableView!
    
    //Store leaderboard data
    let entries = Entries().sort()
    
    /* Function that runs when view is about to appear */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /* Function called when Table View is loaded */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Create n cells
        return entries.count()
    }
    
    /* Function that customizes each TableViewCell */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Create new cell
        let myCell = UITableViewCell()
        
        /* Set styles for tableview */
        //Background
        tableView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35)
        myCell.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        //Text colour
        myCell.textLabel!.textColor = .white
        
        //Retrieve entry
        let entry = entries.get(at: indexPath.row)
        //Set text
        myCell.textLabel?.text = "\(indexPath.row + 1). \t\t \(entry.name): \(entry.score)"
        
        //Apply cell
        return myCell
    }
    
    /* Function called when "back" button is clicked */
    @IBAction func backButton(_ sender: UIButton) {
        //Exit
        dismiss(animated: true, completion: nil)
    }
    
}
