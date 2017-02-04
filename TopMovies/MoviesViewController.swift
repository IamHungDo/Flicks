//
//  MoviesController.swift
//  TopMovies
//
//  Created by Hung Do on 1/23/17.
//  Copyright © 2017 Hung Do. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var movies: [NSDictionary]!
    var filteredData: [NSDictionary]!
    var endpoint: String = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        //Network Request
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        
    MBProgressHUD.showAdded(to: self.view, animated: true)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    
                    self.movies = (dataDictionary["results"] as! [NSDictionary])
                    self.filteredData = self.movies
                    self.tableView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                }
            }
            
        }
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? movies : movies?.filter({(movie: NSDictionary) -> Bool in
            return (movie["title"] as! String).range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movies != nil {
            return filteredData.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = filteredData[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        
        let baseURL = "https://image.tmdb.org/t/p/w500/"
        if let posterPath = movie["poster_path"] as? String {
        let imageURL = (string:baseURL + posterPath)
        let imageRequest = NSURLRequest(url: NSURL(string:imageURL)! as URL)
        cell.posterView.setImageWith(
            imageRequest as URLRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = image
                    UIView.animate(withDuration: 1.5, animations: { () -> Void in
                        cell.posterView.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    cell.posterView.image = image
                }
        },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })
        print("Row \(indexPath.row)")
        }
        return cell
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {

            tableView.reloadData()

            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destination as!DetailViewController
        detailViewController.movie = movie
    }

    
    }



