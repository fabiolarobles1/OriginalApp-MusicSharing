//
//  Comment.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/23/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@dynamic text;
@dynamic author;
@dynamic post;

+ (nonnull NSString *)parseClassName { 
    return @"Comment";
}

@end
