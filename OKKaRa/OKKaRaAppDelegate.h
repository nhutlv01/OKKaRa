//
//  OKKaRaAppDelegate.h
//  OKKaRa
//
//  Created by Nhut on 3/11/14.
//  Copyright (c) 2014 Bean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OKKaRaMasterViewController.h"
#import "OKKaRaFavoriteViewController.h"
#import "OKKaRaSettingViewController.h"

@interface OKKaRaAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) OKKaRaMasterViewController *masterViewController;
@property (strong, nonatomic) OKKaRaSettingViewController *settingViewController;
@property (strong, nonatomic) OKKaRaFavoriteViewController *favoriteViewController;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) UIImage *backgroundImage;

@end
