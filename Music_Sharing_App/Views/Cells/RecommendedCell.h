//
//  RecommendedCell.h
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 8/3/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecommendedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *albumCoverImage;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) NSString *songname;
@property (strong, nonatomic) NSString *album;
@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSString *albumURLString;
@property (strong, nonatomic) NSString *songURI;
@property (strong, nonatomic) NSString *songSpotifyURL;
        
@end

NS_ASSUME_NONNULL_END
