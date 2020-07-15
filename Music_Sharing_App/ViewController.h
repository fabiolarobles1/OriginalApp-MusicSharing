//
//  ViewController.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SpotifyiOS.h>


@interface ViewController : UIViewController <SPTSessionManagerDelegate>
@property (nonatomic, strong) SPTSessionManager *sessionManager;

@end

