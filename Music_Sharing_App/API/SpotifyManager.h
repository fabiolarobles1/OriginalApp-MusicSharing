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

/**
 * The Spotify Manager handles all the requests related to the Spotify API.
 */
@interface SpotifyManager : AFOAuth2Manager

+(instancetype)shared;

/**
 *Makes a song object request to the Spotify using a song's unique identifier.
 *@param songURI Spotify song unique ID (URI)
 *@param token OAuth2 authorized token
 *@param completion  handles the response of the request, if successful a response in JSON format with the song object information will be received.
 */
-(void)getSong:(NSString *)songURI accessToken:(NSString *)token completion:(void(^)(NSDictionary *song, NSError *error))completion;


/**
 *Makes a request to the Spotify's of all the available genres.
 *@param token OAuth2 authorized token
 *@param completion  handles the response of the request, if successful a response in JSON format with all the available genres.
 */
-(void)getGenres:(NSString *)token completion:(void (^)(NSDictionary *genres , NSError *error ))completion;


/**
 *Makes a request to the Spotify API of 20 recommended songs based on 1-5 songs.
 *@param token OAuth2 authorized token
 *@param songs String of songs URI separated by commas (up to 5 songs)
 *@param completion handles the request, if successful a response in JSON format of the 20 recommended song objects will be received.
 */
-(void)getRecommendedSongs:(NSString *)token songsCommaSeparated:(NSString *)songs completion:(void (^)(NSDictionary *posts , NSError *error ))completion;

@end

NS_ASSUME_NONNULL_END
