//
//  SpotifyManager.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/15/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <SpotifyiOS/SpotifyiOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyManager : SPTSessionManager

+ (instancetype)shared;

- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session NS_SWIFT_NAME(sessionManager(manager:didInitiate:));
- (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error NS_SWIFT_NAME(sessionManager(manager:didFailWith:));
- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session  NS_SWIFT_NAME(sessionManager(manager:didRenew:));
@end

NS_ASSUME_NONNULL_END
