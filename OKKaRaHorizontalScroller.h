//
//  OKKaRaHorizontalScroller.h
//  OKKaRa
//
//  Created by Nhut on 4/14/14.
//  Copyright (c) 2014 Bean. All rights reserved.
//

@protocol OKKaRaHorizontalScrollerDelegate;

@interface OKKaRaHorizontalScroller : UIView<UIScrollViewDelegate>

@property (weak) id<OKKaRaHorizontalScrollerDelegate> delegate;

- (void)reload;

@end

@protocol OKKaRaHorizontalScrollerDelegate <NSObject>
// methods declaration goes in here
@required
// ask the delegate how many views he wants to present inside the horizontal scroller
- (NSInteger)numberOfViewsForHorizontalScroller:(OKKaRaHorizontalScroller*)scroller;

// ask the delegate to return the view that should appear at <index>
- (UIView*)horizontalScroller:(OKKaRaHorizontalScroller*)scroller viewAtIndex:(int)index;

// inform the delegate what the view at <index> has been clicked
- (void)horizontalScroller:(OKKaRaHorizontalScroller*)scroller clickedViewAtIndex:(int)index;

@end
