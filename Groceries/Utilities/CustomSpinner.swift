//
//  CustomSpinner.swift
//  Groceries
//
//  Created by Roger Yong on 19/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

class CustomSpinner: NSObject {
    var blurView: UIView!
    var indicator: UIActivityIndicatorView!
    var centerBoxView: UIView!
    var messageLabel: UILabel!
    
    func runSpinnerWithIndicator(view: UIView)  {
        blurView = UIView()
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.backgroundColor = UIColor.colorFromHexRGB(Color.SlateGray)
        blurView.alpha = 0.50
        view.addSubview(blurView)
        
        blurView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        blurView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        blurView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        blurView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        
        centerBoxView = UIView()
        centerBoxView.translatesAutoresizingMaskIntoConstraints = false
        centerBoxView.backgroundColor = UIColor.colorFromHexRGB(Color.LightGray)
        centerBoxView.layer.borderColor = UIColor.colorFromHexRGB(Color.LightGray).CGColor
        centerBoxView.layer.borderWidth = 1.0
        centerBoxView.layer.cornerRadius = 5.0
        view.addSubview(centerBoxView)
        
        centerBoxView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        centerBoxView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        centerBoxView.widthAnchor.constraintEqualToConstant(80).active = true
        centerBoxView.heightAnchor.constraintEqualToConstant(80).active = true
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = UIColor.colorFromHexRGB(Color.SlateGray)
        centerBoxView.addSubview(indicator)
        
        indicator.centerXAnchor.constraintEqualToAnchor(centerBoxView.centerXAnchor).active = true
        indicator.centerYAnchor.constraintEqualToAnchor(centerBoxView.centerYAnchor).active = true
        indicator.widthAnchor.constraintEqualToConstant(indicator.frame.width).active = true
        indicator.heightAnchor.constraintEqualToConstant(indicator.frame.height).active = true
    }
    func runSpinnerWithMessage(view: UIView, message: String)  {
        blurView = UIView()
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.backgroundColor = UIColor.colorFromHexRGB(Color.SlateGray)
        blurView.alpha = 0.50
        view.addSubview(blurView)
        
        blurView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        blurView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        blurView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        blurView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        
        centerBoxView = UIView()
        centerBoxView.translatesAutoresizingMaskIntoConstraints = false
        centerBoxView.backgroundColor = UIColor.colorFromHexRGB(Color.LightGray)
        centerBoxView.layer.borderColor = UIColor.colorFromHexRGB(Color.LightGray).CGColor
        centerBoxView.layer.borderWidth = 1.0
        centerBoxView.layer.cornerRadius = 5.0
        view.addSubview(centerBoxView)
        
        centerBoxView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        centerBoxView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        centerBoxView.widthAnchor.constraintEqualToConstant(200).active = true
        centerBoxView.heightAnchor.constraintEqualToConstant(50).active = true
        
        messageLabel = UILabel()
        messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = message
        messageLabel.font = UIFont(name: FontNameCalibri.Bold, size: FontSize.Large)
        messageLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        messageLabel.textAlignment = .Left
        messageLabel.numberOfLines = 1
        messageLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(messageLabel)
        
        messageLabel.centerXAnchor.constraintEqualToAnchor(centerBoxView.centerXAnchor).active = true
        messageLabel.centerYAnchor.constraintEqualToAnchor(centerBoxView.centerYAnchor).active = true
    }
    func start() {
        indicator.startAnimating()
    }
    func stop() {
        indicator.stopAnimating()
        CFRunLoopStop(CFRunLoopGetCurrent())
        blurView.removeFromSuperview()
        centerBoxView.removeFromSuperview()
        indicator.removeFromSuperview()
    }
    func dismiss() {
        blurView.removeFromSuperview()
        centerBoxView.removeFromSuperview()
        messageLabel.removeFromSuperview()
    }
}
