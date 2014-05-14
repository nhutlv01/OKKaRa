//
//  OKKaRaAppDelegate.m
//  OKKaRa
//
//  Created by Nhut on 3/11/14.
//  Copyright (c) 2014 Bean. All rights reserved.
//

#import "OKKaRaAppDelegate.h"

//#import <Crashlytics/Crashlytics.h>

@implementation OKKaRaAppDelegate
@synthesize masterViewController;
@synthesize navController;
@synthesize settingViewController;
@synthesize backgroundImage;
@synthesize favoriteViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[Crashlytics startWithAPIKey:@"8f3d3846174edc5a4618828bc4727b9c302493c4"];
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //Set status bar hiden
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.masterViewController = [[OKKaRaMasterViewController alloc] init];
    self.settingViewController = [[OKKaRaSettingViewController alloc] init];
    self.favoriteViewController = [[OKKaRaFavoriteViewController alloc] init];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.settingViewController];
    [self.navController pushViewController:self.masterViewController animated:YES];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Fetch request
        
        //delete cacher
        [NSFetchedResultsController deleteCacheWithName:@"SongsCache"];
        NSFetchRequest *request = [NSFetchRequest new];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Songs" inManagedObjectContext:[[OKKaRaDataController sharedDataController] managedObjectContext]];
        [request setEntity:entity];
        
        NSSortDescriptor *sortTitle = [[NSSortDescriptor alloc] initWithKey:@"search" ascending:YES];
        NSSortDescriptor *sortLang = [[NSSortDescriptor alloc] initWithKey:@"lang" ascending:NO];
        
        [request setSortDescriptors:[NSArray arrayWithObjects:sortLang, sortTitle, nil]];
        [request setFetchBatchSize:10];
        
        self.masterViewController.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[[OKKaRaDataController sharedDataController] managedObjectContext] sectionNameKeyPath:nil cacheName:@"SongsCache"];
        self.masterViewController.fetchedResultsController.delegate = self.masterViewController;
        [self.masterViewController.fetchedResultsController performFetch:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.masterViewController.tableView reloadData];
        });
        
    });
    //Set UINavigationBar's font
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:18]}];

    //Load previous background image and save it to background variable
    int currentBackgroundIndex = (int)[[[NSUserDefaults standardUserDefaults] objectForKey:@"currentBackgroundIndex"] integerValue];
    self.backgroundImage = [UIImage imageNamed:[NSString stringWithFormat:@"Background%d-568h@2x.png", currentBackgroundIndex]];
    
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[OKKaRaDataController sharedDataController] saveFavoriteSongs];
}

@end
