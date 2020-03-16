//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Ali Rahal on 3/15/20.
//  Copyright © 2020 Ali Rahal. All rights reserved.
//
import UIKit
import GooglePlaces

protocol SearchDelegate {
    func locationSelected(country: String)
}

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //Properties
    var placeIDArray = [String]()
    var resultsArray = [String]()
    var primaryAddressArray = [String]()
    var searchResults = [String]()
    var searhPlacesName = [String]()
    let googleAPIKey = "AIzaSyB-cvld5QmXOkDO-ogOc9Ceml_KR0yfgHY"
    var delegate: SearchDelegate?
    
    
    //search Controller implementations
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        tableViewSetup()
        setSearchController()
        //add uiviewcontroller extension function
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    func tableViewSetup(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = searchController.searchBar
        self.tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
    }
    
    func setSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search For Location"
        searchController.searchBar.searchBarStyle = .minimal
        self.navigationController?.navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForTextSearch(searchText: String){
        placeAutocomplete(text_input: searchText)
        self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchController.searchBar.showsCancelButton = true
        self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .automatic)
    }
    func isFiltering() -> Bool{
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBarIsEmpty()){
            searchBar.text = ""
        }else{
            placeAutocomplete(text_input: searchText)
            
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let address = self.resultsArray[indexPath.row]
        self.delegate?.locationSelected(country: address)
        self.navigationController?.popViewController(animated: true)
    }
    
    //function for autocomplete
    func placeAutocomplete(text_input: String) {
        let placesClient = GMSPlacesClient()
        
        
        let token = GMSAutocompleteSessionToken.init()
        
        // Create a type filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        
        
        placesClient.findAutocompletePredictions(fromQuery: text_input, filter: filter, sessionToken: token) { (results, error) in
            self.placeIDArray.removeAll()
            self.resultsArray.removeAll()
            self.primaryAddressArray.removeAll()
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                for result in results {
                    self.primaryAddressArray.append(result.attributedPrimaryText.string)
                    self.resultsArray.append(result.attributedFullText.string)
                    self.primaryAddressArray.append(result.attributedPrimaryText.string)
                    self.placeIDArray.append(result.placeID)
                }
            }
            self.searchResults = self.resultsArray
            self.searhPlacesName = self.primaryAddressArray
            self.tableView.reloadData()
        }
    }
    
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForTextSearch(searchText: searchController.searchBar.text!)
    }
    
}




