//
//  Songs.h
//  OKKaRa
//
//  Created by Nhut on 4/7/14.
//  Copyright (c) 2014 Bean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Songs : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * lang;
@property (nonatomic, retain) NSString * lyric;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * search;
@property (nonatomic, retain) NSString * stand;

@end
