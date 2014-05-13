//
//  UINavigationController+CustomAnimation.h
//  OKKaRa
//
//  Created by Nhut on 3/15/14.
//  Copyright (c) 2014 Bean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (CustomAnimation)

- (void)setViewControllers:(NSArray *)viewControllers withTransition:(UIViewAnimationTransition)transition;

- (void)pushViewController:(UIViewController *)viewController withTransition:(UIViewAnimationTransition)transition;

@end
