//
//  AchievemntsViewController.swift
//  Stepr
//
//  Created by James Ormond on 9/17/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

class AchievemntsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var achievements : [Achievement] {
        return Achievement.getAllAchievements()
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("num of achievements: \(self.achievements.count)")
        return self.achievements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementTableViewCell") as! AchievementTableViewCell
        cell.achievement = self.achievements[indexPath.row]
        return cell
    }

}
