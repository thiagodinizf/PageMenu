//
//  MenuItemView.swift
//  PageMenuConfigurationDemo
//
//  Created by Matthew York on 3/5/17.
//  Copyright © 2017 Aeron. All rights reserved.
//

import UIKit

extension MenuItemView {
    private func configureTabView() {
        guard let pageMenu = pageMenu,
            let controller = controller,
            let index = index else {
                return
        }
        
        var title: String?
        if let menuItemController = controller as? CAPSPageMenuItemController {
            if let imageTab = menuItemController.imageTab {
                imageTab.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
                addSubview(imageTab)
                return
            } else if let titleTab =  menuItemController.titleTab {
                title = titleTab
            }
        }
        
        // Configure menu item label font if font is set by user
        titleLabel!.font = pageMenu.configuration.menuItemFont
    
        titleLabel!.textAlignment = NSTextAlignment.center
        titleLabel!.textColor = pageMenu.configuration.unselectedMenuItemLabelColor
        
        titleLabel!.adjustsFontSizeToFitWidth = pageMenu.configuration.titleTextSizeBasedOnMenuItemWidth
    
        // Set title depending on if controller has a title set
        if title != nil {
            titleLabel!.text = title!
        } else if controller.title != nil {
            titleLabel!.text = controller.title!
        } else {
            titleLabel!.text = "Menu \(Int(index) + 1)"
        }
        addSubview(titleLabel!)
    }
}
class MenuItemView: UIView {
    // MARK: - Menu item view
    
    var titleLabel : UILabel?
    var menuItemSeparator : UIView?
    
    var pageMenu: CAPSPageMenu?
    var controller: UIViewController?
    var index: CGFloat?
    
    func setUpMenuItemView(_ menuItemWidth: CGFloat, menuScrollViewHeight: CGFloat, indicatorHeight: CGFloat, separatorPercentageHeight: CGFloat, separatorWidth: CGFloat, separatorRoundEdges: Bool, menuItemSeparatorColor: UIColor) {
        titleLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: menuItemWidth, height: menuScrollViewHeight - indicatorHeight))
        
        menuItemSeparator = UIView(frame: CGRect(x: menuItemWidth - (separatorWidth / 2), y: floor(menuScrollViewHeight * ((1.0 - separatorPercentageHeight) / 2.0)), width: separatorWidth, height: floor(menuScrollViewHeight * separatorPercentageHeight)))
        menuItemSeparator!.backgroundColor = menuItemSeparatorColor
        
        if separatorRoundEdges {
            menuItemSeparator!.layer.cornerRadius = menuItemSeparator!.frame.width / 2
        }
        
        menuItemSeparator!.isHidden = true
        self.addSubview(menuItemSeparator!)
    }
    
    func setTitleText(_ text: NSString) {
        if titleLabel != nil {
            titleLabel!.text = text as String
            titleLabel!.numberOfLines = 0
            titleLabel!.sizeToFit()
        }
    }
    
    func configure(for pageMenu: CAPSPageMenu, controller: UIViewController, index: CGFloat) {
        
        self.pageMenu = pageMenu
        self.controller = controller
        self.index = index
        
        if pageMenu.configuration.useMenuLikeSegmentedControl {
            //**************************拡張*************************************
            if pageMenu.menuItemMargin > 0 {
                let marginSum = pageMenu.menuItemMargin * CGFloat(pageMenu.controllerArray.count + 1)
                let menuItemWidth = (pageMenu.view.frame.width - marginSum) / CGFloat(pageMenu.controllerArray.count)
                self.setUpMenuItemView(menuItemWidth, menuScrollViewHeight: pageMenu.configuration.menuHeight, indicatorHeight: pageMenu.configuration.selectionIndicatorHeight, separatorPercentageHeight: pageMenu.configuration.menuItemSeparatorPercentageHeight, separatorWidth: pageMenu.configuration.menuItemSeparatorWidth, separatorRoundEdges: pageMenu.configuration.menuItemSeparatorRoundEdges, menuItemSeparatorColor: pageMenu.configuration.menuItemSeparatorColor)
            } else {
                self.setUpMenuItemView(CGFloat(pageMenu.view.frame.width) / CGFloat(pageMenu.controllerArray.count), menuScrollViewHeight: pageMenu.configuration.menuHeight, indicatorHeight: pageMenu.configuration.selectionIndicatorHeight, separatorPercentageHeight: pageMenu.configuration.menuItemSeparatorPercentageHeight, separatorWidth: pageMenu.configuration.menuItemSeparatorWidth, separatorRoundEdges: pageMenu.configuration.menuItemSeparatorRoundEdges, menuItemSeparatorColor: pageMenu.configuration.menuItemSeparatorColor)
            }
            //**************************拡張ここまで*************************************
        } else {
            self.setUpMenuItemView(pageMenu.configuration.menuItemWidth, menuScrollViewHeight: pageMenu.configuration.menuHeight, indicatorHeight: pageMenu.configuration.selectionIndicatorHeight, separatorPercentageHeight: pageMenu.configuration.menuItemSeparatorPercentageHeight, separatorWidth: pageMenu.configuration.menuItemSeparatorWidth, separatorRoundEdges: pageMenu.configuration.menuItemSeparatorRoundEdges, menuItemSeparatorColor: pageMenu.configuration.menuItemSeparatorColor)
        }
        
       configureTabView()
        
        // Add separator between menu items when using as segmented control
        if pageMenu.configuration.useMenuLikeSegmentedControl {
            if Int(index) < pageMenu.controllerArray.count - 1 {
                self.menuItemSeparator!.isHidden = false
            }
        }
    }
}
