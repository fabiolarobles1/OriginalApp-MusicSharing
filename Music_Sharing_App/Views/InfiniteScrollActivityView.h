//
//  InfiniteScrollView.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/14/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *Sets activity indicators when perfoming infinite scroll on a table view
 */
@interface InfiniteScrollActivityView : UIView
@property (class, nonatomic, readonly) CGFloat defaultHeight;

/**
 *Starts the activity indicator while fetching new data
 */
- (void)startAnimating;

/**
 *Stops activity indicator when the new data is received
 */
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
