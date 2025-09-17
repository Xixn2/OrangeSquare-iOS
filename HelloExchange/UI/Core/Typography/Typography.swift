//
//  UIFont+ext.swift
//  HelloExchange
//
//  Created by Subeen Park on 7/24/25.
//

import UIKit

public struct Typography {
    public let name: String
    public let size: CGFloat
    public let lineHeight: CGFloat
    public let weight: UIFont.Weight
    public let kerning: CGFloat

    public var font: UIFont {
        return UIFont.systemFont(ofSize: size, weight: weight)
    }

    var attributes: [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.lineBreakMode = .byTruncatingTail

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: size, weight: weight),
            .paragraphStyle: paragraphStyle,
            .kern: kerning
        ]

        return attributes
    }
}

public extension Typography {
    static let caption = Typography(name: "caption", size: 13, lineHeight: 18, weight: .regular, kerning: -0.2)
    static let captionBold = Typography(name: "captionBold", size: 13, lineHeight: 18, weight: .bold, kerning: -0.2)

    static let body = Typography(name: "body", size: 14, lineHeight: 19, weight: .regular, kerning: -0.25)
    static let bodyBold = Typography(name: "bodyBold", size: 14, lineHeight: 19, weight: .bold, kerning: -0.25)

    static let subhead = Typography(name: "subhead", size: 15, lineHeight: 21, weight: .regular, kerning: -0.3)
    static let subheadBold = Typography(name: "subheadBold", size: 15, lineHeight: 21, weight: .bold, kerning: -0.3)
}

