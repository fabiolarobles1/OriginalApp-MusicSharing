//
//  SpotifyManager.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/16/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <SpotifyiOS/SpotifyiOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyManager : SPTSessionManager <SPTSessionManagerDelegate>

@property (nonatomic, strong) SPTSessionManager *sessionManager;
@property (nonatomic, strong) SPTConfiguration *configuration;

+(instancetype)shared;
- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session;
- (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error;
- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session;

@end

NS_ASSUME_NONNULL_END
