//
//  ComposeVC.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/14/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComposeVC : UIViewController

@property (strong, nonatomic) AppDelegate *delegate;
@property (strong, nonatomic)NSMutableArray *genres;

@end

NS_ASSUME_NONNULL_END
