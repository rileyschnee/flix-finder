//
//  PosterViewController.m
//  FlixFinder
//
//  Created by Riley Schnee on 6/28/18.
//  Copyright © 2018 Riley Schnee. All rights reserved.
//

#import "PosterViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PosterViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end

@implementation PosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *smallBaseURLString = @"https://image.tmdb.org/t/p/w45";
    NSString *largeBaseURLString = @"https://image.tmdb.org/t/p/original";

    NSString *posterURLString = self.movie[@"poster_path"];
    
    NSString *smallPosterURLString = [smallBaseURLString stringByAppendingString:posterURLString];
    NSString *largePosterURLString = [largeBaseURLString stringByAppendingString:posterURLString];
    
    NSURL *smallPosterURL = [NSURL URLWithString:smallPosterURLString];
    NSURL *largePosterURL = [NSURL URLWithString:largePosterURLString];

    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:smallPosterURL];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:largePosterURL];
    
    [self.posterView setImageWithURLRequest:requestSmall
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
                                       
                                       // smallImageResponse will be nil if the smallImage is already available
                                       // in cache (might want to do something smarter in that case).
                                       self.posterView.alpha = 0.0;
                                       self.posterView.image = smallImage;
                                       
                                       [UIView animateWithDuration:0.3
                                                        animations:^{
                                                            
                                                            self.posterView.alpha = 1.0;
                                                            
                                                        } completion:^(BOOL finished) {
                                                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                                                            // per ImageView. This code must be in the completion block.
                                                            [self.posterView setImageWithURLRequest:requestLarge
                                                                                      placeholderImage:smallImage
                                                                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                                                                                                   self.posterView.image = largeImage;
                                                                                               }
                                                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                   // do something for the failure condition of the large image request
                                                                                                   // possibly setting the ImageView's image to a default image
                                                                                               }];
                                                        }];
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       // do something for the failure condition
                                       // possibly try to get the large image
                                   }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
