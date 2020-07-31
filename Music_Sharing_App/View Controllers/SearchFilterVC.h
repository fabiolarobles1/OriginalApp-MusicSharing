//
//  SearchFilterVC.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/31/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchFilterVC : UIViewController
@property (strong, nonatomic) SearchVC *senderVC;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (weak, nonatomic) IBOutlet UIButton *moodButton;
@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
@property (weak, nonatomic) IBOutlet UIButton *captionButton;

@property (weak, nonatomic) IBOutlet UIButton *songnameButton;
@property (weak, nonatomic) IBOutlet UIButton *genreButton;
@property (weak, nonatomic) IBOutlet UIButton *artistButton;
@property (weak, nonatomic) IBOutlet UIButton *albumButton;

@end

NS_ASSUME_NONNULL_END
