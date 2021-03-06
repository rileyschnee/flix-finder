//
//  MoviesViewController.m
//  FlixFinder
//
//  Created by Riley Schnee on 6/27/18.
//  Copyright © 2018 Riley Schnee. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.activityIndicator startAnimating];
    [self fetchMovies];

    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor colorWithRed:1.00 green:0.62 blue:0.03 alpha:1.0];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.backgroundColor = [UIColor blackColor];

    [self.tableView insertSubview:self.refreshControl atIndex:0];
   
    //[self.tableView addSubview:self.refreshControl];

}

- (void)fetchMovies {
    // Make network call here!
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=68e66492655ae4158df702fc167d958f"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            //Create alert
           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The Internet connection appears to be offline" preferredStyle:(UIAlertControllerStyleAlert)];
            // create an OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // handle response here.
            }];
            // add the OK action to the alert controller
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
                [self.refreshControl endRefreshing];

            }];
            
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            // TODO: Get the array of movies
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
            self.movies = dataDictionary[@"results"];
            for(NSDictionary *movie in self.movies){
                NSLog(@"%@", movie[@"title"]);
            }
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];

        }
        [self.activityIndicator stopAnimating];
        
    }];
    [task resume];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:posterURL];

    cell.posterView.image = nil;
    // fade transition
    MovieCell *weakSelf = cell;
    [cell.posterView setImageWithURLRequest:request placeholderImage:nil
                                    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                        
                                        // imageResponse will be nil if the image is cached
                                        //if (imageResponse) {
                                        NSLog(@"Image was NOT cached, fade in image");
                                        weakSelf.posterView.alpha = 0.0;
                                        weakSelf.posterView.image = image;
                                        
                                        //Animate UIImageView back to alpha 1 over 0.3sec
                                        [UIView animateWithDuration:0.2 animations:^{
                                            weakSelf.posterView.alpha = 1.0;
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
    //[cell.posterView setImageWithURL:posterURL];
    return cell;
}







#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UITableViewCell  *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}


@end
