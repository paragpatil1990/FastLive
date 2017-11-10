//
//  UIImage_Extension.swift
//  MatchpointGPS
//
//  Created by Amrit Singh on 8/19/17.
//  Copyright © 2017 foxsolution. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage
{
    static var connectionlost:UIImage
    {
        get{return #imageLiteral(resourceName: "icon-connectionlost-red")}
    }
    static var moving:UIImage
    {
        get{return #imageLiteral(resourceName: "icon-moving-orange")}
    }
    static var idel:UIImage
    {
        get{return #imageLiteral(resourceName: "icon-idel-blue")}
    }
    static var parked:UIImage
    {
        get{return #imageLiteral(resourceName: "icon-parked-black")}
    }
    
    static var car:UIImage
    {
        get{return #imageLiteral(resourceName: "car.png")}
    }
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1))
    {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    
    static func defaultMenuImage() -> UIImage
    {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 24, height: 22), false, 0.0)
        
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 24, height: 2)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 24, height: 2)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 24, height: 2)).fill()
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return defaultMenuImage;
    }
    
    static func defaultCloseImage() -> UIImage
    {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 20, height: 20), false, 0.0)
        
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setFill()
        
        let aPath = UIBezierPath()
        aPath.move(to: CGPoint(x:2, y:2))
        aPath.addLine(to: CGPoint(x:18, y:18))
        aPath.lineWidth = 2
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setStroke()
        aPath.stroke()
        aPath.fill()
        aPath.close()
        
        let bPath = UIBezierPath()
        bPath.move(to: CGPoint(x:18, y:2))
        bPath.addLine(to: CGPoint(x:2, y:18))
        bPath.lineWidth = 2
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setStroke()
        bPath.stroke()
        bPath.fill()
        bPath.close()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return defaultMenuImage;
    }

    static func dotLineImage(size : CGSize) -> UIImage
    {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1).setFill()
        
        let lineWidth: CGFloat = 2.0;
        let lineX = ((size.width/2)-(lineWidth))
        let aPath = UIBezierPath()
        aPath.move(to: CGPoint(x:lineX, y:0))
        aPath.addLine(to: CGPoint(x:lineX, y:size.height))
        aPath.lineWidth = lineWidth
        #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1).setStroke()
        aPath.stroke()
        aPath.fill()
        aPath.close()
        
        let radius: CGFloat = 4.0;
        let circleX = ((size.width/2)-(radius/2))
        let circleY = ((size.height/2)-(radius/2))
        let circlePath = UIBezierPath()
        circlePath.addArc(withCenter: CGPoint(x: circleX,y: circleY), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1).setStroke()
        circlePath.stroke()
        circlePath.fill()
        circlePath.close()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return defaultMenuImage;
    }

}
