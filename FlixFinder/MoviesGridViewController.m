//
//  MoviesGridViewController.m
//  FlixFinder
//
//  Created by Riley Schnee on 6/27/18.
//  Copyright © 2018 Riley Schnee. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *filteredData;


@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.searchBar.delegate = self;
    
    [self fetchMovies];

    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    //layout.minimumInteritemSpacing = 5;
    //layout.minimumLineSpacing = 5;
    
    CGFloat postersPerLine = 2;
    //CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
    CGFloat itemHeight = 1.5 * itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    
}
- (void)fetchMovies {
    // Make network call here!
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/upcoming?api_key=68e66492655ae4158df702fc167d958f"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            //Create alert
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The Internet connection appears to be offline" preferredStyle:(UIAlertControllerStyleAlert)];
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
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            // TODO: Get the array of movies
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
            self.movies = dataDictionary[@"results"];
            self.filteredData = self.movies;

            [self.collectionView reloadData];
        }
    }];
    [task resume];
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
    UICollectionViewCell  *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    NSDictionary *movie = self.filteredData[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    NSDictionary *movie = self.filteredData[indexPath.item];

    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:posterURL];
    // clear posterView
    cell.posterView.image = nil;
    // fade transition
    MovieCollectionCell *weakSelf = cell;
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

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredData.count;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        
        
        self.filteredData = [self.movies filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title contains[c] %@)", searchText]];
        
        NSLog(@"%@", self.filteredData);
        
    }
    else {
        self.filteredData = self.movies;
    }
    
    [self.collectionView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.filteredData = self.movies;
    [self.collectionView reloadData];
    
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}


@end
