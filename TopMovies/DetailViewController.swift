//
//  DetailViewController.swift
//  Flicks
//
//  Created by Hung Do on 1/31/17.
//  Copyright © 2017 Hung Do. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var overView: UILabel!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    
    var movie: NSDictionary!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as! String
        titleView.text = title

        let overview = movie["overview"] as! String
        overView.numberOfLines = 0
        overView.text = overview

        overView.sizeToFit()
        
        let baseURL = "https://image.tmdb.org/t/p/w500/"
        if let posterPath = movie["poster_path"] as? String {
            let imageURL = (string:baseURL + posterPath)
            let imageRequest = NSURLRequest(url: NSURL(string:imageURL)! as URL)
            posterView.setImageWith(
                imageRequest as URLRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        self.posterView.alpha = 0.0
                        self.posterView.image = image
                        UIView.animate(withDuration: 1.5, animations: { () -> Void in
                            self.posterView.alpha = 1.0
                        })
                    } else {
                        print("Image was cached so just update the image")
                        self.posterView.image = image
                    }
            },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    



}
