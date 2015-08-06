//
//  FBSideMenuViewController.swift
//  FBNavigationPattern
//
//  Created by Florent TM on 31/07/2015.
//  Copyright © 2015 Florent THOMAS-MOREL. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Enum

public enum FBSideMenuMode:Int{
    case SwipeToReach
    case SwipeFromScratch
}

//MARK: - FBSideMenuViewController Class

public class FBSideMenuViewController: UIViewController, FBMenuDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate{
        
    //MARK: - Attributes
    
    @IBOutlet weak var tableView: UITableView!
    private var images:[UIImage]!
    private var viewControllers:[UIViewController]!
    private var animator:UIDynamicAnimator!
    
    public var navigationContainer:FBNavigationController!
    public var pictoAnimation:((desactive:UIImageView?, active:UIImageView?, index:Int) -> Void)?
    
    
    //MARK: - Init
    
    public init(viewsControllers:[UIViewController], withImages images:[UIImage], forLimit limit:CGFloat, withMode mode:FBSideMenuMode){
        self.images = images
        self.viewControllers = viewsControllers
        super.init(nibName: "FBSideMenuViewController", bundle: NSBundle(forClass: FBSideMenuViewController.self))
        self.navigationContainer = FBNavigationController(numberOfItem: min(images.count,viewControllers.count), withMaxLimit: limit, andMode: mode)
        self.navigationContainer.menuDelegate = self
        self.navigationContainer.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //MARK: - Override
    
    override public func viewWillAppear(animated: Bool) {
        self.tableView.backgroundColor = self.view.backgroundColor
        self.view.addSubview(navigationContainer.view)
        self.addChildViewController(navigationContainer)
        self.navigationContainer.view.addSubview(viewControllers.first!.view)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "FBTableViewCell", bundle: NSBundle(forClass: FBTableViewCell.self)), forCellReuseIdentifier: kFBCellIdentifier)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - FBMenuDelegate
    
    func didChangeCurrentIndex(lastIndex lastIndex: Int, toNewIndex index: Int) {

        let lastCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: lastIndex, inSection: 0)) as? FBTableViewCell
        let newCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? FBTableViewCell
        
        
        if let _ = pictoAnimation {
            UIView.animateWithDuration(0.25) { () -> Void in
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), atScrollPosition: .Middle, animated: true)
                self.pictoAnimation!(desactive: lastCell?.pictoView, active: newCell?.pictoView, index:index)
            }
        }else{
            UIView.animateWithDuration(0.25) { () -> Void in
                lastCell?.pictoView.alpha = 0.2
                newCell?.pictoView.alpha = 1
                lastCell?.pictoView.transform = CGAffineTransformMakeScale(0.8,0.8);
                newCell?.pictoView.transform = CGAffineTransformMakeScale(1,1);
            }
        }
        
        if lastIndex < index || self.navigationContainer.mode == .SwipeFromScratch {
            self.navigationContainer.view.addSubview(self.viewControllers[index].view)

        }else if !(lastIndex == index) {
           self.viewControllers[lastIndex].view.removeFromSuperview()
        }
    }
    
    func didFailToOpenMenu(){
        
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        let collisionBehaviour = UICollisionBehavior(items: [self.navigationContainer.view])
        collisionBehaviour.addBoundaryWithIdentifier("frame-left", fromPoint: CGPointMake(-1, 0), toPoint: CGPointMake(-1, self.view.frame.size.height))
        self.animator.addBehavior(collisionBehaviour)
        
        let gravityBehaviour = UIGravityBehavior(items: [self.navigationContainer.view])
        gravityBehaviour.gravityDirection = CGVectorMake(-3, 0)
        self.animator.addBehavior(gravityBehaviour)

        
        let itemBehaviour = UIDynamicItemBehavior(items: [self.navigationContainer.view])
        itemBehaviour.elasticity = 0.50
        self.animator.addBehavior(itemBehaviour)
    }
    
    
    //MARK: - UINavigationControllerDelegate
    
    public func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        let gesture = UIPanGestureRecognizer(target: self.navigationContainer, action: "handlePan:")
        viewController.view.addGestureRecognizer(gesture)
    }
    
    //MARK: - UITableViewDataSource
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:FBTableViewCell!
        if let tmp = tableView.dequeueReusableCellWithIdentifier(kFBCellIdentifier) as? FBTableViewCell{
            cell = tmp
        }else{
            cell = FBTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: kFBCellIdentifier)
        }
        cell.pictoView.contentMode = .ScaleAspectFill
        cell.pictoView.image = images[indexPath.row]
        
        if let _ = pictoAnimation {
            self.pictoAnimation!(desactive: cell.pictoView, active: nil, index:indexPath.row)
        }else{
            cell.pictoView.alpha = 0.2
            cell.pictoView.transform = CGAffineTransformMakeScale(0.8,0.8);
        }
        cell.backgroundColor = self.view.backgroundColor
        return cell
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.images.count
    }
    
    
    //MARK: - UITableViewDelegate
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

}