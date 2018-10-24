//
//  Utility.swift
//  SAP-Sample-ios
//
//  Created by Suman HS on 02/08/17.
//  Copyright © 2017 Suman HS. All rights reserved.
//

import Foundation

struct Utility {
    
    static func removeExtraLinesFromTableView(_ tableView: UITableView) {
        // This will remove extra separators from tableview
        tableView.tableFooterView =  UIView(frame: CGRect.zero)
    }
    
    static func getCompleteInfoMessageStringFromInfoMessages(_ infoMessages: [AnyObject]) -> (String,Bool) {
        // Loop through Each of Info Messages and form one complete String.
        var completeInfoMessageString : String = ""
        var successInfoMessage: Bool = false
        for infoMessage in infoMessages {
            
            // Check Whether infoMessage is really the type of class |InfoMessage|
            if (infoMessage.isKind(of: InfoMessage.classForCoder())) {
                
                // Extract the Message
                let message: String! = infoMessage.getMessage()
                completeInfoMessageString = "\(completeInfoMessageString)" + message
                
                if let infoMessageStatus = infoMessage.getCategory() {
                    switch infoMessageStatus {
                    case INFO_MESSAGE_CATEGORY_SUCCESS,INFO_MESSAGE_CATEGORY_INFO:
                        successInfoMessage = true
                    case INFO_MESSAGE_CATEGORY_FAILURE:
                        successInfoMessage = false
                    default:
                        break
                    }
                }
            }
        }
        return (completeInfoMessageString, successInfoMessage)
    }
    
    static func displayAlertWithOKButton(_ title: String, message: String, viewController: UIViewController) {
        DispatchQueue.main.async {
            let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let alertAction: UIAlertAction = UIAlertAction(title:  NSLocalizedString("OK",  comment: ""), style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(alertAction)
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func displayStringInAlertView(_ title: String, desc: String, viewController: UIViewController) {
        DispatchQueue.main.async {
            let alertController: UIAlertController = UIAlertController(title: title, message: desc, preferredStyle: UIAlertController.Style.alert)
            let alertAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.cancel, handler: { (UIAlertAction) in
                // Nothing. The alert closes automatically
            })
            alertController.addAction(alertAction)
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
        
    static func logErrorMessage(_ error: NSError?) {
        if error != nil {
            Logger.logger(with: LEVEL.ERROR, className: String(describing: Utility()), method: #function , message: error!.localizedDescription)
        }
    }
}
