//
//  OKKaRaSettingViewController.h
//  OKKaRa
//
//  Created by Nhut on 4/4/14.
//  Copyright (c) 2014 Bean. All rights reserved.
//

#import "OKKaRaHorizontalScroller.h"

@interface OKKaRaSettingViewController : UITableViewController<OKKaRaHorizontalScrollerDelegate, UIGestureRecognizerDelegate>
{
    OKKaRaHorizontalScroller *scroller;
}
@end
