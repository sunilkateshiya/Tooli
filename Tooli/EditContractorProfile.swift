//
//  EditContractorProfile.swift
//  Tooli
//
//  Created by Impero IT on 19/08/17.
//  Copyright © 2017 impero. All rights reserved.
//

import UIKit

class EditContractorProfile: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBack(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnEdit1Action(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC1") as! SignUpVC1
        vc.edit = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnEdit2Action(_ sender: UIButton)
    {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC2") as! SignupVC2
        vc.edit = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnEdit3Action(_ sender: UIButton)
    {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "Experience1") as! Experience1
        vc.edit = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnEdit4Action(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RateTravalVC") as! RateTravalVC
        vc.edit = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnEdit5Action(_ sender: UIButton)
    {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "CertificateVC") as! CertificateVC
        vc.edit = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnEdit6Action(_ sender: UIButton)
    {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "ChangePassword") as! ChangePassword
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
