//
//  FuncImage.swift
//  Groceries
//
//  Created by Roger Yong on 22/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

func cartImage() -> UIImage? {
    if let image = UIImage(named: ImageName.Basket)?.imageWithRenderingMode(.AlwaysTemplate) {
        return image
    }
    return nil
}
func backImage() -> UIImage? {
    if let image = UIImage(named: ImageName.Back)?.imageWithRenderingMode(.AlwaysTemplate) {
       return image
    }
    return nil
}
func qtyImage() -> UIImage? {
    if let image = UIImage(named: ImageName.Qty)?.imageWithRenderingMode(.AlwaysTemplate) {
        return image
    }
    return nil
}
func exchangeImage() -> UIImage? {
    if let image = UIImage(named: ImageName.Exchange)?.imageWithRenderingMode(.AlwaysTemplate) {
        return image
    }
    return nil
}
