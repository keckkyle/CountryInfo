//
//  CountryViewController.swift
//  CountryInfo
//
//  Created by Kyle Keck on 5/11/20.
//  Copyright © 2020 keckkyle. All rights reserved.
//

import UIKit

class CountryViewController: UITableViewController {
    //set slide over to get correct direction animation when changing countries
    let slideOver = SlideOver()
    
    var countryIndex = 0
    
    var headers = [String]()
    var values = [[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //set title to display only small text
        navigationItem.largeTitleDisplayMode = .never
        //remove row separator
        tableView.separatorStyle = .none
        //disable selection of rows
        tableView.allowsSelection = false
        //set delegate to be this view controller
        navigationController?.delegate = self
        
        //set gesture recognizers
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)

        //set mirror of the selected country
        let mirror = Mirror(reflecting: CountryService.shared.countries[countryIndex])
        //loop through mirror
        for child in mirror.children {
            //check variable names
            switch child.label! {
            //for these variable names move to next child
            case "alpha3Code", "alpha2Code", "flagIcon", "nativeName":
                continue
            default:
                //add variable names as capitalized string values to header array
                headers.append(child.label!.capitalized)
                //format variable values and add to values array
                values.append(toStringArray(child.value))
            }
        }
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer){
        let cCount = CountryService.shared.countries.count - 1
        
        //if left swipe
        if sender.direction == .left {
            //set transition direction
            slideOver.slideRight = false
            //set next country
            if countryIndex == cCount {
                countryIndex = 0
            } else {
                countryIndex += 1
            }
        }
        //if right swipe
        if sender.direction == .right {
            //set transition direction
            slideOver.slideRight = true
            //set next country
            if countryIndex == 0 {
                countryIndex = cCount
            } else {
                countryIndex -= 1
            }
        }
        //navigate to country
        navigate(to: countryIndex)
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    //function to check for device motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        //if the motion is shake motion
        if motion == .motionShake {
            //create random index number
            let index = Int.random(in: 0..<CountryService.shared.countries.count)
            //navigate to country
            navigate(to: index)
        }
    }
    
    func navigate(to index: Int){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CountryDetails") as? CountryViewController {
            //give the view controller a name
            vc.title = "\(CountryService.shared.countries[index].nativeName)"
            //set the country index number to match the selected country
            vc.countryIndex = index
            //navigate to country detail page
            navigationController?.pushViewController(vc, animated: true)
        }
        self.title = ""
        //remove slide from navigation stack
        navigationController?.viewControllers.remove(at: (navigationController?.viewControllers.count)! - 2)
    }
    
    // MARK: - Table view data source

    //set section title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //check if it is timezone or border section
        if headers[section] == "Timezones" || headers[section] == "Borders" {
            //add count to the section header return title string
            return "\(headers[section]) (\(values[section].count))"
        }
        //set section to header name
        return headers[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //hide header if there are no items or for the flagimage
        if values[section].count < 1 || headers[section] == "Flagimage" {
            return 0
        }
        //set height to 30
        return 30
    }
    
    //return number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return values.count
    }

    //return number of rows for section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //set flag image section to 1 row
        if headers[section] == "Flagimage" {
            return 1
        }
        return values[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Check if section is flag image section
        if headers[indexPath.section] == "Flagimage" {
            //set to flag cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "flagImageCell", for: indexPath) as! FlagCell
            //make sure that there is image data to use for the image or cell without setting image
            guard let imageData = CountryService.shared.countries[countryIndex].flagImage else {
                return cell
            }
            //set image
            cell.flagImage.image = UIImage(data: imageData)
            return cell
        }

        //set cell for all rows that are not a flag image
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //set text from the correct array
        var text = values[indexPath.section][indexPath.row]
        //check if it is the borders section
        if headers[indexPath.section] == "Borders" {
            //find matching country index based of 3 letter country code
            let borderIndex = CountryService.shared.countries.firstIndex {
                $0.alpha3Code == values[indexPath.section][indexPath.row]
            }
            //get country using index if there is one
            guard let index = borderIndex else { return cell }
            //get the correct country from the list
            let country = CountryService.shared.countries[index]
            //set text to the full country name
            text = country.name
        }
        
        //check if it is the area section
        if headers[indexPath.section] == "Area" {
            //add square km to the area
            text += " km\u{00B2}"
        }
        
        //set cell text
        cell.textLabel?.text = text

        return cell
    }

}

//MARK: - Navigation Delegate to implement animations
extension CountryViewController: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        slideOver.pop = (operation == .pop)
        return slideOver
    }
}
