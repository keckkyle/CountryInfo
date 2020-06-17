//
//  TableViewController.swift
//  CountryInfo
//
//  Created by Kyle Keck on 5/5/20.
//  Copyright © 2020 keckkyle. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var countries = [Country]()
    var filteredCountries: [Country] = []
    
    var image:UIImage!
    let searchController = UISearchController(searchResultsController: nil)
    
    let searchCategories = ["Country", "Region", "Capital", "Language"]
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.countries = CountryService.shared.countries
        CountryService.shared.delegate = self
        self.title = "Countries"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by country, region, capital or language"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = ["Country", "Region", "Capital", "Language"]
        searchController.searchBar.delegate = self
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    //function to detect device motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        //check if motion is shake
        if motion == .motionShake {
            //create random index
            let index = Int.random(in: 0..<countries.count)
            //navigate to country details page for random index
            navigateToDetails(for: index)
        }
    }
    // MARK: - Table view data source
    
    //set row height for cells
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    //get the number of rows for the section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCountries.count
        }
        return countries.count
    }

    //create the table to be displayed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //declare cell using CountryCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCellView", for: indexPath) as! CountryCell
        var country: Country
        //get country for the current cell
        if isFiltering {
            country = filteredCountries[indexPath.row]
        } else {
            country = countries[indexPath.row]
        }
        //display country name
        cell.name.text = country.name
        //check that country has a flag icon and set the cell image to the icon
        if let flag = country.flagIcon {
            cell.flagView.image = UIImage(data: flag)
        }
        //return cell
        return cell
    }
    
    //handle user touch of cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index = 0
        if isFiltering {
            index = countries.firstIndex{ $0.name == filteredCountries[indexPath.row].name} ?? 0
        } else {
            index = indexPath.row
        }
        navigateToDetails(for: index)
    }
    
    func navigateToDetails(for index: Int){
        //declare the view controller as a CountryDetails view controller
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CountryDetails") as? CountryViewController {
            //give the view controller a name
            vc.title = "\(countries[index].nativeName)"
            //set the country index number to match the selected country
            vc.countryIndex = index
            //navigate to country detail page
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func searchCountries(for searchText: String, in category: String = "Country") {
        let text = searchText.lowercased()
        
        switch category {
        case "Country":
            self.filteredCountries = countries.filter {
                $0.name.lowercased().contains(text)
            }
        case "Region":
            self.filteredCountries = countries.filter {
                $0.region.lowercased().contains(text) ||
                    $0.subregion.lowercased().contains(text)
            }
        case "Capital":
            self.filteredCountries = countries.filter {
                $0.capital.lowercased().contains(text)
            }
        case "Language":
            self.filteredCountries = countries.filter { country in
                country.languages.contains{ language in
                    language.name.lowercased().contains(text)
                }
            }
        default:
            self.filteredCountries = self.countries
        }
        
        self.tableView.reloadData()
    }
}

//MARK: - Country List Protocol Extension
extension TableViewController: CountryListProtocol {
    func countryListUpdate() {
        //set country data for view controller
        self.countries = CountryService.shared.countries
        //reload the table data
        self.tableView.reloadData()
    }
}


//MARK: - Search Bar Extensions
extension TableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let category = searchCategories[searchController.searchBar.selectedScopeButtonIndex]
        searchCountries(for: searchBar.text!, in: category)
        
    }
}

extension TableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let category = searchCategories[selectedScope]
        searchCountries(for: searchBar.text!, in: category)
    }
}
