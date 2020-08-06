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


/**
 Creates a request of a song using the Spotify's unique identifier
 
 @param songURI song's unique identifier
 @param token session authorization token
 @param completion handles the response of the request
 */
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


/// <#Description#>
/// @param token <#token description#>
/// @param completion <#completion description#>
-(void)getGenres:(NSString *)token completion:(void (^)(NSDictionary * , NSError * ))completion{
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer  %@",token] forHTTPHeaderField:@"Authorization"];
    [self GET:@"https://api.spotify.com/v1/recommendations/available-genre-seeds" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        
        completion(responseObject, nil);
        NSLog(@"GENRES: %@", responseObject[@"genres"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error getting genres: %@", error);
        completion(nil, error);
        
    }];
}


-(void)getRecommendedSongs:(NSString *)token songsCommaSeparated:(NSString *)songs completion:(void (^)(NSDictionary *songs , NSError *error ))completion{
    
    NSDictionary *parameters = @{@"limit":@(20),@"seed_tracks":songs};
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer  %@",token] forHTTPHeaderField:@"Authorization"];
    
    [self GET:@"https://api.spotify.com/v1/recommendations" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        
        completion(responseObject, nil);
        NSLog(@"Recomendations: %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error getting genres: %@", error);
        completion(nil, error);
        
    }];
    
}


@end
