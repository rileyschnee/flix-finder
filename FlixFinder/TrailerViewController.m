//
//  TrailerViewController.m
//  FlixFinder
//
//  Created by Riley Schnee on 6/29/18.
//  Copyright © 2018 Riley Schnee. All rights reserved.
//

#import "TrailerViewController.h"

@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *trailerView;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchMovie];
    
}


- (void)fetchMovie {
    NSString *apiKey = @"68e66492655ae4158df702fc167d958f";
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=%@&language=en-US", self.movie[@"id"], apiKey];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            //Create alert
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Trailer" message:@"The Internet connection appears to be offline" preferredStyle:(UIAlertControllerStyleAlert)];
            // create an OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // handle response here.
                
            }];
            // add the OK action to the alert controller
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
            
        }
        else {
            self.trailerView.backgroundColor = [UIColor blackColor];
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *youtubeURLString = [NSString stringWithFormat:@"https://www.youtube.com/embed/%@%@", dataDictionary[@"results"][0][@"key"], @"/ecver=2"];
            NSURL *youtubeURL = [NSURL URLWithString:youtubeURLString];
            NSURLRequest *request = [NSURLRequest requestWithURL:youtubeURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
            [self.trailerView loadRequest:request];
            [UIView animateWithDuration:0.4 animations:^{
                self.trailerView.alpha = 1.0;
            }];
        }
    }];
    [task resume];
    
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
