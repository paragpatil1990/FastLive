//
//  ContentView.swift
//  CareerAdvance
//
//  Created by Amrit Singh on 11/28/16.
//  Copyright © 2016 4Fox. All rights reserved.
//

import UIKit

class ContentWebView: UIView, UIWebViewDelegate
{
    var webView: UIWebView!
    var loder: UIActivityIndicatorView!
    
    //Popup Show Hide Direction
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        webView = UIWebView(frame: CGRect(x: 0, y: frame.size.height/2, width:frame.size.width, height: 0))
        webView.backgroundColor = .white
        webView.delegate = self
        webView.scrollView.isScrollEnabled = true
        webView.isUserInteractionEnabled = true
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        addSubview(webView)
        
        loder = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loder.center = self.center
        addSubview(loder)
        loder.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        if navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.openURL(request.url!)
            return false
        }
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIView.animate(withDuration: 0.5) {
            self.loder.removeFromSuperview()
            self.loder.stopAnimating()

        };
    }
    
    //MARK: - Show Popup
    func show(view: UIView,strMessage: String, complete : @escaping () -> Void )
    {
        view.addSubview(self)
        webView.loadHTMLString(strMessage, baseURL: nil)
        UIView.animate(withDuration: 0.5, animations:{
            //Do all animations here
            self.webView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        }, completion: {
            //Code to run after animating
            (value: Bool) in
            complete()
        })
    }
}
