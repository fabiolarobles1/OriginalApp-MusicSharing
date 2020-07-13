//
//  HomeFeedVC.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "HomeFeedVC.h"
#import "Parse/Parse.h"
#import "LoginVC.h"
#import "SceneDelegate.h"

@interface HomeFeedVC ()

@end

@implementation HomeFeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapLogout:(id)sender {
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error ==nil){
            NSLog(@"Successfully logged out user.");
        }
        else{
            NSLog(@"Error loggin out user.");
        }
    }];
    
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginVC *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
    myDelegate.window.alpha = 0.50;
    myDelegate.window.rootViewController = loginViewController;
    
    [UIView animateWithDuration:2 animations:^{
        myDelegate.window.alpha = 1;
    }];
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
