//
//  TypographyLabel.swift
//  HelloExchange
//
//  Created by Subeen Park on 7/31/25.
//

import UIKit

public final class TypographyLabel: UILabel {
    public init(
        text: String,
        typography: Typography,
        color: UIColor? = .palette.greyDarkest,
        alignment: NSTextAlignment = .left,
        additionalAttributes: [NSAttributedString.Key: Any] = [:]
    ) {
        super.init(frame: .zero)
        self.numberOfLines = 0
        self.setStyledText(
            text,
            using: typography,
            color: color,
            alignment: alignment,
            additionalAttributes: additionalAttributes
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setStyledText(
        _ text: String,
        using typography: Typography,
        color: UIColor? = .palette.greyDarkest,
        alignment: NSTextAlignment = .left,
        additionalAttributes: [NSAttributedString.Key: Any] = [:]
    ) {
        var attributes = typography.attributes
        let paragraphStyle = (typography.attributes[.paragraphStyle] as? NSMutableParagraphStyle) ?? .init()
        paragraphStyle.alignment = alignment

        attributes[.paragraphStyle] = paragraphStyle
        attributes[.foregroundColor] = color ?? .black

        let mergedAttributes = attributes.merging(additionalAttributes, uniquingKeysWith: { _, rhs in rhs })
        self.attributedText = NSAttributedString(string: text, attributes: mergedAttributes)
    }
}
