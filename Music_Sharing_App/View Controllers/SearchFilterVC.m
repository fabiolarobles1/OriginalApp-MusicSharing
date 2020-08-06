//
//  SearchFilterVC.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/31/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "SearchFilterVC.h"
#import <ChameleonFramework/Chameleon.h>

@interface SearchFilterVC ()
@property (nonatomic)UIColor *tealBlue;
@end

@implementation SearchFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tealBlue = [UIColor colorWithHexString:@"09F0FA"];
    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:self.view.frame
                                                      andColors:@[[UIColor colorWithComplementaryFlatColorOf:self.tealBlue], self.tealBlue]];
    [self customizeButton:self.albumButton];
    [self customizeButton:self.genreButton];
    [self customizeButton:self.moodButton];
    [self customizeButton:self.songnameButton];
    [self customizeButton:self.artistButton];
    [self customizeButton:self.captionButton];
    [self customizeButton:self.usernameButton];
    
    self.genreButton.selected =self.senderVC.genreFilter;
    self.moodButton.selected =self.senderVC.moodFilter;
    self.songnameButton.selected =self.senderVC.songFilter;
    self.artistButton.selected =self.senderVC.artistFilter;
    self.captionButton.selected =self.senderVC.captionFilter;
    self.usernameButton.selected =self.senderVC.usernameFilter;
    self.albumButton.selected =self.senderVC.albumFilter;
}

-(void)customizeButton:(UIButton *)button{
   
    button.layer.borderWidth = 1.0;
    button.layer.cornerRadius = 10;
    button.clipsToBounds = true;
    button.layer.borderColor =[[UIColor colorWithHexString:@"152F4C" withAlpha:1.00] CGColor];
    button.contentEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    button.tintColor = [UIColor colorWithHexString:@"152F4C" withAlpha:1.00];

    
}


-(void)viewWillDisappear:(BOOL)animated{
    self.senderVC.genreFilter = self.genreButton.selected;
    self.senderVC.genreFilter =  self.genreButton.selected;
    self.senderVC.moodFilter = self.moodButton.selected;
    self.senderVC.songFilter = self.songnameButton.selected;
    self.senderVC.artistFilter = self.artistButton.selected;
    self.senderVC.captionFilter = self.captionButton.selected;
    self.senderVC.usernameFilter = self.usernameButton.selected;
    self.senderVC.albumFilter = self.albumButton.selected;
    self.senderVC.filteringActivated = (self.genreButton.selected ||
                                        self.moodButton.selected ||
                                        self.songnameButton.selected ||
                                        self.artistButton.selected ||
                                        self.captionButton.selected ||
                                        self.usernameButton.selected ||
                                        self.albumButton.selected );
    [self.senderVC.tableView reloadData];
    [self.senderVC.searchBar.delegate searchBar:self.senderVC.searchBar textDidChange:self.senderVC.searchBar.text];
    NSLog(@"FILTERING: %d", self.senderVC.filteringActivated);
}



- (IBAction)didTapGenreButton:(id)sender {
    [self.genreButton setSelected:!self.genreButton.isSelected];
    if(self.genreButton.isSelected){
        self.genreButton.backgroundColor = [UIColor colorWithHexString:@"152F4C" withAlpha:1.00];
    }else{
        self.genreButton.backgroundColor = [UIColor clearColor];
    }
}


- (IBAction)didTapMoodButton:(id)sender {
    [self.moodButton setSelected:!self.moodButton.isSelected];
    if(self.moodButton.isSelected){
        self.moodButton.backgroundColor = [UIColor colorWithHexString:@"152F4C" withAlpha:1.00];
    }else{
        self.moodButton.backgroundColor = [UIColor clearColor];
    }
}


- (IBAction)didTapSongButton:(id)sender {
    [self.songnameButton setSelected:!self.songnameButton.isSelected];
    if(self.songnameButton.isSelected){
        self.songnameButton.backgroundColor = [UIColor colorWithHexString:@"152F4C" withAlpha:1.00];
    }else{
        self.songnameButton.backgroundColor = [UIColor clearColor];
    }
}


- (IBAction)didTapArtistButton:(id)sender {
    [self.artistButton setSelected:!self.artistButton.isSelected];
    if(self.artistButton.isSelected){
        self.artistButton.backgroundColor = [UIColor colorWithHexString:@"152F4C" withAlpha:1.00];
    }else{
        self.artistButton.backgroundColor = [UIColor clearColor];
    }
}


- (IBAction)didTapAlbumButton:(id)sender {
    [self.albumButton setSelected:!self.albumButton.isSelected];
    if(self.albumButton.isSelected){
        self.albumButton.backgroundColor = [UIColor colorWithHexString:@"152F4C" withAlpha:1.00];
    }else{
        self.albumButton.backgroundColor = [UIColor clearColor];
    }
}


- (IBAction)didTapCaptionButton:(id)sender {
    [self.captionButton setSelected:!self.captionButton.isSelected];
    if(self.captionButton.isSelected){
        self.captionButton.backgroundColor = [UIColor colorWithHexString:@"152F4C" withAlpha:1.00];
    }else{
        self.captionButton.backgroundColor = [UIColor clearColor];
    }
}


- (IBAction)didTapUsernameButton:(id)sender {
    [self.usernameButton setSelected:!self.usernameButton.isSelected];
    if(self.usernameButton.isSelected){
        self.usernameButton.backgroundColor = [UIColor colorWithHexString:@"152F4C" withAlpha:1.00];
    }else{
        self.usernameButton.backgroundColor = [UIColor clearColor];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
