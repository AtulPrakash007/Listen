//
//  DetailViewController.swift
//  Listen
//
//  Created by Atul Prakash on 07/01/20.
//  Copyright © 2020 Atul Prakash. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var infoTable: UITableView!
    
    var detailResult: DetailDataModel!
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = SharedData.sharedInstance.searchCriteria + " Detail"
        self.registerTableViewCell()
        self.getDetailInfo()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Register Different UITableViewCell
    func registerTableViewCell(){
        
        infoTable.estimatedRowHeight = 150
        infoTable.rowHeight = UITableView.automaticDimension
        infoTable.indicatorStyle = UIScrollView.IndicatorStyle.white
        infoTable.tableFooterView = UIView()
        infoTable.register(UINib(nibName: String(describing: LabelTableViewCell.self),bundle: nil), forCellReuseIdentifier:String(describing: LabelTableViewCell.self))
        infoTable.register(UINib(nibName: String(describing: ImageTableViewCell.self),bundle: nil), forCellReuseIdentifier:String(describing: ImageTableViewCell.self))
        infoTable.register(UINib(nibName: String(describing: TextViewTableViewCell.self),bundle: nil), forCellReuseIdentifier:String(describing: TextViewTableViewCell.self))
        infoTable.register(UINib(nibName: String(describing: SearchResultTableViewCell.self),bundle: nil), forCellReuseIdentifier:String(describing: SearchResultTableViewCell.self))
    }
    
    //MARK:- Button Action
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- API Request
    func getDetailInfo() {
            var param = [String: String]()
            
            guard let testData = GetTestData.sharedInstance.preSetupData,
                let apikey = testData.value(forKey: "APIKey") as? String else {
                    return
            }
            
        switch SharedData.sharedInstance.searchCriteria {
            case AppLocators.album, AppLocators.track:
                param = [AppLocators.APIParam.method : "\(SharedData.sharedInstance.searchCriteria).\(AppLocators.APIParam.getInfo)", AppLocators.APIParam.apiKey : apikey, AppLocators.artists : SharedData.sharedInstance.artist, SharedData.sharedInstance.searchCriteria : SharedData.sharedInstance.name, AppLocators.APIParam.format : AppLocators.APIParam.json]
            case AppLocators.artists:
                param = [AppLocators.APIParam.method : "\(SharedData.sharedInstance.searchCriteria).\(AppLocators.APIParam.getInfo)", AppLocators.APIParam.apiKey : apikey, AppLocators.artists : SharedData.sharedInstance.artist, AppLocators.APIParam.format : AppLocators.APIParam.json]
            default:
                print("No Param required")
            }
            
            Request.sharedInstance.request(url: AppLocators.baseUrl, method: AppLocators.post, params: param) { (result, error) in
                print(result)
                DispatchQueue.main.async {
                    if error == nil {
                        self.parseResultJson(from: result)
                    } else {
                        // Show Error Alert
                    }
                }
            }
        }
    
    //MARK: - Parse JSON Array
    func parseResultJson(from dict:NSDictionary) {
        
        switch SharedData.sharedInstance.searchCriteria {
        case AppLocators.track:
            detailResult = self.parseTrackData(from: dict)
            sections = [Section(sectionHeader: "\(AppLocators.track.capitalized) \(AppLocators.info.capitalized)\(AppLocators.colon)", rowCount: 7)]
        case AppLocators.album:
            detailResult = self.parseAlbumData(from: dict)
            if detailResult.tracksName.count > 0 {
                sections = [Section(sectionHeader: "\(AppLocators.album.capitalized) \(AppLocators.info.capitalized)\(AppLocators.colon)", rowCount: 7), Section(sectionHeader: "\(AppLocators.album.capitalized) \(AppLocators.track.capitalized)s\(AppLocators.colon)", rowCount: detailResult.tracksName.count)]
            } else {
                sections = [Section(sectionHeader: "\(AppLocators.album.capitalized) \(AppLocators.info.capitalized)\(AppLocators.colon)", rowCount: 7)]
            }
        case AppLocators.artists:
            detailResult = self.parseArtistData(from: dict)
            if detailResult.similarArtistName.count > 0 {
                sections = [Section(sectionHeader: "\(AppLocators.artists.capitalized) \(AppLocators.info.capitalized)\(AppLocators.colon)", rowCount: 7), Section(sectionHeader: "\(AppLocators.artists.capitalized) \(AppLocators.colon)", rowCount: detailResult.similarArtistName.count)]
            } else {
                sections = [Section(sectionHeader: "\(AppLocators.artists.capitalized) \(AppLocators.info.capitalized)\(AppLocators.colon)", rowCount: 7)]
            }
        default:
            print("")
        }
        
        self.infoTable.reloadData()
        self.infoTable.setContentOffset(CGPoint.zero, animated: true)
    }
    
    //MARK: - END OF CLASS
}

// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].sectionHeader
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.white
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.black
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        let imageCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageTableViewCell.self), for: indexPath) as! ImageTableViewCell
        
        let labelCell = tableView.dequeueReusableCell(withIdentifier: String(describing: LabelTableViewCell.self), for: indexPath) as! LabelTableViewCell
        
        let textViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextViewTableViewCell.self), for: indexPath) as! TextViewTableViewCell
        
        let defaultCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultTableViewCell.self), for: indexPath) as! SearchResultTableViewCell
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                if detailResult.image.isEmpty {
                    imageCell.cellImageView.image = UIImage(named: "no-image")!
                } else if !detailResult.image[2].isEmpty {
                    imageCell.cellImageView.imageFromServerURL(urlString: detailResult.image[2], PlaceHolderImage: UIImage(named: "no-image")!)
                } else {
                    imageCell.cellImageView.imageFromServerURL(urlString: detailResult.image[0], PlaceHolderImage: UIImage(named: "no-image")!)
                }
                
                cell = imageCell
            case 1:
                labelCell.cellLabel.text = "\(AppLocators.APIResponse.name.capitalized)\(AppLocators.colon) \(detailResult.name)"
                cell = labelCell
            case 2:
                labelCell.cellLabel.text = "\(AppLocators.artists.capitalized)\(AppLocators.colon) \(detailResult.artist)"
                cell = labelCell
            case 3:
                labelCell.cellLabel.text = "\(AppLocators.APIResponse.listeners.capitalized)\(AppLocators.colon) \(detailResult.listeners)"
                cell = labelCell
            case 4:
                labelCell.cellLabel.text = "\(AppLocators.APIResponse.playcount.capitalized)\(AppLocators.colon) \(detailResult.playcount)"
                cell = labelCell
            case 5:
                labelCell.cellLabel.text = "\(AppLocators.APIResponse.tags.capitalized)\(AppLocators.colon) \(detailResult.tags.joined(separator: AppLocators.comma))"
                cell = labelCell
            case 6:
                textViewCell.textString = "Summary: \n\(detailResult.summary)"
                cell = textViewCell
            default:
                print("No more rows for section zero")
            }
        case 1:
            if detailResult.tracksName.count > 0 {
                defaultCell.nameLabel.text = detailResult.tracksName[indexPath.row]
                defaultCell.artistLabel.text = "\(detailResult.tracksDuration[indexPath.row]) Seconds"
            }
            
            if detailResult.similarArtistName.count > 0 {
                defaultCell.nameLabel.text = detailResult.similarArtistName[indexPath.row]
                
                if detailResult.smilarArtistImage[indexPath.row].isEmpty {
                    defaultCell.searchImageView.image = UIImage(named: "no-image")!
                } else if !detailResult.smilarArtistImage[indexPath.row][2].isEmpty {
                    defaultCell.searchImageView.imageFromServerURL(urlString: detailResult.smilarArtistImage[indexPath.row][2], PlaceHolderImage: UIImage(named: "no-image")!)
                } else {
                    defaultCell.searchImageView.imageFromServerURL(urlString: detailResult.smilarArtistImage[indexPath.row][0], PlaceHolderImage: UIImage(named: "no-image")!)
                }
            }
            
            cell = defaultCell
        default:
            print("No More Section")
        }
        
        cell?.selectionStyle = .none
        
        return cell!
    }
}
