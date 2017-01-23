//
//  ViewController.swift
//  Tooli
//
//  Created by Moin Shirazi on 02/01/17.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit

class Experience: UIViewController,UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tvBlogList: UITableView!
    var i : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         i = 1
        tvBlogList.delegate = self
        tvBlogList.dataSource = self
        tvBlogList.rowHeight = UITableViewAutomaticDimension
        tvBlogList.estimatedRowHeight = 450
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(i)
        return i
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    @IBAction func btnAddExp(_ sender: Any) {
        
        i = i + 1
        tvBlogList.reloadData()
    }
    

}

