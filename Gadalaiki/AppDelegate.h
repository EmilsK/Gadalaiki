//
//  AppDelegate.h
//  Gadalaiki
//
//  Created by Emils Kraucis
//  Copyright (c) 2013 Emils Kraucis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UINavigationController *navController;

@end
