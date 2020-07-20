//
//  SpotifyManager.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/16/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "SpotifyManager.h"
#import "AppDelegate.h"

static NSString * const spotifyClientID = @"YOUR CLIENT HERE";
static NSString * const spotifySecretClientID = @"YOUR SECRET CLIENT HERE";
static NSString * const spotifyRedirectURLString = @"YOUR REDIRECT LINK";
static NSString * const tokenSwapURLString = @"TOKEN SWAP";
static NSString * const tokenRefreshURLString = @"REFRESH TOKEN";
static NSString * const baseURL =@"https://api.spotify.com";
static NSString * const trackRequestBase = @"/v1/tracks/";

@implementation SpotifyManager

+ (instancetype) shared{
    static dispatch_once_t once;
    static SpotifyManager *sharedObject = nil;
    dispatch_once(&once, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

-(instancetype)init{
    self = [super initWithBaseURL:[NSURL URLWithString:baseURL] clientID:spotifyClientID secret:spotifySecretClientID];
    return self;

}

-(void)getSong:(NSString *)songURI accessToken:(NSString *)token completion:(void (^)(NSDictionary * , NSError * ))completion{
    
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer  %@",token] forHTTPHeaderField:@"Authorization"];
    [self GET:[trackRequestBase stringByAppendingString:songURI]
    parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable response) {
        
         NSLog(@"Response from GET: %@", response );
          completion(response, nil);
                          
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //Error
        NSLog(@"Error from GET: %@", error.description);
        completion(nil,error);
    }];
}


@end
