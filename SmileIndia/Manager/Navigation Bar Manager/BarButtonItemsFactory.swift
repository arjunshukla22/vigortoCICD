import UIKit

class BarButtonItemsFactory: NSObject {

    public var manager: NavigationBarManager?
    
    private let buttonWidth: CGFloat = 60
    private let buttonHeight: CGFloat = 40
    private var buttonFrame: CGRect {
        return CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
    }
    
    public func barButtonItem(for dictionary: [String: String], with viewController: UIViewController) -> UIBarButtonItem? {
        let selector = NSSelectorFromString((dictionary["key"]!.appending(":")))
        let barButtonItem = self.perform(selector, with: viewController)
        return barButtonItem?.takeUnretainedValue() as? UIBarButtonItem
    }
    
    //MARK:- BarButtonItems
    @objc internal func emptyTextBtn(_ viewController: UIViewController) -> UIBarButtonItem {
        let button = UIButton(frame: buttonFrame)
        button.setTitle("", for: .normal)
        button.setTitleColor(.white, for: .normal)
        let nextButton = UIBarButtonItem()
        nextButton.customView = button
        nextButton.isEnabled = true
        return nextButton
    }
    
    @objc internal func home(_ viewController: UIViewController) -> UIBarButtonItem {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 116, height: 13))
        button.setImage(UIImage.init(named: "Logo"), for: .normal)
        button.isUserInteractionEnabled = false
        let nextButton = UIBarButtonItem()
        nextButton.customView = button
        return nextButton
    }
    
    @objc internal func backButton(_ viewController: UIViewController) -> UIBarButtonItem {
        let action = Selector(("didTapBackButton"))
        let image = UIImage.init(named: "Back")
        return barButton(withImage: image!,titleColor: UIColor.black, target: viewController, action: action, alignment: .left)
    }
    
    @objc internal func settingsButton(_ viewController: UIViewController) -> UIBarButtonItem {
        let action = Selector(("didTapSettingsButton"))
        let image = UIImage.init(named: "setting")
        return barButton(withImage: image!,titleColor: UIColor.black, target: viewController, action: action, alignment: .right)
    }
    
    @objc internal func profileButton(_ viewController: UIViewController) -> UIBarButtonItem {
        let action = Selector(("didTapProfileButton"))
        let image = UIImage.init(named: "profileUnselected")
        return barButton(withImage: image!,titleColor: UIColor.black, target: viewController, action: action, alignment: .right)
    }
    @objc internal func filterButton(_ viewController: UIViewController) -> UIBarButtonItem {
        let action = Selector(("didTapFilterButton"))
        let image = UIImage.init(named: "filterUnselected")
        return barButton(withImage: image!,titleColor: UIColor.black, target: viewController, action: action, alignment: .right)
    }
    @objc internal func searchButton(_ viewController: UIViewController) -> UIBarButtonItem {
        let action = Selector(("didTapSearchButton"))
        let image = UIImage.init(named: "searchUnselected")
        let image2 = UIImage.init(named: "searchSelected")
        return barButton(withImage: image!, selectedImage: image2 ,titleColor: UIColor.black, target: viewController, action: action, alignment: .right)
    }
    @objc internal func doneButton(_ viewController: UIViewController) -> UIBarButtonItem{
        let action = #selector(CustomTextfield.didTapDoneButton)
        let title = "Done"
        return barButton( title: title,titleColor: UIColor.black, target: viewController, action: action, alignment: .right)
    }
    

    //Helpers
    private func barButton(withImage image: UIImage? = nil,selectedImage: UIImage? = nil,
                           tintColor: UIColor? = nil,
                           title: String? = nil,
                           titleColor: UIColor? = nil,
                           target: UIViewController,
                           action: Selector,
                           alignment: UIControl.ContentHorizontalAlignment) -> UIBarButtonItem
    {
        let button = UIButton(frame: buttonFrame)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.setImage(image, for: .normal)
        if let tint = tintColor {
            button.tintColor = tint
        }
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)

        button.contentHorizontalAlignment = alignment
        button.backgroundColor = .clear
        button.imageView?.contentMode = .scaleAspectFit

        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.isEnabled = true
        return barButton
    }

    private func barButton(withTitle title: String,
                           titleColor: UIColor,
                           target: UIViewController,
                           action: Selector,
                           alignment: UIControl.ContentHorizontalAlignment) -> UIBarButtonItem
    {
        let button = UIButton(frame: buttonFrame)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.init(style: .bold, size: .h7)
        button.contentHorizontalAlignment = alignment
        button.backgroundColor = .clear
        button.imageView?.contentMode = .scaleAspectFit

        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.isEnabled = true
        return barButton
    }
}
