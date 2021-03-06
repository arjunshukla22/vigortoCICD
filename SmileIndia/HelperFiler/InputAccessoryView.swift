//
//  AccessoryView.swift
//  InputAccessory
//
//  Created by Raghav Ahuja on 12/26/18.
//  Copyright © 2018 Raghav Ahuja. All rights reserved.
//

import UIKit

// defines a callback protocol for the SampleButtonView
protocol SampleButtonViewDelegate: class {
    func sampleButtonTapped( text: String)
}

class InputAccessoryView: UIView {
    @IBOutlet  weak var textView: CustomUITextView!
    @IBOutlet  weak var sendButton: UIButton!
    
    // set delegate if you want to handle button taps via delegate
    weak var delegate: SampleButtonViewDelegate?
    
    var placeholder: String = "" {
        didSet {
            textView.placeholder = placeholder
        }
    }
    
    var maxTextViewHeight: CGFloat = 150 {
        didSet {
            // Re-calculate intrinsicContentSize when maxHeight changes
            invalidateIntrinsicContentSize()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.delegate = self
        // autoresizingMask allow the height to be flexible in order accomodate the safe area inset
        self.autoresizingMask = [.flexibleHeight]
    }
    
    @IBAction private func sendButtonPressed(_ sender: Any) {
        
        textViewDidChange(textView)
        
        delegate?.sampleButtonTapped(text: textView.text)
        
        
    }
    
    override var intrinsicContentSize: CGSize {
        // maximum size for the textView
        let maxSize = CGSize(width: textView.bounds.width, height: .infinity)
        // newSize is the size in which textView can fit perfectly
        let newSize = textView.sizeThatFits(maxSize)
        
        // if the newSize height is greater than allocated height then enable scrolling
        if newSize.height >= maxTextViewHeight {
            textView.isScrollEnabled = true
            return CGSize(width: self.bounds.width, height: maxTextViewHeight)
        } else {
            // else grow the textView height by growing InputAccessoryView height
            textView.isScrollEnabled = false
            return CGSize(width: self.bounds.width, height: newSize.height)
        }
    }
}

extension InputAccessoryView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // enable send Button depending upon text in textView
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        sendButton.isEnabled = !text.isEmpty
        
        // Re-calculate intrinsicContentSize when text changes
        invalidateIntrinsicContentSize()
    }
}
