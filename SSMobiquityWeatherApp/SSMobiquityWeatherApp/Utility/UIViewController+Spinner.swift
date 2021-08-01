//
//  UIViewController+Spinner.swift
//  WeatherApp
//
//  Created by Suraj Shandil on 7/29/21.
//

import UIKit
var vSpinner : UIView?
extension UIViewController {
    func showSpinner(onView : UIView) {
        DispatchQueue.main.async {
            let spinnerView = UIView.init(frame: onView.bounds)
            spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            let ai = UIActivityIndicatorView.init(style: .large)
            ai.startAnimating()
            ai.center = spinnerView.center
            
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
            vSpinner = spinnerView
        }
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
