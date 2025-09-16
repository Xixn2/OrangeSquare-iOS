//
//  PaletteColor.swift
//  HelloExchange
//
//  Created by Subeen Park on 7/31/25.
//
import UIKit

public extension UIColor {
    static var palette = PaletteColor()
}


public struct PaletteColor {
    fileprivate init() {}

    /// F5F5F5
    public let greyBg: UIColor? = UIColor(hexString: "F5F5F5")
    /// DDDDDD
    public let greyLight: UIColor? = UIColor(hexString: "DDDDDD")
    /// A2A2A2
    public let grey: UIColor? = UIColor(hexString: "A2A2A2")
    /// 555555
    public let greyDark: UIColor? = UIColor(hexString: "555555")
    /// 171717
    public let greyDarkest: UIColor? = UIColor(hexString: "171717")

    /// FC9C9C
    public let redLight: UIColor? = UIColor(hexString: "FC9C9C")
    /// F04242
    public let red: UIColor? = UIColor(hexString: "F04242")

    /// F9D82E
    public let yellowLight: UIColor? = UIColor(hexString: "F9D82E")
    /// E0B406
    public let yellow: UIColor? = UIColor(hexString: "E0B406")

    /// 0AC229
    public let green: UIColor? = UIColor(hexString: "0AC229")

    /// 60C7FB
    public let blueLight: UIColor? = UIColor(hexString: "60C7FB")
    /// 3DB1F5
    public let blue: UIColor? = UIColor(hexString: "3DB1F5")
    /// 0A75C2
    public let blueDark: UIColor? = UIColor(hexString: "0A75C2")
}
