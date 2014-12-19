//
//  MainCollectionViewController.m
//  selfiegram
//
//  Created by Nicole Phelps on 12/18/14.
//  Copyright (c) 2014 Nicole Phelps. All rights reserved.
//

#import "MainCollectionViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "AFNetworking.h"
#import "AFURLSessionManager.h"
#import "SelfieViewController.h"

#define REQUEST_URL @"http://www.reddit.com/r/selfies.json?limit=5"

@interface MainCollectionViewController ()


@property (nonatomic,strong) NSMutableArray *responseArray; //eventually want to use dictionary
@property (nonatomic,strong) NSOperationQueue *backgroundQueue;

@end

@implementation MainCollectionViewController

static NSString * const reuseIdentifier = @"Cell";



- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:REQUEST_URL]]];
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *afoperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    afoperation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //Setup blocks that will be called after request finishes
    [afoperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _responseArray  = [responseObject valueForKeyPath:@"data.children.data.thumbnail"];
    
        NSLog(@" response %@", _responseArray);
        
        [self.collectionView reloadData];

    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@",error);
    }];
    
    //Create on background queue so is async
    self.backgroundQueue = [[NSOperationQueue alloc] init];
    [self.backgroundQueue addOperation:afoperation];
    
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];

    // Do any additional setup after loading the view.
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

#pragma mark <UICollectionViewDataSource>

// columns
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// rows
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _responseArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"imageCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString *imageUrl = [_responseArray objectAtIndex:indexPath.item];
    UIImageView *selfieImage = (UIImageView *)[self.collectionView viewWithTag:10];

    selfieImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
    
    NSLog(@"%ld", (long)indexPath.item);

    
    return cell;
}



#pragma mark Button event

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"viewSelfie"]) {

        SelfieViewController *destViewController = (SelfieViewController*)segue.destinationViewController;

        //TODO pass image to selfie vc
        
    }
}



#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
