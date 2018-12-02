//
//  BotonAplicacion.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 30/11/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import UIKit

class BotonAplicacion: UIButton {

    override func awakeFromNib(){
        super.awakeFromNib();
        layer.borderWidth = 1
        layer.borderColor = UIColor.blue.cgColor
    }

}
