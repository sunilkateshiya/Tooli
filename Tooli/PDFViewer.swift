//
//  PDFViewer.swift
//  Tooli
//
//  Created by Impero IT on 15/02/2017.
//  Copyright © 2017 Moin Shirazi. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PDFViewer: UIViewController,UIWebViewDelegate, NVActivityIndicatorViewable
{
    @IBOutlet weak var webView: UIWebView!
    var strUrl = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let Url:NSURL = NSURL(string: strUrl)!
        
        let URLRequest1:URLRequest = URLRequest(url: Url as URL)
        webView.loadRequest(URLRequest1)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        self.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        self.stopAnimating()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        self.stopAnimating()
    }
}
