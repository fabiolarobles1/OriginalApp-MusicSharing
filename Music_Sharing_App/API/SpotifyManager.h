//
//  SpotifyManager.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/16/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <SpotifyiOS/SpotifyiOS.h>
#import "AFNetworking.h"
#import "AFOAuth2Manager.h"
#import "AFHTTPRequestSerializer+OAuth2.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpotifyManager : AFOAuth2Manager

+(instancetype)shared;


-(void)getSong:(NSString *)songURI accessToken:(NSString *)token completion:(void(^)(NSDictionary *song, NSError *error))completion; //could delete Token

-(void)getGenres:(NSString *)token completion:(void (^)(NSDictionary * , NSError * ))completion;

@end

NS_ASSUME_NONNULL_END
