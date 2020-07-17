//
//  SpotifyManager.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/16/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <SpotifyiOS/SpotifyiOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyManager : SPTSessionManager


+(instancetype)shared;

- (void)getSong:(NSString *)song completion:(void (^)(NSString *, NSError *))completion;
@end

NS_ASSUME_NONNULL_END
