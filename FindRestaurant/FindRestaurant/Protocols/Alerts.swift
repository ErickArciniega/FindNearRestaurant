//
//  Alerts.swift
//  FindRestaurant
//
//  Created by Erick Arciniega on 18/12/19.
//  Copyright © 2019 Erick Arciniega. All rights reserved.
//

import Foundation
import UIKit

protocol protocolAlert {
}

extension protocolAlert where Self: UIViewController{
    func goToSettings(title: String, message: String, buttonTittle: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: buttonTittle, style: UIAlertAction.Style.default, handler: {(action) -> Void in
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
               return
            }
            if UIApplication.shared.canOpenURL(url) {
               UIApplication.shared.open(url, options: [:])
            }
        })
        alertController.addAction(ok)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
