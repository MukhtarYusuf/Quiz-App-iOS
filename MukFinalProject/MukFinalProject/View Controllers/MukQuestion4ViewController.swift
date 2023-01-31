//
//  MukQuestion4ViewController.swift
//  MukFinalProject
//
//  Created by Mukhtar Yusuf on 11/23/20.
//  Copyright © 2020 Mukhtar Yusuf. All rights reserved.
//

import UIKit

class MukQuestion4ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Outlets
    @IBOutlet weak var mukTimeLeftLabel: UILabel!
    @IBOutlet weak var mukQuestionHeaderLabel: UILabel!
    @IBOutlet weak var mukQuestionTextLabel: UILabel!
    @IBOutlet weak var mukOptionsTableView: UITableView!
    
    // MARK: Constants
    let mukQuestionIndex = 3
    
    // MARK: Variables
    var mukTest: MukTest?
    var mukQuestion: MukQuestion?
    
    // MARK: Computed Properties
    var mukFormattedTimeLeft: String {
        let mukTimeLeft = mukTest?.mukTimeLeft ?? 0
        let mukHours = mukTimeLeft/3600
        let mukMins = (mukTimeLeft % 3600) / 60
        let mukSeconds = (mukTimeLeft % 3600) % 60
        
        let mukHoursString = mukHours > 0 ? "\(mukHours)h " : ""
        let mukMinsString = (mukHours != 0 || mukMins != 0) ? "\(mukMins)m " : ""
        let mukSecString = mukSeconds > 0 ? "\(mukSeconds)s" : "0s"
        
        return "\(mukHoursString)\(mukMinsString)\(mukSecString)"
    }
    
    // MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mukQuestion?.mukOptions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mukCell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
        let mukQuestionOption = mukQuestion?.mukOptions[indexPath.row] ?? ""
        
        mukCell.textLabel?.text = mukQuestionOption
        mukCell.accessoryType = indexPath.row != mukQuestion?.mukChosenIndex ? .none : .checkmark
        
        return mukCell
    }
    
    // MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mukQuestion?.mukSelectOption(index: indexPath.row)
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Action Methods
    @IBAction func mukGoBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Utilities
    func setupUI() {
        mukQuestionHeaderLabel.text = "Question \(mukQuestionIndex+1) of \(mukTest?.mukQuestions.count ?? 0)"
        mukQuestionTextLabel.text = mukQuestion?.mukText

        mukOptionsTableView.dataSource = self
        mukOptionsTableView.delegate = self
        
        updateUI()
    }
    
    func updateUI() {
        mukUpdateTimeLabel()
    }
    
    @objc func mukUpdateTimeLabel() {
        mukTimeLeftLabel.text = "Time Left: \(mukFormattedTimeLeft)"
        
        guard let mukTest = mukTest else { return }
        if mukTest.mukTimeLeft == 0 && mukTest.mukShouldEnd {
            if let mukResultsVC = storyboard?.instantiateViewController(identifier: "ResultViewController") as? MukResultViewController {
                if let _ = navigationController?.topViewController as? MukResultViewController {
                    // Do Nothing
                } else {
                    mukResultsVC.mukTest = mukTest
                    navigationController?.pushViewController(mukResultsVC, animated: true)
                }
            }
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NextQuestion5" {
            if let mukQuestion5VC = segue.destination as? MukQuestion5ViewController {
                mukQuestion5VC.mukTest = mukTest
            }
        }
    }
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        mukQuestion = mukTest?.mukQuestions[mukQuestionIndex]
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(mukUpdateTimeLabel),
                                               name: Notification.Name(rawValue: "TimeUpdated"),
                                               object: nil)
            
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
