//
//  HelpViewController.swift
//  WeatherApp
//
//  Created by Suraj Shandil on 7/29/21.
//

import UIKit
import WebKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    //MARK:- View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        self.loadHtmlContent()
    }
    
    //MARK:- Private Method Implementation -
    private func setupNavBar() {
        title = "Help"
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowtriangle.backward.fill"), style: .plain, target: self, action: #selector(goBack))
        leftBarButtonItem.tintColor = .white
        navigationItem.leftBarButtonItem  = leftBarButtonItem
        navigationController?.navigationBar.barTintColor = .systemGray2
    }
    
    private func loadHtmlContent() {
        if let url = Bundle.main.url(forResource: "Help", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
    }
    
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
