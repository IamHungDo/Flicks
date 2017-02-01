//
//  DetailViewController.swift
//  TopMovies
//
//  Created by Hung Do on 1/31/17.
//  Copyright © 2017 Hung Do. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var overView: UILabel!
    @IBOutlet weak var titleView: UILabel!
    
    var movie: NSDictionary!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print(movie)
        
        let title = movie["title"] as! String
        titleView.text = title

        let overview = movie["overview"] as! String
        overView.text = overview
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    



}
