//
//  User.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//


@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser
@property (nonatomic, strong) NSString *username;

@end

NS_ASSUME_NONNULL_END
