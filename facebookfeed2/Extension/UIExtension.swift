//
//  UIFontExtension.swift
//  facebookfeed2
//
//  Created by iakay on 11.05.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import AVKit
import PINRemoteImage
import Foundation
import RxSwift
import RxCocoa
import RxGesture

private var zoomPinchCoverView: ZoomPinchCoverView? = nil
private var isZooming = false
private var originCenter: CGPoint? = nil

/**
 It is an extension of UIImageView to support pinching zoom and panning looks like one Instagram has.
 Usage:
 ...
 imageView.setupZoomPinchGesture().disposed(by: disposeBag)
 imageView.setupZoomPanGesture().disposed(by: disposeBag)
 ...
 */
extension UIImageView
{
    @discardableResult
    func setupZoomPanGesture() -> Disposable {
        self.isUserInteractionEnabled = false
        return self.rx.panGesture(minimumNumberOfTouches: 2, maximumNumberOfTouches: 2, configuration: { recognizer, delegate in
            delegate.simultaneousRecognitionPolicy = .custom { gesture, other in
                return other is UIPinchGestureRecognizer
            }
            
        })
            .bind { [weak self] gesture in
                guard let strongSelf = self else { return }
                if gesture.state == .began {
                    originCenter = gesture.view?.center
                } else if isZooming, gesture.state == .changed {
                    let translation = gesture.translation(in: strongSelf.superview!)
                    if let view = gesture.view {
                        view.center = CGPoint(x:view.center.x + translation.x, y:view.center.y + translation.y)
                    }
                    if let coverView = zoomPinchCoverView {
                        coverView.cloneView.center = CGPoint(x:coverView.cloneView.center.x + translation.x, y:coverView.cloneView.center.y + translation.y)
                    }
                    gesture.setTranslation(.zero, in: strongSelf.superview)
                }
        }
    }
    
    @discardableResult
    func setupZoomPinchGesture() -> Disposable {
        self.isUserInteractionEnabled = true
        return self.rx.pinchGesture(configuration: { recognizer, delegate in
            delegate.simultaneousRecognitionPolicy = .custom { gesture, other in
                return false
            }
        })
            .bind { gesture in
                guard let view = gesture.view as? UIImageView else { return }
                
                if gesture.state == .began || gesture.state == .changed {
                    if gesture.state == .began {
                        isZooming = true
                        if let coverView = zoomPinchCoverView {
                            coverView.removeFromSuperview()
                        }
                        if let keyWindow = UIApplication.shared.keyWindow {
                            let coverFrame = keyWindow.convert(view.frame, from: view.superview!)
                            let coverView = UIImageView(frame: coverFrame)
                            coverView.image = view.image
                            coverView.contentMode = view.contentMode
                            zoomPinchCoverView = ZoomPinchCoverView(targetView: coverView)
                            zoomPinchCoverView!.frame = UIScreen.main.bounds
                            keyWindow.addSubview(zoomPinchCoverView!)
                        }
                    }
                    
                    let pinchCenter = CGPoint(x: gesture.location(in: view).x - view.bounds.midX, y: gesture.location(in: view).y - view.bounds.midY)
                    let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                        .scaledBy(x: gesture.scale, y: gesture.scale)
                        .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
                    
                    let currentScale = view.frame.size.width / view.bounds.size.width
                    let newScale = min(max(currentScale * gesture.scale, 1.0), 3.0)
                    
                    if let coverView = zoomPinchCoverView {
                        if newScale == 1 {
                            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                            view.transform = transform
                            coverView.cloneView.transform = transform
                        } else if newScale < 3 {
                            view.transform = transform
                            coverView.cloneView.transform = transform
                        }
                        gesture.scale = 1
                        
                        // If you want to adjust a degree of fading, change a divider 1.3
                        coverView.bgView.backgroundColor = UIColor(hexString: "0x000000").withAlphaComponent((newScale - 1.0) / 1.3)
                    }
                    
                } else if gesture.state == .ended || gesture.state == .failed || gesture.state == .cancelled {
                    if let coverView = zoomPinchCoverView {
                        UIView.animate(withDuration: 0.3, animations: {
                            view.transform = CGAffineTransform.identity
                            coverView.cloneView.transform = CGAffineTransform.identity
                            coverView.bgView.alpha = 0.0
                            
                            if let center = originCenter {
                                view.center = center
                                coverView.cloneView.center = view.superview!.convert(center, to: coverView)
                            }
                            
                        }, completion: { finished in
                            coverView.removeFromSuperview()
                            zoomPinchCoverView = nil
                            originCenter = nil
                            isZooming = false
                        })
                    }
                }
        }
    }
}

