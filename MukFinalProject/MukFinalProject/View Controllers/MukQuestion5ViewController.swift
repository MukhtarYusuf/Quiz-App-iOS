//
//  MukQuestion5ViewController.swift
//  MukFinalProject
//
//  Created by Mukhtar Yusuf on 11/23/20.
//  Copyright © 2020 Mukhtar Yusuf. All rights reserved.
//

import UIKit

class MukQuestion5ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: Outlets
    @IBOutlet weak var mukTimeLeftLabel: UILabel!
    @IBOutlet weak var mukQuestionHeaderLabel: UILabel!
    @IBOutlet weak var mukQuestionTextLabel: UILabel!
    @IBOutlet weak var mukOptionsCollectionView: UICollectionView!
    
    // MARK: Constants
    let mukQuestionIndex = 4
    
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
    
    // MARK: UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mukQuestion?.mukOptions.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mukCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionCell", for: indexPath)
        let mukImageName = mukQuestion?.mukOptions[indexPath.item] ?? ""
        
        if let mukImageView = mukCell.viewWithTag(1000) as? UIImageView {
            mukImageView.image = UIImage(named: mukImageName)
        }
        
        mukCell.isSelected = mukQuestion?.mukChosenIndex == indexPath.item
        if mukCell.isSelected {
            mukCell.layer.borderWidth = 1.0
            mukCell.layer.borderColor = CGColor(srgbRed: 0.0, green: 0.26, blue: 0.43, alpha: 1.0)
        } else {
            mukCell.layer.borderWidth = 0.0
        }
        
        return mukCell
    }
    
    // MARK: UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mukQuestion?.mukSelectOption(index: indexPath.item)
        collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let mukHorizontalInsets = collectionView.contentInset.left + collectionView.contentInset.right
        let mukVerticalInsets = collectionView.contentInset.top + collectionView.contentInset.bottom
        
        let mukWidth = (collectionView.frame.width - mukHorizontalInsets - 10) / 2
        let mukHeight = (collectionView.frame.height - mukVerticalInsets - 10) / 2
//        let mukLessDimension = mukWidth < mukHeight ? mukWidth : mukHeight
        
        return CGSize(width: mukWidth, height: mukHeight)
    }
    
    // MARK: Action Methods
    @IBAction func mukGoBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Utilities
    func setupUI() {
        mukQuestionHeaderLabel.text = "Question \(mukQuestionIndex+1) of \(mukTest?.mukQuestions.count ?? 0)"
        mukQuestionTextLabel.text = mukQuestion?.mukText

        mukOptionsCollectionView.dataSource = self
        mukOptionsCollectionView.delegate = self
        
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
        if segue.identifier == "GoToResult" {
            if let mukResultVC = segue.destination as? MukResultViewController {
                mukResultVC.mukTest = mukTest
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("View did disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("View did disappear")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("View did layout subviews")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
