//
//  SpotifyManager.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/16/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "SpotifyManager.h"
#import "AppDelegate.h"

//static NSString * const spotifyClientID = @"YOUR CLIENT HERE";
//static NSString * const spotifySecretClientID = @"YOUR SECRET CLIENT HERE";
//static NSString * const spotifyRedirectURLString = @"YOUR REDIRECT LINK";
//static NSString * const tokenSwapURLString = @"TOKEN SWAP";
//static NSString * const tokenRefreshURLString = @"REFRESH TOKEN";
//static NSString * const baseURL =@"https://api.spotify.com";
//static NSString * const trackRequestBase = @"/v1/tracks/";
static NSString * const spotifyClientID = @"4aee2af8f9ee40899fca0aa8cb45a531";
static NSString * const spotifySecretClientID = @"fb3638b9860646bfbe55845dd9ccdbd9";
static NSString * const spotifyRedirectURLString = @"music-sharing-app-login://callback";
static NSString * const tokenSwapURLString = @"https://musicsharingapp-spotify.herokuapp.com/api/token";
static NSString * const tokenRefreshURLString = @"https://musicsharingapp-spotify.herokuapp.com/api/refresh_token";
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
    //creating manager with client and secret ID
    self = [super initWithBaseURL:[NSURL URLWithString:baseURL] clientID:spotifyClientID secret:spotifySecretClientID];
    return self;
}


-(void)setUpHeaderField:(NSString *)token{
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer  %@",token] forHTTPHeaderField:@"Authorization"];
}


-(void)getSong:(NSString *)songURI accessToken:(NSString *)token completion:(void (^)(NSDictionary * , NSError * ))completion{
    //setting header field with access token
    [self setUpHeaderField:token];
    
    //making song request
    [self GET:[trackRequestBase stringByAppendingString:songURI] parameters:nil progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable response) {
        
        //request completed
        completion(response, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //request failed
        completion(nil,error);
    }];
}


-(void)getGenres:(NSString *)token completion:(void (^)(NSDictionary *genres , NSError *error ))completion{
    //setting header field with access token
    [self setUpHeaderField:token];
    
    //making genres request
    [self GET:@"https://api.spotify.com/v1/recommendations/available-genre-seeds" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        
        //request completed
        completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //request failed
        completion(nil, error);
    }];
}


-(void)getRecommendedSongs:(NSString *)token songsCommaSeparated:(NSString *)songs
                completion:(void (^)(NSDictionary *songs , NSError *error ))completion{
    //setting header field with access token
    [self setUpHeaderField:token];
    
    //making recommended song request with parameters
    NSDictionary *parameters = @{@"limit":@(20),@"seed_tracks":songs};
    [self GET:@"https://api.spotify.com/v1/recommendations" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        
        //request completed
        completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //request failed
        completion(nil, error);
    }];    
}


-(void)playSong:(NSString *)songURI play:(BOOL)play appDelegate:(AppDelegate *)appDelegate{
    if(![appDelegate.appRemote isConnected]){
        [appDelegate.appRemote connect];
    }
    if(play){
        [appDelegate.appRemote.playerAPI play:songURI callback:^(id  _Nullable result, NSError * _Nullable error) {
            if(!error){
                NSLog(@"Playing song.");
            }
        }];
    }else{
        [appDelegate.appRemote.playerAPI pause:^(id  _Nullable result, NSError * _Nullable error) {
            if(!error){
                NSLog(@"Paused song.");
            }
        }];
    }
}


@end