private class ZoomPinchCoverView: UIView {
    let bgView = UIView()
    var cloneView: UIImageView! {
        return _cloneView
    }
    private let _cloneView: UIImageView!
    
    init(targetView: UIImageView) {
        _cloneView = targetView
        super.init(frame: .zero)
        
        self.isUserInteractionEnabled = false
        _cloneView.isUserInteractionEnabled = false
        
        self.addSubview(bgView)
        self.addSubview(_cloneView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.frame = self.bounds
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}

extension UIDevice {
    @objc var isSimulator: Bool {
        #if arch(i386) || arch(x86_64)
            return true
        #else
            return false
        #endif
    }
}

extension Data {
    func write(name: String) -> URL {
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name)
        try! write(to: url, options: .atomicWrite)
        return url
    }
}

extension URL {
    static var documentsDirectory: URL {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return try! documentsDirectory.asURL()
    }
    
    static func urlInDocumentsDirectory(with filename: String) -> URL {
        return documentsDirectory.appendingPathComponent(filename)
    }
}

extension UIViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 30 // replace 30 for your max length value
    }
}

extension NSNumber {
    @objc func getSuppportCountAsK() -> String {
        let selfStr = self.stringValue
        if selfStr.count > 3 {
            let endIndex = selfStr.index(selfStr.endIndex, offsetBy: -3)
            let truncated = selfStr.substring(to: endIndex)
            return "\(truncated)K"
        } else {
            return self.stringValue
        }
    }
}

extension UITapGestureRecognizer {
    
    @objc func didTapAttributedTextInTextView(label: UITextView, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        // textContainer.lineBreakMode = label.lineBreakMode
        //textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y:
            locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter + 5, targetRange)
    }
    
    @objc func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        // textContainer.lineBreakMode = label.lineBreakMode
        //textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y:
            locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter + 5, targetRange)
    }
}

extension NSLayoutConstraint {
    
    override open var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}

extension URL {
    func get(completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: self) {
            completion($0, $1, $2)
        }.resume()
    }
}

extension String {
    func heightOf(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func trim() -> String
    {
        let cs = CharacterSet.init(charactersIn: ", ")
        return self.trimmingCharacters(in: cs)
    }
    
    func toDate(dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date: Date? = dateFormatter.date(from: self)
        return date
    }
    
    func toBool() -> Bool {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return false
        }
    }
}

fileprivate extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension UIFont {
    
    /**
     Will return the best approximated font size which will fit in the bounds.
     If no font with name `fontName` could be found, nil is returned.
     */
    static func bestFitFontSize(for text: String, in bounds: CGRect, fontName: String) -> CGFloat? {
        var maxFontSize: CGFloat = 32.0 // UIKit best renders with factors of 2
        guard let maxFont = UIFont(name: fontName, size: maxFontSize) else {
            return nil
        }
        
        let textWidth = text.width(withConstraintedHeight: bounds.height, font: maxFont)
        let textHeight = text.height(withConstrainedWidth: bounds.width, font: maxFont)
        
        // Determine the font scaling factor that should allow the string to fit in the given rect
        let scalingFactor = min(bounds.width / textWidth, bounds.height / textHeight)
        
        // Adjust font size
        maxFontSize *= scalingFactor
        
        return floor(maxFontSize)
    }
    
}

