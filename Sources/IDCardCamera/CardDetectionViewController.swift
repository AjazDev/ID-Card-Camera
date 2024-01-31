//
//  CardDetectionViewController.swift
//  VerIDIDCapture
//
//  Created by Jakub Dolejs on 03/01/2018.
//  Copyright © 2018 Applied Recognition, Inc. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

/// View controller used to run a camera session that collects an image of an card with a given aspect ratio and returns an image with corrected perspective
/// - Since: 1.0.0
@objc public class CardDetectionViewController: BaseCardDetectionViewController {
    
    /// Card detection delegate
    /// - Since: 1.0.0
    @objc public weak var delegate: CardDetectionViewControllerDelegate?
    /// Card detection settings
    /// - Since: 1.0.0
    @objc public var settings = CardDetectionSettings()
    
    /// Initializer
    /// - Since: 1.0.0
    @objc public override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var cardAspectRatio: CGFloat {
        return self.settings.size.width / self.settings.size.height
    }
    
    override var imagePoolSize: Int {
        return self.settings.imagePoolSize
    }
    
    override func delegateCancel() {
        if !self.backgroundOperationQueue.isSuspended {
            self.backgroundOperationQueue.addOperation {
                if let delegate = self.delegate {
                    DispatchQueue.main.async {
                        delegate.cardDetectionViewControllerDidCancel?(self)
                    }
                    self.delegate = nil
                }
            }
        } else {
            self.delegate?.cardDetectionViewControllerDidCancel?(self)
            self.delegate = nil
        }
    }
    
    override func qualityOfImage(_ image: CGImage) -> Float? {
        return self.delegate?.qualityOfImage?(image)?.floatValue
    }
    
    override func didCropImageToImage(_ image: CGImage) {
        guard let delegate = self.delegate else {
            DispatchQueue.main.async {
                self.dismiss()
            }
            return
        }
        self.delegate = nil
        DispatchQueue.main.async {
            self.dismiss()
            delegate.cardDetectionViewController(self, didDetectCard: image, withSettings: self.settings)
        }
    }
    
    override func flipCardOrientation() {
        if self.settings.orientation == .landscape {
            self.settings.orientation = .portrait
        } else {
            self.settings.orientation = .landscape
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.sessionHandler.torchSettings = self.settings
        self.sessionHandler.cardDetectionSettings = self.settings
        self.updateNavSettings()
    }

    func updateNavSettings(){
        if self.settings.shouldShowNavBar {
            self.navigationBar.topItem?.rightBarButtonItem?.title = self.settings.titles.rotateCardTitle
            self.navigationBar.topItem?.rightBarButtonItem = nil
            self.navigationBar.items?.first?.title = self.settings.titles.title
            self.navigationBar.tintColor = self.settings.colors.tintColor
            self.navigationBar.topItem?.prompt = self.settings.titles.prompt
            self.navigationBar.backgroundColor = self.settings.colors.navigationBackgroundColor
        } else {
            print("nothing to do")
        }
    }
}
