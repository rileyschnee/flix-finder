//
//  DetailsViewController.m
//  FlixFinder
//
//  Created by Riley Schnee on 6/27/18.
//  Copyright © 2018 Riley Schnee. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "PosterViewController.h"
#import "TrailerViewController.h"
#import "SimilarMoviesViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    self.dateLabel.text = self.movie[@"release_date"];
    double movieScore = [self.movie[@"vote_average"] doubleValue];
    self.scoreLabel.text = [NSString stringWithFormat: @"%.0f", movieScore];
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    [self.dateLabel sizeToFit];
    [self.scoreLabel sizeToFit];
    if(movieScore >= 10.0){
        self.scoreLabel.frame = CGRectMake(288.0, self.scoreLabel.frame.origin.y,
            self.scoreLabel.frame.size.width,
            self.scoreLabel.frame.size.height);
    }

    // Scrolling Functionality
    CGFloat maxHeight = self.synopsisLabel.frame.origin.y + self.synopsisLabel.frame.size.height + 20.0;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, maxHeight);
    
    
    //Backdrop
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
    
    NSURLRequest *requestBackdrop = [NSURLRequest requestWithURL:backdropURL];

    // fade transition
    [self.backdropView setImageWithURLRequest:requestBackdrop placeholderImage:nil
                                    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                        
                                        // imageResponse will be nil if the image is cached
                                        //if (imageResponse) {
                                        NSLog(@"Image was NOT cached, fade in image");
                                        self.backdropView.alpha = 0.0;
                                        self.backdropView.image = image;
                                        
                                        //Animate UIImageView back to alpha 1 over 0.3sec
                                        [UIView animateWithDuration:0.2 animations:^{
                                            self.backdropView.alpha = 1.0;
                                        }];
                                        /*}
                                         else {
                                         NSLog(@"Image was cached so just update the image");
                                         weakSelf.posterView.image = image;
                                         }*/
                                    }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                        // do something for the failure condition
                                    }];
    
    
    // old way, no fade transition
    //[self.backdropView setImageWithURL:backdropURL];
    
    
    //Poster
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    
    NSURLRequest *requestPoster = [NSURLRequest requestWithURL:posterURL];
    // fade transition
    [self.posterView setImageWithURLRequest:requestPoster placeholderImage:nil
                                    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                        
                                        // imageResponse will be nil if the image is cached
                                        //if (imageResponse) {
                                        NSLog(@"Image was NOT cached, fade in image");
                                        self.posterView.alpha = 0.0;
                                        self.posterView.image = image;
                                        
                                        //Animate UIImageView back to alpha 1 over 0.3sec
                                        [UIView animateWithDuration:0.2 animations:^{
                                            self.posterView.alpha = 1.0;
                                        }];
                                        /*}
                                         else {
                                         NSLog(@"Image was cached so just update the image");
                                         weakSelf.posterView.image = image;
                                         }*/
                                    }
                                    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                        // do something for the failure condition
                                    }];
    
    
    // old way, no fade transition
    //[self.posterView setImageWithURL:posterURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //UIImageView *image = sender;
    //NSIndexPath *indexPath = [self.posterView indexPathForCell:image];
    
    PosterViewController *posterViewController = [segue destinationViewController];
    posterViewController.movie = self.movie;
    
    TrailerViewController *trailerViewController = [segue destinationViewController];
    trailerViewController.movie = self.movie;
    
    SimilarMoviesViewController *similarMoviesViewController = [segue destinationViewController];
    similarMoviesViewController.movie = self.movie;
    
}


@end