extension UILabel {
    /// Will auto resize the contained text to a font size which fits the frames bounds
    /// Uses the pre-set font to dynamicly determine the proper sizing
    @objc func fitTextToBounds() {
        guard let text = text, let currentFont = font else { return }
        
        if let dynamicFontSize = UIFont.bestFitFontSize(for: text, in: bounds, fontName: currentFont.fontName) {
            font = UIFont(name: currentFont.fontName, size: dynamicFontSize)
        }
    }
}

extension UIImageView {
    
    @objc func roundedImage() {
        self.layer.cornerRadius = screenWidth * 0.6 / 10 / 2
        self.clipsToBounds = true
    }
    
    @objc func load(challengeId: String, challengerId: String) {
        if dummyServiceCall == false {
            self.showBlurLoader()
            let url = URL(string: downloadImageURL + "?challengeId=\(challengeId)&memberId=\(challengerId)")
            if ImageService.cached(withURL: url!) {
                self.image = ImageService.fromCache(withURL: url!)
            } else {
                self.showBlurLoader()
                self.pin_setImage(from: url!) { (result) in
                    if let image = self.image {
                        self.removeBluerLoader()
                        ImageService.cache(withURL: url!, image: image)
                    }
                }
            }
            self.removeBluerLoader()
            /*if let urlOfImage = url {
                ImageService.getImage(withURL: urlOfImage) { image in
                    if image != nil {
                        self.image = image
                    }
                }
            }*/
        }
    }
    
    @objc func loadByObjectId(objectId: String) {
        if dummyServiceCall == false {
            let url = URL(string: downloadProofImageByObjectIdURL + "?objectId=\(objectId)")
            if ImageService.cached(withURL: url!) {
                self.image = ImageService.fromCache(withURL: url!)
            } else {
                self.showBlurLoader()
                self.pin_setImage(from: url!) { (result) in
                    if let image = self.image {
                        self.removeBluerLoader()
                        ImageService.cache(withURL: url!, image: image)
                    }
                }
            }
            /*if let urlOfImage = url {
             ImageService.getImage(withURL: urlOfImage) { image in
             if image != nil {
             self.image = image
             }
             }
             }*/
        }
    }
    
    @objc func load(url: URL) {
        if dummyServiceCall == false {
            if ImageService.cached(withURL: url) {
                self.image = ImageService.fromCache(withURL: url)
            } else {
                self.showBlurLoader()
                self.pin_setImage(from: url) { (result) in
                    if let image = self.image {
                        self.removeBluerLoader()
                        ImageService.cache(withURL: url, image: image)
                    }
                }
            }
            /*if let urlOfImage = url {
             ImageService.getImage(withURL: urlOfImage) { image in
             if image != nil {
             self.image = image
             }
             }
             }*/
        }
    }
}

// var avPlayer : AVPlayer = AVPlayer()
extension AVPlayerLayer {
    @objc func load(challengeId: String, challengerId: String, play: Bool) {
        loadPlayer(challengeId: challengeId, challengerId: challengerId, volume: volume, play: play)
    }
    
    @objc func loadWithZeroVolume(challengeId: String, challengerId: String, play: Bool) {
        loadPlayer(challengeId: challengeId, challengerId: challengerId, volume: 0, play: play)
    }
    
