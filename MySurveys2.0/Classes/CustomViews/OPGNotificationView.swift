//
//  OPGNotificationView.swift
//  OPGNotificationBanner
//
//  Created by ThamaraiD on 16/11/16.
//  Copyright © 2016 OnePointGlobal. All rights reserved.
//

import Foundation
import UIKit

let notificationViewHeight :CGFloat = 45

enum AZNotificationType
{
    case upload,refresh,warning,message
}

enum NotificationColors :String
{
    case upload = "17BF30",
    refresh = "BF1525",
    Warning = "BF3E12",
    Message = "7F7978"
}

class OPGNotificationView : UIView
{
    var title = ""
    var referenceView = UIView()
    var showNotificationUnderNavigationBar = false
    var animator = UIDynamicAnimator()
    var gravity = UIGravityBehavior()
    var collision = UICollisionBehavior()
    var itemBehavior = UIDynamicItemBehavior()
    var notificationType = AZNotificationType.upload
    
    func initialisewithNavigation(title :String, referenceView :UIView, notificationType :AZNotificationType)
    {
        self.title = title
        self.referenceView = referenceView
        self.notificationType = notificationType
        self.showNotificationUnderNavigationBar = true
        self.alpha = 0.8
       // super.init(frame: CGRect(x: 0, y: 0, width: referenceView.bounds.size.width, height: notificationViewHeight))
        setup()
    }
    
    func hideNotification()
    {
        animator.removeBehavior(gravity)
        gravity = UIGravityBehavior(items: [self])
        gravity.gravityDirection = CGVector(dx: 0, dy: -1)
        animator.addBehavior(gravity)
    }
    
    func applyDynamics()
    {
        let boundaryYAxis :CGFloat = showNotificationUnderNavigationBar == true ? 1 : 1
        animator = UIDynamicAnimator(referenceView: referenceView)
        gravity = UIGravityBehavior(items:[self])
        collision = UICollisionBehavior(items: [self])
        itemBehavior = UIDynamicItemBehavior(items: [self])
        
        itemBehavior.elasticity = 0.5
        
        collision.addBoundary(withIdentifier: "AZNotificationBoundary" as NSCopying, from: CGPoint(x: 0, y: self.bounds.size.height * boundaryYAxis), to: CGPoint(x: referenceView.bounds.size.width,y: self.bounds.size.height * boundaryYAxis))
        
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        animator.addBehavior(itemBehavior)
        
        //Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(AZNotificationView.hideNotification), userInfo: nil, repeats: false)
    }
    
    func setup()
    {
        let screenBounds = UIScreen.main.bounds
        self.frame = CGRect(x: 0, y: showNotificationUnderNavigationBar == true ? 1 : -1 * notificationViewHeight, width: screenBounds.size.width, height: notificationViewHeight)
        
        setupNotificationType()
        
        let labelRect = CGRect(x: 5,y: 5, width: screenBounds.size.width-10, height: notificationViewHeight-10)
        
        let titleLabel = UILabel(frame: labelRect)
        titleLabel.text = title
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = NSTextAlignment.center
        
        addSubview(titleLabel)
    }
    
    func setupNotificationType()
    {
        switch notificationType
        {
        case .upload:
            backgroundColor = UIColor.darkGray
            
        case .refresh:
            backgroundColor = UIColor.green
            
        case .warning:
            backgroundColor = UIColor.red
            
        case .message:
            backgroundColor = UIColor.yellow
            
        }
        
    }
}
