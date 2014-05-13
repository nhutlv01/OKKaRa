//
//  UINavigationController+CustomAnimation.m
//  OKKaRa
//
//  Created by Nhut on 3/15/14.
//  Copyright (c) 2014 Bean. All rights reserved.
//

#import "UINavigationController+CustomAnimation.h"

@implementation UINavigationController (CustomAnimation)

- (void)setViewControllers:(NSArray *)viewControllers withTransition:(UIViewAnimationTransition)transition {
    [UIView beginAnimations:nil context:NULL];
    [self setViewControllers:viewControllers animated:NO];
    [UIView setAnimationDuration:.8];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
}

- (void)pushViewController:(UIViewController *)viewController withTransition:(UIViewAnimationTransition)transition {
    [UIView beginAnimations:nil context:NULL];
    [self pushViewController:viewController animated:NO];
    [UIView setAnimationDuration:.8];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
}

@end
