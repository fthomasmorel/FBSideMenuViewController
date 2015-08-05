//
//  FBNavigationController.swift
//  FBNavigationPattern
//
//  Created by Florent TM on 03/08/2015.
//  Copyright © 2015 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Protocol

protocol FBMenuDelegate{
    func didChangeCurrentIndex(lastIndex lastIndex:Int, toNewIndex index:Int)
    func didFailToOpenMenu()
}

//MARK: - FBNavigationController Class

class FBNavigationController:UINavigationController{
    
    
    //MARK: - Attributes
    
    private let kWidthMenu:CGFloat = 90
    private var kLimit:CGFloat!
    private var kMaxLimit:CGFloat!
    private var step:CGFloat!
    private var currentIndex:Int!
    private var savedIndex:Int!
    private var numberOfItems:Int!
    private var indexHasChanged:Bool!
    private lazy var condition:(lastIndex:Int, newIndex:Int) -> Bool = { (lastIndex:Int, newIndex:Int) -> Bool in
        if(self.mode == .SwipeToReach){
            return (lastIndex != newIndex && newIndex >= self.savedIndex) || (newIndex == self.numberOfItems-1 && self.savedIndex == self.numberOfItems-1)
        }else{
            return (lastIndex != newIndex)
        }
    }
    
    var menuDelegate:FBMenuDelegate?
    var mode:FBSideMenuMode!
    
    
    //MARK: - Init
    
    init(numberOfItem number:Int, withMaxLimit limit:CGFloat, andMode mode:FBSideMenuMode){
        self.currentIndex = 0
        self.numberOfItems = number
        self.kLimit = CGFloat(Double(limit)*2.0/M_PI)
        self.kMaxLimit = limit
        self.step = (ceil(kLimit)-kWidthMenu+20)/CGFloat(numberOfItems)
        self.mode = mode
        super.init(nibName: "FBNavigationController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan:"))
        self.setNavigationBarHidden(true, animated: false)
    }
    
    
    //MARK: - Private Functions
    
    private func computeIndex(){

        print(self.view.frame.origin.x)
        let lastIndex = self.currentIndex
        let newIndex = Int(self.view.frame.origin.x < self.kWidthMenu-20 ? 0 : ((min(kMaxLimit-1,self.view.frame.origin.x) - (self.kWidthMenu-20))/self.step))
        print(self.view.frame.origin.x < self.kWidthMenu-20 ? 0 : ((min(kMaxLimit-1,self.view.frame.origin.x) - (self.kWidthMenu-20))/self.step))
        if condition(lastIndex: lastIndex, newIndex: newIndex){
            self.savedIndex = 0
            self.currentIndex = newIndex
            self.indexHasChanged = true
            menuDelegate?.didChangeCurrentIndex(lastIndex:lastIndex, toNewIndex:newIndex)
        }
    }
    
    @IBAction func handlePan(sender: AnyObject) {
        let recognizer = sender as! UIPanGestureRecognizer
        switch recognizer.state {
        case .Began:
            self.panDidStart(recognizer)
            break;
        case .Changed:
            self.panDidChange(recognizer)
            break;
        default:
            self.panDidEnd(recognizer)
            break;
        }
    }
    
    private func panDidStart(recognizer:UIPanGestureRecognizer){
        let frame = self.view.frame
        let x = recognizer.translationInView(self.view).x+frame.origin.x
        let y:CGFloat = 0.0
        recognizer.setTranslation(CGPointMake(x, y), inView: self.view)
        self.indexHasChanged = false
        self.savedIndex = self.currentIndex
    }
    
    private func panDidEnd(recognizer:UIPanGestureRecognizer){
        if self.view.frame.origin.x < kWidthMenu - 20 && !self.indexHasChanged{
            let velocity = recognizer.velocityInView(self.view)
            self.animateCloseMenu(velocity)
        }else{
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            })
        }
    }
    
    private func panDidChange(recognizer:UIPanGestureRecognizer){
        let translation = recognizer.translationInView(self.view)
        if translation.x >= kMaxLimit-1 {
            var frame = CGRectMake(kLimit, 0, self.view.frame.size.width, self.view.frame.size.height)
            frame.origin.x = kLimit
            self.view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
            self.computeIndex()
        }else if self.view.frame.origin.x >= 0 && translation.x > 0 {
            var frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            frame.origin.x += CGFloat(sin(Double(translation.x)/Double(kLimit)))*kLimit
            self.view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
            if self.view.frame.origin.x >= kWidthMenu - 20 {
                self.computeIndex()
            }
        }else{
            let frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            self.view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
            recognizer.setTranslation(CGPointMake(0, 0), inView: self.view)
        }
    }
    
    private func animateCloseMenu(velocity:CGPoint){
        menuDelegate?.didFailToOpenMenu()
    }
}