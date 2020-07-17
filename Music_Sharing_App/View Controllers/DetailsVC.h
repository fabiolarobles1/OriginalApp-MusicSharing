//
//  DetailsVC.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/16/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SpotifyiOS.h>
#import "SpotifyManager.h"


NS_ASSUME_NONNULL_BEGIN

@interface DetailsVC : UIViewController <SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate>
@property (nonatomic, strong) SpotifyManager *manager;
@property (nonatomic, strong) SPTAppRemote *appRemote;
@property (nonatomic, strong) SPTSessionManager *sessionManager;

@end

NS_ASSUME_NONNULL_END
