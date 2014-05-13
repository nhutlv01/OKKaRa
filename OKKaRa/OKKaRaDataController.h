//
//  OKKaRaDataController.m
//  OKKaRa
//
//  Created by Nhut on 3/16/14.
//  Copyright (c) 2014 Bean. All rights reserved.
//

@interface OKKaRaDataController : NSObject
{
    NSManagedObjectContext *_managedObjectContext;
    NSManagedObjectModel *_managedObjectModel;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    NSMutableArray *_favoriteSongs;
}

- (void)saveContext;
+ (OKKaRaDataController *)sharedDataController;
- (void)saveFavoriteSongs;
- (id)shareFavoriteSongs;
- (NSManagedObjectContext *)managedObjectContext;
@end