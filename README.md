# FBSideMenuViewController
FBSideMenuViewController is a brand new way to interact with your side menu! The idea come from Benjamin Berger, you can find his work (and many others to his [Dribbble page](https://dribbble.com/benjaminberger))

![alternate text](https://d13yacurqjgara.cloudfront.net/users/374035/screenshots/1897399/navigation.gif)

Now you just have to pull the side menu till you selected the item you want. The more you pull the deeper item you'll have.

This is cool and much faster than pull off the menu and touch down the item ;)

## Install

### Using Pod

- In a terminal, in your new project, just run :

```sh
pod init
```
If you don't have the cocoapods command, just go [here]() and follow the steps

- Add the following lines to your Podfile between the ```do``` and the ```end``` keywords :

```ruby
use_frameworks!

pod 'FBSideMenuViewController', :git => 'https://github.com/fthomasmorel/FBSideMenuViewController.git'
```

- Go back to your terminal and run :

```sh
pod install
```

The ```pod install``` command will generate a ```.xcworkspace``` folder. Now you have to open and work on the workspace.

## Architecture

![Architecture](img/schemaArchitecture.png)

The ```FBSideMenuViewController``` is the back view container with the images items. In front of it you have the ```FBNavigationController``` which is a ```UINavigationController``` which will contains the several ViewController.

That's why you need an array of ```UIImage``` and an array of ```UIViewController```.

## Use

In your class, dont forget to import the pod with 

```swift
import FBSideMenuViewController
```

It's possible that xCode find an error on this new line. Don't give up, just clean and build, that should work.

### Instantiate a FBSideMenuViewController

To instantiate a FBSideMenuViewController you have to call the init function :

```swift
init(viewsControllers:[UIViewController], withImages images:[UIImage], forLimit limit:CGFloat, withMode mode:FBSideMenuMode)
```

This function take several parameters such as :

- ```viewController:[UIViewController]``` => An array of the viewController which will be display. You need to instiate every ViewController of your menu to get a glimpse every time the menu change the item.

- ```images:[UIImage]``` => An array of UIImage which will correspond to your menu item.

- ```limit:CGFloat``` => The asymptotic limit in pixel for your slide menu opening

- ```mode:FBSideMenuMode``` => You can choose the mode of the ```FBSideMenuViewController```. Let's have a look to the ```FBSideMenuMode``` enum : 

```swift
public enum FBSideMenuMode:Int{
    case SwipeToReach
    case SwipeFromScratch
}
```

In the ```SwipeToReach``` mode, once the user has selected an item, he or she will have to swipe to reach this item before choosing another one.

In the ```SwipeFromScratch``` mode, once the user has selected an item, when he will swipe to choose another one, he or she will start from scratch.

Just try it or ask me for me detail if you have any problem!


### Add the FBSideMenuViewController as the Initial View Controller

To do this you have to uncheck the box "Is intial View Controller" in your Storyboard and modify the ```didFinishLaunchingWithOptions``` function of the ```AppDelegate```.

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
	self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

	var viewControllers:[UIViewController] = []
   	viewControllers.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("vc1"))
 	viewControllers.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("vc2"))
  	viewControllers.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("vc3"))
 	viewControllers.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("vc4"))
        
        var images:[UIImage] = []
 	images.append(UIImage(named: "item1")!)
  	images.append(UIImage(named: "item2")!)
   	images.append(UIImage(named: "item3")!)
  	images.append(UIImage(named: "item4")!)

	let initialViewController = FBSideMenuViewController(viewsControllers: viewControllers, withImages: images, forLimit: 300, withMode: FBSideMenuMode.SwipeFromScratch)

	self.window?.rootViewController = initialViewController
	self.window?.makeKeyAndVisible()
	return true
}
```

### Custom the FBSideViewMenuController

You can custom the animation of the menu's images this way :

```swift
initialViewController.pictoAnimation = {(desactive:UIImageView?, active:UIImageView?, index:Int)-> Void in
	desactive?.alpha = 0.2
	desactive?.transform = CGAffineTransformMakeScale(0.8,0.8)
	active?.alpha = 1
	active?.transform = CGAffineTransformMakeScale(1,1)
}
```

You will have access to the UIImageView that is desactivate, the one which is activate and the current index.

**WARNING** : Do not add ```UIView.animateWithDuration()``` method in this bloc definition. 