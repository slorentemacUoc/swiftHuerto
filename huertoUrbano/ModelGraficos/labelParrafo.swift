//
//  labelParrafo.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 30/11/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import UIKit

class labelParrafo: UILabel {

    override func awakeFromNib(){
        super.awakeFromNib()
        numberOfLines = 0;
        lineBreakMode = NSLineBreakMode.byWordWrapping
        sizeToFit()
    }

}