    func loadPlayer(challengeId: String, challengerId: String, volume: Float, play: Bool) {
        if dummyServiceCall == false {
            let url = URL(string: downloadVideoURL + "?challengeId=\(challengeId)&memberId=\(challengerId)")
            if let urlOfImage = url {
                VideoService.getVideo(withURL: urlOfImage, completion: { (videoData) in
                    if let video = videoData {
                        DispatchQueue.main.async {
                            // let item = AVPlayerItem.init(url: video)
                            let avPlayer = AVPlayer(url: video)
                            avPlayer.actionAtItemEnd = .none
                            avPlayer.volume = volume
                            self.player = avPlayer
                            self.player?.automaticallyWaitsToMinimizeStalling = false
                            if play {
                                self.player?.playImmediately(atRate: 1.0)
                            }
                        }
                        NotificationCenter.default.addObserver(self, selector:  #selector(self.playerDidFinishPlaying), name:   NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
                        NotificationCenter.default.addObserver(self, selector:  #selector(self.resumeDidFinishPlaying), name:   Notification.Name.UIApplicationWillEnterForeground, object: nil)
                    }
                })
            }
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        let p: AVPlayerItem = note.object as! AVPlayerItem
        p.seek(to: kCMTimeZero, completionHandler: nil)
    }
    
    @objc func resumeDidFinishPlaying(note: NSNotification) {
        self.player?.play()
    }
}

extension UIColor {
    
    @objc static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}

extension UIRefreshControl {
    @objc func beginRefreshingManually() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: true)
        }
        beginRefreshing()
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

public enum Model : String {
    case simulator     = "simulator/sandbox",
    iPod1              = "iPod 1",
    iPod2              = "iPod 2",
    iPod3              = "iPod 3",
    iPod4              = "iPod 4",
    iPod5              = "iPod 5",
    iPad2              = "iPad 2",
    iPad3              = "iPad 3",
    iPad4              = "iPad 4",
    iPad5              = "iPad 5",
    iPhone4            = "iPhone 4",
    iPhone4S           = "iPhone 4S",
    iPhone5            = "iPhone 5",
    iPhone5S           = "iPhone 5S",
    iPhone5C           = "iPhone 5C",
    iPadMini1          = "iPad Mini 1",
    iPadMini2          = "iPad Mini 2",
    iPadMini3          = "iPad Mini 3",
    iPadAir1           = "iPad Air 1",
    iPadAir2           = "iPad Air 2",
    iPadPro9_7         = "iPad Pro 9.7\"",
    iPadPro9_7_cell    = "iPad Pro 9.7\" cellular",
    iPadPro12_9        = "iPad Pro 12.9\"",
    iPadPro12_9_cell   = "iPad Pro 12.9\" cellular",
    iPadPro2_12_9      = "iPad Pro 2 12.9\"",
    iPadPro2_12_9_cell = "iPad Pro 2 12.9\" cellular",
    iPhone6            = "iPhone 6",
    iPhone6plus        = "iPhone 6 Plus",
    iPhone6S           = "iPhone 6S",
    iPhone6Splus       = "iPhone 6S Plus",
    iPhoneSE           = "iPhone SE",
    iPhone7            = "iPhone 7",
    iPhone7plus        = "iPhone 7 Plus",
    iPhone8            = "iPhone 8",
    iPhone8plus        = "iPhone 8 Plus",
    iPhoneX            = "iPhone X",
    unrecognized       = "?unrecognized?"
}

// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
//MARK: UIDevice extensions
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#

public extension UIDevice {
    public var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
                
            }
        }
        var modelMap : [ String : Model ] = [
            "i386"      : .simulator,
            "x86_64"    : .simulator,
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad2,5"   : .iPadMini1,
            "iPad2,6"   : .iPadMini1,
            "iPad2,7"   : .iPadMini1,
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPad4,2"   : .iPadAir1,
            "iPad5,4"   : .iPadAir2,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad6,3"   : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7_cell,
            "iPad6,12"  : .iPad5,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9_cell,
            "iPad7,1"   : .iPadPro2_12_9,
            "iPad7,2"   : .iPadPro2_12_9_cell,
            "iPhone7,1" : .iPhone6plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6Splus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,2" : .iPhone7plus,
            "iPhone9,3" : .iPhone7,
            "iPhone9,4" : .iPhone7plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,2" : .iPhone8plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,4" : .iPhone8,
            "iPhone10,5" : .iPhone8plus,
            "iPhone10,6" : .iPhoneX
        ]
        
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                        return simModel
                    }
                }
            }
            return model
        }
        return Model.unrecognized
    }
}
