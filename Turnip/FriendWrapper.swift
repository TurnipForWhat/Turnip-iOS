//
//  FriendWrapper.swift
//  Turnip
//
//  Created by Maxcell Wilson on 4/11/16.
//  Copyright © 2016 Turnip Apps. All rights reserved.
//

import Foundation
import SwiftyJSON

class FriendWrapper {
    var name: String?
    var status: Bool?
    var image: UIImage?

    required init(json: JSON){
        self.name = json[FriendFields.name.rawValue].stringValue;
        self.status = json[FriendFields.status.rawValue].bool;
//        self.last_toggle_time = json[FriendFields.last_toggled_time.rawValue].double
    }
    
}