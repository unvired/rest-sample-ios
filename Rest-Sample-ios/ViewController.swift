//
//  ViewController.swift
//  Rest-Sample-ios
//
//  Created by Suman HS on 04/08/17.
//  Copyright © 2017 Suman HS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK:- Properties
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    var alertController: UIAlertController = UIAlertController()
    
    var weatherHeader: WEATHER_HEADER?
    var cityName = ""
    fileprivate var networkManger: NetworkCommunicationManager = NetworkCommunicationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        networkManger.delegate = self
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.barTintColor = UIColor.blue
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.title = NSLocalizedString("Unvired REST Sample", comment: "")
        let menuIcon = UIImage(named: "actions")
        let menuButton = UIButton()
        menuButton.setImage(menuIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        menuButton.tintColor = UIColor.white
        menuButton.addTarget(self, action: #selector(ViewController.menuButtonAction(_:)), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem(customView: menuButton)
        rightBarButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.white.cgColor
        self.contentView.isHidden = true
    }
    
    func showFrameworkSettingsViewController() {
        let settingsViewController: FrameworkSettingsViewController = FrameworkSettingsViewController(style: UITableView.Style.grouped)
        settingsViewController.delegate = self
        let navController: UINavigationController = UINavigationController(rootViewController: settingsViewController)
        navController.modalPresentationStyle = UIModalPresentationStyle.formSheet
        navController.navigationBar.barTintColor = UIColor.blue
        navController.navigationBar.barStyle = UIBarStyle.black
        navController.navigationBar.tintColor = UIColor.white
        self.present(navController, animated: true, completion: nil)
    }
    
    // MARK:- Actions
    
    @IBAction func menuButtonAction(_ sender: AnyObject) {
        let alertController: UIAlertController = UIAlertController(title: nil, message: nil,
                                                                   preferredStyle: UIAlertController.Style.actionSheet)
        
        let settingsAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: UIAlertAction.Style.default) { (action: UIAlertAction) -> Void in self.showFrameworkSettingsViewController()
        }
        
        
        let cancelAction: UIAlertAction = UIAlertAction(title:  NSLocalizedString("Cancel",  comment: ""), style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {
            alertController.popoverPresentationController?.passthroughViews = nil
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad  {
            alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        }
    }
    
    @IBAction func getWeatherButtonClicked(_ sender: Any) {
        
        if cityName.count == 0 || cityName == "" {
            Utility.displayStringInAlertView("", desc: "Enter City.", viewController: self)
            return
        }
        
        self.weatherHeader = WEATHER_HEADER()
        self.weatherHeader?.CITY = cityName
        if let weather = weatherHeader {
            showBusyIndicator()
            self.networkManger.sendDataToServer(MESSAGE_REQUEST_TYPE.PULL,
                                                PAFunctionName: AppConstants.PA_GET_WEATHER,
                                                header: weather)
        }
    }
    
    func showBusyIndicator() {
        alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: .alert)
        
        let spinnerIndicator = UIActivityIndicatorView(style: .whiteLarge)
        
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        
        alertController.view.addSubview(spinnerIndicator)
        self.present(alertController, animated: false, completion: nil)
    }
    
    func hideBusyIndicator() {
        alertController.dismiss(animated: true, completion: nil);
    }
    
    func setUpData() {
        
        if let weather = self.weatherHeader {
            if let desc = weather.WEATHER_DESC {
                self.descriptionLabel.text = desc
            }
            
            if let tempr = weather.TEMPERATURE {
                self.temperatureLabel.text = tempr
            }
            
            if let humidity = weather.HUMIDITY {
                self.humidityLabel.text = humidity
            }
        }
        
    }
    
}

// MARK:- Framework Settings Delegate
extension ViewController : SettingsDelegate {
    func doneButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK:- TextField Delegate Methods
extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var someText = textField.text!
        someText = (someText as NSString).replacingCharacters(in: range, with: string)
        someText = someText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        cityName = someText
        print("City: \(String(describing: cityName))")
        
        if(cityName.count == 0) {
            self.contentView.isHidden = true
        }
        
        return true
    }
    
}


extension ViewController: NetworkConnectionDelegate {
    
    func didGetResponseForPA(_ paFunctionName: String, infoMessage: String, responseHaeders: Dictionary<String, AnyObject>) {
        self.contentView.isHidden = false
        hideBusyIndicator()
        self.weatherHeader = getWeatherHeader(responseHaeders)[0]
        self.setUpData()
    }
    
    func didEncounterErrorForPA(_ paFunctionName: String, errorMessage: NSError) {
        self.contentView.isHidden = true
        hideBusyIndicator()
        Utility.displayAlertWithOKButton("", message: errorMessage.localizedDescription, viewController: self)
    }
    
    func getWeatherHeader(_ dataBEs: Dictionary<String, AnyObject>) -> [WEATHER_HEADER] {
        var weatherHeader: [WEATHER_HEADER] = []
        
        for (_, beDictionary) in dataBEs {
            for (header, _) in beDictionary as! Dictionary<DataStructure, [IDataStructure]> {
                // Header
                weatherHeader.append(header as! WEATHER_HEADER)
            }
        }
        return weatherHeader
    }
}
