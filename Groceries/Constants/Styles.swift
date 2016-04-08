//
//  Styles.swift
//  Groceries
//
//  Created by Roger Yong on 19/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

struct ImageName {
    static let Basket = "basket"
    static let Back = "arrow_back"
    static let Qty = "updown_arrow"
    static let Exchange = "exchange"
}

struct Height {
    static let Device: CGFloat = UIScreen.mainScreen().bounds.size.height
    static let Cell: CGFloat = 45
    static let BasketCell: CGFloat = 60
    static let Button: CGFloat = 45
    static let SmallButton: CGFloat = 35
}

struct Width {
    static let Device: CGFloat = UIScreen.mainScreen().bounds.size.width
    static let LongButton: CGFloat = Width.Device - Padding.Left.Regular - Padding.Right.Regular
    static let PickerView: CGFloat = Width.Device - Padding.Left.Regular - Padding.Right.Regular
    static let Button: CGFloat = 80
    static let LabelTable: CGFloat = Width.Device - (Padding.Left.Table + Padding.Spacing + Padding.Right.Table) - (Width.Button * 2)
    static let LabelRegular: CGFloat = Width.Device - (Padding.Spacing * 3) - Width.Button
}

struct Padding {
    static let Spacing: CGFloat = 10
    struct Top {
        static let Table: CGFloat = 15
        static let Regular: CGFloat = 10
        static let RegularHalf: CGFloat = 5
    }
    struct Left {
        static let Table: CGFloat = 15
        static let Regular: CGFloat = 10
        static let RegularHalf: CGFloat = 5
    }
    struct Right {
        static let Table: CGFloat = 15
        static let Regular: CGFloat = 10
        static let RegularHalf: CGFloat = 5
    }
}

struct FontNameCalibri {
    static let Bold = "Calibri-Bold"
    static let Regular = "Calibri"
}

struct FontSize {
    static let MegaTidy: CGFloat = 10.0
    static let SuperTiny: CGFloat = 11.0
    static let VeryTiny: CGFloat = 12.0
    static let ExtraTiny: CGFloat = 13.0
    static let Tiny: CGFloat = 14.0
    static let SuperSmall: CGFloat = 15.0
    static let VerySmall: CGFloat = 16.0
    static let ExtraSmall: CGFloat = 17.0
    static let Small: CGFloat = 18.0
    static let Medium: CGFloat = 19.0
    static let Large: CGFloat = 20.0
    static let TinyLarge: CGFloat = 21.0
    static let ExtraLarge: CGFloat = 22.0
    static let VeryLarge: CGFloat = 24.0
}

struct Color {
    static let SlateGray    = "363638"
    static let Red          = "E05206"
    static let Blue         = "41A9E0"
    static let Black        = "000000"
    static let White        = "FFFFFF"
    static let Gray         = "F2F2F2"
    static let LightGray    = "C2C2C2"
}