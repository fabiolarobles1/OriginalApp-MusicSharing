//
//  SpotifyManager.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/15/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "SpotifyManager.h"

@implementation SpotifyManager

+ (instancetype)shared{
    static SpotifyManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session{
    NSLog(@"success: %@", session);
}

-(void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"fail: %@", error);
}

-(void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session{
    NSLog(@"renewed: %@", session);
}


@end
