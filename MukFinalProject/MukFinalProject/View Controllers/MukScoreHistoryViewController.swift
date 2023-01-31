//
//  MukScoreHistoryViewControllerTableViewController.swift
//  MukFinalProject
//
//  Created by Mukhtar Yusuf on 11/24/20.
//  Copyright © 2020 Mukhtar Yusuf. All rights reserved.
//

import UIKit

class MukScoreHistoryViewController: UITableViewController {

    // MARK: Constants
    let mukTestHistory = MukTestHistory()
    
    // MARK: TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mukTestHistory.mukTests.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mukCell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
        let mukTest = mukTestHistory.mukTests[indexPath.row]
        
        let mukNumberLabel = mukCell.viewWithTag(1000) as? UILabel
        let mukScoreLabel = mukCell.viewWithTag(1001) as? UILabel
        let mukDateLabel = mukCell.viewWithTag(1002) as? UILabel
        
        mukNumberLabel?.text = "\(indexPath.row + 1)."
        mukScoreLabel?.text = mukTest.mukScoreString
        
        let mukDateFormatter = DateFormatter()
        mukDateFormatter.dateStyle = .medium
        mukDateFormatter.timeStyle = .none
        mukDateFormatter.locale = Locale(identifier: "en_US")
        
        mukDateLabel?.text = "On: \(mukDateFormatter.string(from: mukTest.mukDate))"

        return mukCell
    }

    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
