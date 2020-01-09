//
//  ViewController.swift
//  Listen
//
//  Created by Atul Prakash on 26/12/19.
//  Copyright © 2019 Atul Prakash. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var searchTableView: UITableView!
    
    // Variables
    var searchActive : Bool = false
    var searchText : String = ""
    var searchResults = [SearchResultModel]()
    var selectedCellData: SearchResultModel!
    var currentPage = 1
    var total_pages = 0
    var isLoadFromStart: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCell()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func resetIntialvalues() {
        currentPage = 1
        total_pages = 0
    }
    
    //MARK:- Register Different UITableViewCell
    func registerTableViewCell(){
        searchTableView.estimatedRowHeight = 50.0
        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.indicatorStyle = UIScrollView.IndicatorStyle.white
        searchTableView.tableFooterView = UIView()
        searchTableView.register(UINib(nibName: String(describing: SearchResultTableViewCell.self),bundle: nil), forCellReuseIdentifier:String(describing: SearchResultTableViewCell.self))
    }
    
    //MARK: - API Request
    func search(with text: String, for searchCriteria: String) {
        if isLoadFromStart {
            searchResults.removeAll()
            resetIntialvalues()
        }
        
        if !text.isEmpty {
            Request.sharedInstance.session.cancelTask()
            guard let testData = GetTestData.sharedInstance.preSetupData,
                let apikey = testData.value(forKey: "APIKey") as? String else {
                    return
            }
            
            Request.sharedInstance.request(url: AppLocators.baseUrl, method: AppLocators.post, params: [AppLocators.APIParam.method : "\(searchCriteria).\(AppLocators.search)", searchCriteria : text, AppLocators.APIParam.apiKey:apikey,AppLocators.APIParam.format:AppLocators.APIParam.json, "page": String(currentPage)]) { (result, error) in
                print(result)
                DispatchQueue.main.async {
                    if error == nil {
                        try? self.parseResultJson(from: result)
                    } else {
                        // Show Error Alert
                    }
                }
            }
        } else {
            self.searchTableView.reloadData()
            self.searchTableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    //MARK: - Parse JSON Array
    func parseResultJson(from dict:NSDictionary) throws {
        guard let results = dict.value(forKeyPath: "\(AppLocators.APIResponse.results).\(SharedData.sharedInstance.searchCriteria)\(AppLocators.APIResponse.matches).\(SharedData.sharedInstance.searchCriteria)") else {
            throw AppLocators.SerializationError.missing(AppLocators.APIResponse.results)
        }
        
        for result in (results as? [[String:AnyObject]])! {
            guard let name = result[AppLocators.APIResponse.name] as? String else {
                throw AppLocators.SerializationError.missing(AppLocators.APIResponse.name)
            }
            
            var artistName = searchText
            if SharedData.sharedInstance.searchCriteria == AppLocators.artists {
               artistName = name
            } else {
                 guard let artist = result[AppLocators.artists] as? String else {
                    throw AppLocators.SerializationError.missing(AppLocators.artists)
                }
                               
                artistName = artist
            }
            
            guard let url = result[AppLocators.APIResponse.url] as? String else {
                throw AppLocators.SerializationError.missing(AppLocators.APIResponse.url)
            }
            
            guard let images = result[AppLocators.APIResponse.image] as? [[String: String]] else {
                throw AppLocators.SerializationError.invalid(AppLocators.APIResponse.image, "Data Type")
            }
            
            print("Artist: \(artistName), Name: \(name), Url: \(url)")
            searchResults.append(SearchResultModel(artist: artistName, name: name, url: url, image: images))
        }
        
        guard let totalResults = dict.value(forKeyPath: "\(AppLocators.APIResponse.results).\(AppLocators.APIResponse.totalResults)") as? String else {
            throw AppLocators.SerializationError.missing(AppLocators.APIResponse.totalResults)
        }
        
        guard let itemsPerPage = dict.value(forKeyPath: "\(AppLocators.APIResponse.results).\(AppLocators.APIResponse.itemsPerPage)") as? String else {
            throw AppLocators.SerializationError.missing(AppLocators.APIResponse.itemsPerPage)
        }
        
        total_pages = (Int(totalResults) ?? 1)/(Int(itemsPerPage) ?? 1)
        
        DispatchQueue.main.async {
            self.searchTableView.reloadData()
            if self.isLoadFromStart {
                self.searchTableView.layoutIfNeeded()
                //Move table view to first cell
                self.searchTableView.setContentOffset(.zero, animated: true)
            }else{
                self.searchTableView.hideLoadingFooter()
            }
        }
    }
    
    //MARK: - IBAction
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        let searchString: String = self.searchBar.searchTextField.text ?? ""
        switch sender.selectedSegmentIndex {
        case 0:
            SharedData.sharedInstance.searchCriteria = AppLocators.track
            self.isLoadFromStart = true
            self.search(with: searchString, for: SharedData.sharedInstance.searchCriteria)
        case 1:
            SharedData.sharedInstance.searchCriteria = AppLocators.album
            self.isLoadFromStart = true
            self.search(with: searchString, for: SharedData.sharedInstance.searchCriteria)
        case 2:
            SharedData.sharedInstance.searchCriteria = AppLocators.artists
            self.isLoadFromStart = true
            self.search(with: searchString, for: SharedData.sharedInstance.searchCriteria)
        default:
            print("")
        }
    }
    
    //MARK: - END OF CLASS
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
        guard let firstSubview = searchBar.subviews.first else { return }
        
        firstSubview.subviews.forEach {
            ($0 as? UITextField)?.clearButtonMode = .never
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        
        // Remove focus from the search bar.
        searchBar.endEditing(true)
        searchActive = false;
        self.searchResults.removeAll()
        self.searchTableView.reloadData()
        self.searchTableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search Bar Text: \(String(describing: searchBar.text)). Call API Here")
        if (searchBar.searchTextField.text?.isEmpty)!{
            searchBar.searchTextField.enablesReturnKeyAutomatically = true
        }else {
            searchText = searchBar.text!
            self.isLoadFromStart = true
            self.search(with: searchText, for: SharedData.sharedInstance.searchCriteria)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        if searchText == "" {
            searchBar.resignFirstResponder()
            searchActive = false
            
        }else{
            searchActive = true
        }
        self.isLoadFromStart = true
        self.search(with: searchText, for: SharedData.sharedInstance.searchCriteria)
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.resignFirstResponder()
        let cellData = searchResults[indexPath.row]
        SharedData.sharedInstance.artist = cellData.artist
        SharedData.sharedInstance.name = cellData.name
        self.performSegue(withIdentifier: AppLocators.detailSegue, sender: self)
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        
        let resultCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultTableViewCell.self), for: indexPath) as! SearchResultTableViewCell
        
        let cellData = searchResults[indexPath.row]
        
        if let imageUrl = cellData.image[0][AppLocators.APIResponse.imageUrl] {
            resultCell.searchImageView.imageFromServerURL(urlString: imageUrl, PlaceHolderImage: UIImage(named: "no-image")!)
        } else {
            resultCell.searchImageView.image = UIImage(named: "no-image")!
        }
        
        resultCell.nameLabel.text = cellData.name
        resultCell.artistLabel.text = cellData.artist
        
        cell = resultCell
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
                
        return cell!
    }
}

// MARK: - UIScrollViewDelegate

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentLarger = (scrollView.contentSize.height > scrollView.frame.size.height)
        let viewableHeight = contentLarger ? scrollView.frame.size.height : scrollView.contentSize.height
        let atBottom = (scrollView.contentOffset.y >= scrollView.contentSize.height - viewableHeight + 50)
        if atBottom && !searchTableView.isLoadingFooterShowing() {
            print("End of Table")
            if currentPage < total_pages {
                currentPage += 1
                self.isLoadFromStart = false
                self.searchTableView.showLoadingFooter()
                self.search(with: searchText, for: SharedData.sharedInstance.searchCriteria)
            }
        }
    }
}

