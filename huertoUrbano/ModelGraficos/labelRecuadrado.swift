//
//  labelRecuadrado.swift
//  huertoUrbano
//
//  Created by Sara Lorente on 30/11/2018.
//  Copyright © 2018 Sara Lorente. All rights reserved.
//

import UIKit

class labelRecuadrado: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        //Se pone borde a todos los labelRecuadro
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.5
    }

}
