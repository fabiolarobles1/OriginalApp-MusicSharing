//
//  DetailsVC.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/22/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "DetailsVC.h"

@interface DetailsVC ()

@end

@implementation DetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [self.detailsView setView:self.post];
//     [self.detailsView.delegate.appRemote connect];
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
