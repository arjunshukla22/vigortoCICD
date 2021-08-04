import UIKit

fileprivate let backButtonText  = ""
fileprivate let kLeftButtons  = "left"
fileprivate let kRightButtons = "right"

enum NavigationBarType {
    case home
    case back
    case type_0
     case type_1
}

class NavigationBarManager: NSObject {
    
    public var barItemsFactory: BarButtonItemsFactory?

    class var shared: NavigationBarManager {
        struct Static {
            static let instance = NavigationBarManager()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        self.barItemsFactory = BarButtonItemsFactory()
        self.barItemsFactory?.manager = self
    }
    
    //MARK:- Public Functions
    @available(*, deprecated, message: "Use applyProperties(for:in:withTitleView:) instead")
    public func applyProperties(key: NavigationBarType, viewController: UIViewController, titleView: UIView? = nil) {
        applyProperties(for: key, in: viewController, withTitleView: titleView)
    }
    
    public func applyProperties(for type: NavigationBarType, in viewController: UIViewController, withTitleView titleView: UIView? = nil) {
        if titleView != nil {
            viewController.navigationItem.titleView = titleView
        }
        let navBarDictionary = navigationBarDictionary(for: type)
        if navBarDictionary[kLeftButtons] != nil {
            let leftBarButtons = barButtonItems(from: navBarDictionary[kLeftButtons] as! [[String: String]], for: viewController)
            viewController.navigationItem.hidesBackButton = true
            viewController.navigationItem.setLeftBarButtonItems(leftBarButtons, animated: true)
        }
        
        if navBarDictionary[kRightButtons] != nil {
            let rightBarButtons = barButtonItems(from: navBarDictionary[kRightButtons] as! [[String: String]], for: viewController)
            viewController.navigationItem.setRightBarButtonItems(rightBarButtons, animated: true)
        }
    }
    
    public func  changeSearchButton(_ viewController: UIViewController){
        for i in viewController.navigationItem.rightBarButtonItems ?? []{
            let buttonImage = (i.customView as? UIButton)?.image(for: .normal)
            if buttonImage == UIImage.init(named: "searchUnselected"){
                (i.customView as? UIButton)?.setImage(UIImage.init(named: "searchSelected"), for: .normal)
            }else if buttonImage == UIImage.init(named: "searchSelected"){
                (i.customView as? UIButton)?.setImage(UIImage.init(named: "searchUnselected"), for: .normal)
            }
        }
    }
    
    fileprivate func backButtonSettings(for viewController: UIViewController) {
        viewController.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "backArrow")
        viewController.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backArrow")
        
        let backItem = UIBarButtonItem(title: backButtonText, style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = backItem
    }
    
    //MARK:- Private Functions - Navigation Bar methods.
    fileprivate func navigationBarDictionary(for type: NavigationBarType) -> [String: Any] {
        switch type {
        case .home:
            return [kLeftButtons: [["key": "home"]],
                    kRightButtons:  [["key": "searchButton"],["key": "filterButton"],["key": "profileButton"]]]
        case .back:
            return [kLeftButtons: [["key": "backButton"]],
                    kRightButtons:  []]
        case .type_0:
            return [kLeftButtons: [["key": "backButton"]],
                    kRightButtons:  [["key": "doneButton"]]]
        case .type_1:
            return [kLeftButtons:   [["key": "backButton"]],
                    kRightButtons:  [["key": "settingsButton"]]]
        }
    }

    //MARK:- Utitility methods.
    fileprivate func barButtonItems(from dictionaryArray: [[String: String]], for viewController: UIViewController) -> [UIBarButtonItem] {
        guard dictionaryArray.count > 0 else {
            return []
        }
        var barButtons: [UIBarButtonItem] = []
        let flexibleButton =  UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        for dict in dictionaryArray {
            if let barButtonItem = barItemsFactory?.barButtonItem(for: dict, with: viewController) {
                barButtons.append(barButtonItem)
                barButtons.append(flexibleButton)
            }
        }
        return barButtons
    }
}
