//
//  MainVCViewController.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/23/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "MapVC.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ArtPiece.h"
#import "GooglePlaceResult.h"
#import "EftGoogleAddressComponent.h"
#import <FBAnnotationClustering/FBAnnotationClustering.h>

@interface MapVC () <CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate, FBClusteringManagerDelegate>
{
    
    NSMutableArray *_allLocation, *_allArtPiece, *_allDialogList, *_allRecentList, *_allRecentArtPiece;
    CLLocationManager* _locationManager;
    FBClusteringManager* _clusteringManager;
    
    NSTimer* _timer;
    GooglePlaceResult* _gresult;
    
    float _zoom_delta;
    float _zoom_delta_t;
    int _currentKeyboardHeight;
    
    BOOL _isFirstTime;
    BOOL _isUserAnnotationView;
}


@property (strong, nonatomic) IBOutlet MKMapView *MAP_VIEW;

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *zoomInBtn;
@property (strong, nonatomic) IBOutlet UIButton *myLocationButon;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *zoomOutButton;
@property (weak, nonatomic) IBOutlet UIButton *addLocationButton;
@property (weak, nonatomic) IBOutlet UIImageView *rectImage;


@property (weak, nonatomic) IBOutlet UIView *dialogView;
@property (weak, nonatomic) IBOutlet UIButton *myRecentBtn;
@property (weak, nonatomic) IBOutlet UIButton *allRecentBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myRecentLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myRecentTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allRecentTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allRecentLeading;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dMainViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dButtonViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dLabelViewHeight;


@property(nonatomic,retain)IBOutlet UIScrollView *scr_Search;
@property (strong, nonatomic) IBOutlet UIView *view_SearchOpponent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view_SearchOpponentHeight;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;

@property (weak, nonatomic) IBOutlet UIView *saveLocatioView;
@property (weak, nonatomic) IBOutlet UIButton *saveLocationButton;


@end

@implementation MapVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self viewSettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [_locationManager startUpdatingHeading];
    
    [_delegate updateTitle:@"Map"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [_locationManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLayoutSubviews {
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark
#pragma mark Private Methods
- (void)viewSettings
{
    [self.navigationController setNavigationBarHidden:true];
    
    _isFirstTime = true;
    _isUserAnnotationView = false;
    
    _zoom_delta = 0.05;
    _zoom_delta_t = 0.04f;
    
    _allLocation = [[NSMutableArray alloc] init];
    _allArtPiece = [[NSMutableArray alloc] init];
    _allDialogList = [[NSMutableArray alloc] init];
    _allRecentList = [[NSMutableArray alloc] init];
    _allRecentArtPiece = [[NSMutableArray alloc] init];
    
    _clusteringManager = [[FBClusteringManager alloc] init];
    _clusteringManager.delegate = self;
    
    _MAP_VIEW.mapType = MKMapTypeStandard;
    
    CLLocationCoordinate2D coordy = CLLocationCoordinate2DMake(40.713020, -73.956091);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordy,300,300);
    [_MAP_VIEW setRegion:region animated:NO];
    
    [self addLongPressGesture];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        
        [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[UIColor whiteColor]];
    } else {
        
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    }
    
    [self getAllBarData];
    [self getAllRecentBarData];
    
    [self hideDialog:true];
    _view_SearchOpponent.hidden = true;
    _saveLocatioView.hidden = true;
    _saveLocationButton.hidden = true;
    
    _saveLocationButton.userInteractionEnabled = false;
    _saveLocationButton.alpha = 0.5;
    
    [Utils dropShadow:_rectImage];
    [Utils dropShadow:_myLocationButon];
    [Utils dropShadow:_addLocationButton];
    [Utils dropShadow:_searchView];
    [Utils dropShadow:_saveLocatioView];
    [Utils dropShadow:_dialogView];
    
    /*for (UIView *view in _searchBar.subviews){
        
        NSLog(@".........%@", view);
        for (UIView *views in view.subviews){
            
            NSLog(@".........%@", views);
            if ([views isKindOfClass:[UITextField class]]) {
                
                UITextField* field = (UITextField *)views;
                [field setText:@"sssssss"];
                [field setBackgroundColor:[UIColor yellowColor]];
                [field setAlpha:1.0];
            }
        }
    }*/
    
}

- (void)hideDialog:(BOOL)isHide {
    
    if (isHide) {
        
        _dMainViewHeight.constant = 0;
        _dLabelViewHeight.constant = 0 ;
        _dButtonViewHeight.constant = 0;
        _myRecentBtn.hidden = true;
        _allRecentBtn.hidden = true;
    } else {
        
        _dMainViewHeight.constant = self.view.frame.size.height / 2;
        _dLabelViewHeight.constant = 2 ;
        _dButtonViewHeight.constant = 50;
        _myRecentBtn.hidden = false;
        _allRecentBtn.hidden = false;
    }
}

- (void)setLocation {
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Start updating locations.
    _locationManager.delegate = self;
    
    //[MAP_VIEW.layer setBorderWidth:2.0f];
    [_MAP_VIEW.layer setCornerRadius:1.0f];
    [_locationManager startUpdatingLocation];
    
    
    if ([CLLocationManager locationServicesEnabled] == NO)
    {
        NSLog(@"%s: location services are not available.", __PRETTY_FUNCTION__);
        
        [_gAppDelegate showAlertDilog:@"Location services" message:@"Location services are not enabled on this device. Please enable location services in settings."];
        
        return;
    }
    
    // Request "when in use" location service authorization.
    // If authorization has been denied previously, we can display an alert if the user has denied location services previously.
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        [_locationManager requestWhenInUseAuthorization];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        NSLog(@"%s: location services authorization was previously denied by the user.", __PRETTY_FUNCTION__);
        
        [_gAppDelegate showAlertDilog:@"Location services" message:@"Location services were previously denied by the you. Please enable location services for this app in settings."];
        return;
    }
    
    [_locationManager startUpdatingLocation];
}

- (void)addLongPressGesture {
    
    UILongPressGestureRecognizer *lpgr
    = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = YES;
    [_myLocationButon addGestureRecognizer:lpgr];
}


-(void)goToDetail:(NSDictionary *)data
{

    if (_delegate != nil) {
        
        [_delegate loadLocationStateVC:[self captureView:_MAP_VIEW] data:data];
    }
}

-(void)replaceMarkers {
    
    [_clusteringManager removeAnnotations:_allArtPiece];
    [_allArtPiece removeAllObjects];
    
    NSArray*array = _MAP_VIEW.annotations;
    for (id<MKAnnotation> ann in array) {
        if ([ann isKindOfClass:[ArtPiece class]]) {
            [_MAP_VIEW removeAnnotation:ann];
        }
    }
    
    for (int i =0 ; i<_allLocation.count; i++)
    {
        NSDictionary* dict = [_allLocation objectAtIndex:i];
        
        
        CGFloat latitude = [dict[@"lat"] floatValue];
        CGFloat Longitude = [dict[@"long"] floatValue];
        
        
        CLLocationCoordinate2D center2 = CLLocationCoordinate2DMake(latitude,Longitude);
        
        ArtPiece *point12 = [[ArtPiece alloc] init];
        point12.coordinate = center2;
        point12.data = dict;
        
        point12.title = [NSString stringWithFormat:@"%@", dict[@"bar_id"]];
        point12.subtitle = [NSString stringWithFormat:@"%@",dict[@"location_name"]];//,placemark.postalCode];
        
        if ([point12.subtitle isEqualToString:@"(null)"])
        {
            point12.subtitle = [NSString stringWithFormat:@"Address2" ];//,locatedAt];
        }
        
        
        point12.imgname = [Utils selectRandomBallImageName:dict[@"bar_id"]];
        
        [_MAP_VIEW addAnnotation:point12];
        [_allArtPiece addObject:point12];
    }
    
    [_clusteringManager addAnnotations:_allArtPiece];
}

-(void)getMethod {
    
    [self setLocation];
    [self replaceMarkers];
    
    if (!_isFirstTime) {
        
        /*ArtPiece *piece = [_allArtPiece lastObject];
        
        [self showSearchedLocation:piece.data[@"lat"] :piece.data[@"long"]];*/
        
        [[NSOperationQueue new] addOperationWithBlock:^{
            double scale = _MAP_VIEW.bounds.size.width / _MAP_VIEW.visibleMapRect.size.width;
            NSArray *annotations = [_clusteringManager clusteredAnnotationsWithinMapRect:_MAP_VIEW.visibleMapRect withZoomScale:scale];
            
            [_clusteringManager displayAnnotations:annotations onMapView:_MAP_VIEW];
        }];
    }
}

- (UIImage*)captureView:(UIView *)view
{
    CGRect rect = view.frame;
    //UIGraphicsBeginImageContext(rect.size);
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage*)captureView {
    
    return [self captureView:_MAP_VIEW];
}

- (void)sortLoaction:(BOOL)isSort {

    [_allDialogList removeAllObjects];
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:_mylatitude longitude:_myLongitude];
    if (isSort) {

        NSMutableArray* list = [NSMutableArray array];
        
        for (int i=0; i< _allArtPiece.count; i++) {
            
            ArtPiece* piece = _allArtPiece[i];
            CLLocationDegrees lat2 = [piece.data[@"lat"] doubleValue];
            CLLocationDegrees long2 = [piece.data[@"long"] doubleValue];
            CLLocation *locB = [[CLLocation alloc] initWithLatitude:lat2 longitude:long2];
            
            CLLocationDistance distance = [locA distanceFromLocation:locB];
            piece.distance = [NSNumber numberWithDouble:distance];
            
            [list addObject:piece];
        }
        
        NSArray* sorted = [NSMutableArray arrayWithArray:[list sortedArrayUsingComparator:^NSComparisonResult(ArtPiece* a, ArtPiece* b) {
            double first = [a.distance doubleValue];
            double second = [b.distance doubleValue];
            return first>second;
        }]];
        
        if (sorted.count > 20) {
        
            [_allDialogList addObjectsFromArray:[sorted subarrayWithRange:NSMakeRange(0, 20)]];
        } else {
            [_allDialogList addObjectsFromArray:sorted];
        }
    } else {
        
        NSMutableArray* list = [NSMutableArray array];
        for (int i=0; i< _allRecentArtPiece.count; i++) {
            
            ArtPiece* piece = _allRecentArtPiece[i];
            CLLocationDegrees lat2 = [piece.data[@"lat"] doubleValue];
            CLLocationDegrees long2 = [piece.data[@"long"] doubleValue];
            CLLocation *locB = [[CLLocation alloc] initWithLatitude:lat2 longitude:long2];
            
            CLLocationDistance distance = [locA distanceFromLocation:locB];
            piece.distance = [NSNumber numberWithDouble:distance];
            
            [list addObject:piece];
            if (i == 19) {
                break;
            }
        }
        
        [_allDialogList addObjectsFromArray:list];
    }
    
    [_tableView reloadData];
}

-(void)resetScrollwithArray :(NSArray*)tempArray
{
    //scroll_view1.contentOffset = CGPointMake(0, 0);
    for (UIView *subview in _scr_Search.subviews)
    {
        [subview removeFromSuperview];
    }
    
    int myvar = 0;
    
    if (tempArray.count > 0) {
        [_noRecordLabel setText:@""];
    } else {
        
        [_noRecordLabel setText:@"No record found"];
    }
    

    
    for (int j = 0; j<tempArray.count; j++)
    {
        if(tempArray.count==0)
        {
            //lblErrorMSG.hidden=NO;
        }
        else
        {
            
            
            NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"View_SearchMAP" owner:self options:nil];
            
            UIView *mainView = [subviewArray objectAtIndex:0];
            
            mainView.frame=CGRectMake(4, myvar, _scr_Search.frame.size.width-8, 30);
            
            UIButton* btn = [mainView viewWithTag:101];
            [btn setTitle:[tempArray objectAtIndex:j][ @"location_name"] forState:UIControlStateNormal];
            btn.accessibilityHint = [tempArray objectAtIndex:j][ @"lat"];
            [btn setAccessibilityLabel:[tempArray objectAtIndex:j][ @"long"]];
            
            if (_saveLocatioView.hidden) {
                
                [btn addTarget:self action:@selector(searchSelectionAction:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                
                if ([tempArray objectAtIndex:j][ @"place_id"]) {
                    
                    [btn setAccessibilityValue:[tempArray objectAtIndex:j][ @"place_id"]];
                }
                [btn addTarget:self action:@selector(addMarker:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            
            [_scr_Search addSubview:mainView];
            
            NSLog(@"jj value---%d...%d.",j, myvar);
            
            myvar = myvar + 30;
        }
    }
    
    /*int height = self.view.frame.size.height - _currentKeyboardHeight - _scr_Search.frame.origin.y;
    
    if (myvar > height) {
        
        _view_SearchOpponentHeight.constant = height;
        
    } else {
        
        _view_SearchOpponentHeight.constant = height - 50;
    }*/
    
    _scr_Search.contentSize = CGSizeMake(0, myvar);
}

-(void)showSearchedLocation :(NSString *)strLAT_1 : (NSString *)strLONG_1
{
    MKCoordinateRegion region;/* = {
                               {[[arr_lat objectAtIndex:0] floatValue], [[arr_long objectAtIndex:0] floatValue] },
                               { [[arr_lat objectAtIndex:arr_lat.count-1] floatValue], [[arr_long objectAtIndex:arr_long.count-1] floatValue] } };*/
    region.center.latitude = [strLAT_1 floatValue];
    region.center.longitude = [strLONG_1 floatValue];
    
    region.span.longitudeDelta = 0.01f;
    region.span.latitudeDelta = 0.01f;
    
    
    [_MAP_VIEW setRegion:region animated:YES];
}

- (void)fetchedData:(NSData *)responseData {
    NSError* error;
    @try {
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:responseData
                              
                              options:kNilOptions
                              error:&error];
        
        NSArray* places = [json objectForKey:@"results"];
        NSLog(@"Google Data: %@", places);
        
        [self plotPositions:places];
    } @catch (NSException *exception) {
        NSLog(@"error");
    }
}

- (void)plotPositions:(NSArray *)data
{
    NSMutableArray* items = [NSMutableArray array];
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:_mylatitude longitude:_myLongitude];
    for (int i=0; i<[data count]; i++)
    {
        
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [data objectAtIndex:i];
        
        //There is a specific NSDictionary object that gives us location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];
        
        
        //Get our name and address info for adding to a pin.
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];
        
        //Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
        
        //Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        
        // 1 Mile = 1609.344 Meters
        //Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        
        CLLocation *locB = [[CLLocation alloc] initWithLatitude:placeCoord.latitude longitude:placeCoord.longitude];
        
        CLLocationDistance distance = [locA distanceFromLocation:locB]/1609.344;
        
        
        NSValue*value = [NSValue valueWithMKCoordinate:placeCoord];
        NSMutableDictionary*pos = [NSMutableDictionary dictionaryWithDictionary: @{@"location_name":name,@"address":vicinity,@"pos":value,@"place_id":place[@"place_id"],@"distance":[NSNumber numberWithDouble:distance]}];
        
        [items addObject:pos];
    }
    
    [self resetScrollwithArray:items];
}

#pragma mark
#pragma mark API Call's

-(void)getAutoCompletePlaces:(NSString *)searchKey{
    
    if (!_isUserAnnotationView) {
        
        NSLog(@"Error");
        //[_gAppDelegate showAlertDilog:@"Error!" message:@"Please enable your location"];
        
    } else {
    
        searchKey = [searchKey stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString* url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&key=%@&types=bar%%7cnight_club&rankby=distance&keyword=%@", _mylatitude, _myLongitude, GoogleDirectionAPI,searchKey];
        
        NSURL* googleRequestURL = [NSURL URLWithString:url];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        
        dispatch_async(queue, ^{
            NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
            [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
        });
    
    }
}

- (void)getAllBarData {
    
    [_allLocation removeAllObjects];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    NSString* API = [NSString stringWithFormat:kAPI_ALLBARS, _gAppPrefData.userID];
    
    [_gAppData sendGETRequest:API completion:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            
            if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                [_allLocation addObjectsFromArray:dict1[@"data"]];
                
                
                [self getMethod];
                
            } else {
                
                [_gAppDelegate showAlertDilog:@"Info" message:dict1[@"msg"]];
            }
            
        }
    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}

- (void)getAllRecentBarData {
    
    [_allRecentList removeAllObjects];
    
    NSString* API = [NSString stringWithFormat:kAPI_ALLRECENTBARS, _gAppPrefData.userID];
    
    [_gAppData sendGETRequest:API completion:^(id result) {
        
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            
            if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                [_allRecentList addObjectsFromArray:dict1[@"bars"]];
                
                
                for (int i =0 ; i<_allRecentList.count; i++)
                {
                    NSDictionary* dict = [_allRecentList objectAtIndex:i];
                    
                    
                    CGFloat latitude = [dict[@"lat"] floatValue];
                    CGFloat Longitude = [dict[@"long"] floatValue];
                    
                    
                    CLLocationCoordinate2D center2 = CLLocationCoordinate2DMake(latitude,Longitude);
                    
                    ArtPiece *point12 = [[ArtPiece alloc] init];
                    point12.coordinate = center2;
                    point12.data = dict;
                    
                    point12.title = [NSString stringWithFormat:@"%@", dict[@"bar_id"]];
                    point12.subtitle = [NSString stringWithFormat:@"%@",dict[@"location_name"]];//,placemark.postalCode];
                    
                    if ([point12.subtitle isEqualToString:@"(null)"])
                    {
                        point12.subtitle = [NSString stringWithFormat:@"Address2" ];//,locatedAt];
                    }
                    
                    
                    point12.imgname = [Utils selectRandomBallImageName:dict[@"bar_id"]];
                    [_allRecentArtPiece addObject:point12];
                }
                
            } else {
                
             //   [_gAppDelegate showAlertDilog:@"Info" message:dict1[@"msg"]];
            }
            
        }
    } failure:^(id result) {
        
    }];
}

- (void)getSaveLocationData {
    
    //#define kAPI_AddLocationParams @"location_name=%@&address=%@&city=%@&state=%@&zip=%@&lat=%@&long=%@&user_id=%@&bar_status=%@&place_id=%@"
    
    NSString* city=@"", *zip=@"", *state=@"", *country=@"";
    for (EftGoogleAddressComponent*component in _gresult.result.address_components) {
        int pos = [component.types indexOfObject:@"postal_code"];
        if(pos != NSNotFound && pos>=0){
            zip = component.long_name;
        }
        
        pos = [component.types indexOfObject:@"administrative_area_level_1"];
        if(pos != NSNotFound && pos>=0){
            state = component.long_name;
        }
        
        pos = [component.types indexOfObject:@"administrative_area_level_2"];
        if(pos != NSNotFound && pos>=0){
            city = component.long_name;
        }
        
        pos = [component.types indexOfObject:@"country"];
        if(pos != NSNotFound && pos>=0){
            country = component.long_name;
        }
    }

    
    
    NSString* params = [NSString stringWithFormat:kAPI_AddLocationParams, _gresult.result.name, _gresult.result.formatted_address, city, state, zip, _gresult.result.lat, _gresult.result.lon, _gAppPrefData.userID, _gresult.result.place_id, country, country];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [_gAppData sendPostRequest:kAPI_ADDLOCATION params:params completion:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            if ([dict1[@"success"] isEqualToString:@"true"]) {
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Thank You" message:@"Your location has been posted successfully." preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    _gresult = nil;
                    _saveLocatioView.hidden = false;
                    [self hideDialogPublic];
                    
                }]];
                
                if (![Utils isIphone]) {
                    alert.popoverPresentationController.sourceView = self.view;
                }
                
                [self presentViewController:alert animated:true completion:nil];
                
            } else {
                
                [_gAppDelegate showAlertDilog:@"Error" message:dict1[@"msg"]];
                
            }
            
        }
    } failure:^(id result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:true];
    }];
}


#pragma mark
#pragma mark Public Methods
- (void)hideDialogPublic {
 
    if (_saveLocatioView.hidden == false) {
    
        [self getAllBarData];
        [self getAllRecentBarData];
    }
    
    if (_dMainViewHeight.constant > 0) {
        
        [self hideDialog:true];
    }
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];
    [self resetScrollwithArray:nil];
    [_view_SearchOpponent setHidden:true];
    
    _saveLocatioView.hidden = true;
    _saveLocationButton.hidden = true;
    
    _saveLocationButton.userInteractionEnabled = false;
    _saveLocationButton.alpha = 0.5;
    
    for (NSLayoutConstraint* constr in _searchButton.constraints) {
        
        constr.constant = 38;
    }
    
    _zoomInBtn.hidden = false;
    _zoomOutButton.hidden = false;
    _rectImage.hidden = false;
    _addLocationButton.hidden = false;
    _myLocationButon.hidden = false;
}

- (UIImage*)captureViewS {
    
    return [self captureView:_MAP_VIEW];
}

- (NSMutableArray *)getAllArtPiece {
    
    return _allArtPiece;
}

#pragma mark
#pragma mark UIButton Action Methods
-(IBAction)currentLocationAction:(UIButton*)sender
{
    
    [self hideDialogPublic];
    
    if (!_isUserAnnotationView) {
        
        NSLog(@"Error");
        [_gAppDelegate showAlertDilog:@"Error!" message:@"Please enable your location"];
        
    }
    else
    {
        MKCoordinateRegion region ;//= {        {[[arr_lat objectAtIndex:0] floatValue], [[arr_long objectAtIndex:0] floatValue] },        { [[arr_lat objectAtIndex:arr_lat.count-1] floatValue], [[arr_long objectAtIndex:arr_long.count-1] floatValue] } };
        region.center.latitude = _mylatitude;
        region.center.longitude = _myLongitude;
        
        region.span.longitudeDelta = 0.008f;
        region.span.latitudeDelta = 0.008f;
        [_MAP_VIEW setRegion:region animated:YES];
    }
}

-(IBAction)createLocationAction:(UIButton*)sender
{
    
    [self hideDialogPublic];
    
    _saveLocatioView.hidden = false;
    _saveLocationButton.hidden = false;
    
    _saveLocationButton.userInteractionEnabled = false;
    _saveLocationButton.alpha = 0.5;
    for (NSLayoutConstraint* constr in _searchButton.constraints) {
        
        constr.constant = 0;
    }
    
    _zoomInBtn.hidden = true;
    _zoomOutButton.hidden = true;
    _rectImage.hidden = true;
    _addLocationButton.hidden = true;
    _myLocationButon.hidden = true;

    [_allLocation removeAllObjects];
    [_clusteringManager displayAnnotations:nil onMapView:_MAP_VIEW];
    [self replaceMarkers];
    [_delegate updateTitle:@"Add Location"];
}




- (IBAction)zoomOutAction:(id)sender {
    
    [self hideDialogPublic];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    region.center.latitude = _MAP_VIEW.centerCoordinate.latitude;
    region.center.longitude = _MAP_VIEW.centerCoordinate.longitude;
    span.latitudeDelta = _MAP_VIEW.region.span.latitudeDelta *2.000002;
    span.longitudeDelta = _MAP_VIEW.region.span.longitudeDelta *2.000002;
    
    if(span.latitudeDelta < 50)
    {
        //        _zoom_delta = span.latitudeDelta;
        NSLog(@"%f",span.latitudeDelta);
        region.span=span;
        //        if (_zoom_delta > _zoom_delta_t && _zoom_delta/2 <= _zoom_delta_t) {
        //            [self replaceMarkers];
        //        }
        [_MAP_VIEW reloadInputViews];
        [_MAP_VIEW setRegion:region animated:TRUE];
    }
    
}

- (IBAction)zoomInAction:(id)sender {
    
    [self hideDialogPublic];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    region.center.latitude = _MAP_VIEW.centerCoordinate.latitude;
    region.center.longitude = _MAP_VIEW.centerCoordinate.longitude;
    
    
    span.latitudeDelta = _MAP_VIEW.region.span.latitudeDelta /2.000002;
    span.longitudeDelta = _MAP_VIEW.region.span.longitudeDelta /2.000002;
    region.span=span;
    //    _zoom_delta = span.latitudeDelta;
    //    NSLog(@"%f",span.latitudeDelta);
    //    if (_zoom_delta <= _zoom_delta_t && _zoom_delta * 2 > _zoom_delta_t) {
    //        [self replaceMarkers];
    //    }
    
    
    [_MAP_VIEW reloadInputViews];
    [_MAP_VIEW setRegion:region animated:TRUE];
}

-  (void)handleLongPress:(UILongPressGestureRecognizer*)sender
{
    [self hideDialogPublic];
    
    
    NSLog(@"handleLongPress");
    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            if (!_isUserAnnotationView)
            {
                NSLog(@"Error");
                [_gAppDelegate showAlertDilog:@"Error!" message:@"Please enable your location"];
            }
            else
            {
                _timer = [NSTimer timerWithTimeInterval:0.3 target:self selector:@selector(buttonKeepPressing:) userInfo:nil repeats:YES];
                
                NSRunLoop * theRunLoop = [NSRunLoop currentRunLoop];
                [theRunLoop addTimer:_timer forMode:NSDefaultRunLoopMode];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [_timer invalidate];
            _timer = nil;
        }
            break;
        default:
            break;
    }
}
- (IBAction)buttonKeepPressing:(id)sender
{
    [self hideDialogPublic];
    
    NSLog(@"button Keep Pressing");
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    region.center.latitude = _mylatitude;
    region.center.longitude = _myLongitude;
    
    //region.center.latitude = MAP_VIEW.centerCoordinate.latitude;
    //region.center.longitude = MAP_VIEW.centerCoordinate.longitude;
    
    span.latitudeDelta = _MAP_VIEW.region.span.latitudeDelta /2.000002;
    span.longitudeDelta = _MAP_VIEW.region.span.longitudeDelta /2.000002;
    region.span=span;
    
    [_MAP_VIEW setRegion:region animated:TRUE];
    
}

- (IBAction)searchMenuAction:(UIButton *)sender {
    
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];
    [self resetScrollwithArray:nil];
    [_view_SearchOpponent setHidden:true];
    
    if (_dMainViewHeight.constant == 0) {
    
        [self hideDialog:false];
        _myRecentLeading.active = false;
        [self closetAction:_myRecentBtn];
    } else {
        
        [self hideDialog:true];
    }
}


- (IBAction)closetAction:(UIButton *)sender {
    
    if (!_myRecentLeading.active) {
    
        _allRecentLeading.active = false;
        _allRecentTrailing.active = false;
        
        _myRecentLeading.active = true;
        _myRecentTrailing.active = true;
        
        [_myRecentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_allRecentBtn setTitleColor:[UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [self sortLoaction:true];
    }
}

- (IBAction)recetAction:(UIButton *)sender {
    
    if (!_allRecentLeading.active) {

        _allRecentLeading.active = true;
        _allRecentTrailing.active = true;
        
        _myRecentLeading.active = false;
        _myRecentTrailing.active = false;
        
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_myRecentBtn setTitleColor:[UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [self sortLoaction:false];
    }
}

-(void)searchSelectionAction:(UIButton *)sender {

    if (_saveLocatioView.hidden) {
    
        [self hideDialogPublic];
    } else {
        
        if (_dMainViewHeight.constant > 0) {
            
            [self hideDialog:true];
        }
        _searchBar.text = @"";
        [_searchBar resignFirstResponder];
        [self resetScrollwithArray:nil];
        [_view_SearchOpponent setHidden:true];
    }
    
    
    NSString* lat = sender.accessibilityHint;
    NSString* lng = sender.accessibilityLabel;
    
    
    [self showSearchedLocation:lat :lng];
}


-(void)addMarker :(UIButton *)sender {
    
    if (_dMainViewHeight.constant > 0) {
        
        [self hideDialog:true];
    }
    
    [_searchBar resignFirstResponder];
    [self resetScrollwithArray:nil];
    [_view_SearchOpponent setHidden:true];
    
    NSString *path = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@&language=en",sender.accessibilityValue,GoogleDirectionAPI];
    
    [_gAppData sendGETRequest:path completion:^(id result) {
        
        if (result != nil) {
            
            NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"post function tag  ==%@",dict1);
            
            
            
            _gresult = [[GooglePlaceResult alloc] initWithDictionary:dict1];
            if ([[_gresult.status lowercaseString] isEqualToString:@"ok"]) {
                
                
            }else{
                
            }
            
            
            if (_gresult!=nil) {
                
                _saveLocationButton.userInteractionEnabled = true;
                _saveLocationButton.alpha = 1.0;
                
                [_allLocation removeAllObjects];
                
                
                NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys: _gresult.result.name, @"location_name", _gresult.result.lat, @"lat", _gresult.result.lon, @"long", _gresult.result.place_id, @"place_id", @"8", @"bar_id", _gresult.result.formatted_address, @"formattedAddress", nil];
                [_allLocation addObject:dict];
                [self replaceMarkers];
                
                //latitude = 22.7196;   Longitude = 75.8577;
                double latitude = [_gresult.result.lat doubleValue];
                double Longitude = [_gresult.result.lon doubleValue];
                CLLocationCoordinate2D center2 = CLLocationCoordinate2DMake(latitude,Longitude);
                
                
                MKPointAnnotation *point12 = [[MKPointAnnotation alloc] init];
                point12.coordinate = center2;
                
                point12.title =[NSString stringWithFormat:@"%@",_gresult.result.name];
                point12.subtitle = [NSString stringWithFormat:@"%@",_gresult.result.formatted_address];
                
                
                //[_MAP_VIEW removeAnnotations:_MAP_VIEW.annotations];
                //[_MAP_VIEW addAnnotation:point12];
                
                //[_MAP_VIEW setRegion:MKCoordinateRegionMake(point12.coordinate, MKCoordinateSpanMake(0.005, 0.005)) animated:YES];
                //[_MAP_VIEW reloadInputViews];
                
                
                MKCoordinateRegion region;/* = {
                                           {[[arr_lat objectAtIndex:0] floatValue], [[arr_long objectAtIndex:0] floatValue] },
                                           { [[arr_lat objectAtIndex:arr_lat.count-1] floatValue], [[arr_long objectAtIndex:arr_long.count-1] floatValue] } };*/
                region.center.latitude = latitude;
                region.center.longitude = Longitude;
                
                region.span.longitudeDelta = 0.01f;
                region.span.latitudeDelta = 0.01f;
                
                
                [_MAP_VIEW setRegion:region animated:YES];
                
                
            }
        }
        
        
    } failure:^(id result) {
        
    }];
}


- (void)keyboardWillShow:(NSNotification*)notification {
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _currentKeyboardHeight = kbSize.height;
}

- (IBAction)saveLocationAction:(id)sender {

    if (_gresult != nil) {
    
        [self getSaveLocationData];
    } else {
        [_gAppDelegate showAlertDilog:@"Info" message:@"Please select a location"];
    }
    
}

#pragma mark
#pragma mark UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_allDialogList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ArtPiece* data = _allDialogList[indexPath.row];
   
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImageView* imageView = [cell viewWithTag:101];
    imageView.image = [UIImage imageNamed:data.imgname];
    
    
    NSString* location = data.data[@"location_name"];
    location = [location lowercaseString];
    location = [location stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[location substringToIndex:1] uppercaseString]];
    
    UILabel* userName = [cell viewWithTag:102];
    userName.text = location;
    
    
    UILabel* name = [cell viewWithTag:103];
    name.text = [NSString stringWithFormat:@"%.2f mile",[data.distance doubleValue]/1609.344];
    
    
    return cell;

}

#pragma mark
#pragma mark UITableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    [self hideDialogPublic];
    ArtPiece* piece = _allDialogList[indexPath.row];
    [self showSearchedLocation:piece.data[@"lat"] :piece.data[@"long"]];
}


#pragma mark
#pragma mark UISearchBar Delegates
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    if (_saveLocatioView.hidden) {
    
        [self hideDialogPublic];
    }
    
    return true;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    return true;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    
    NSString *string = searchBar.text;
    
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    
    searchBar.text = trimmedString;
    
    ///////-------
    NSString *rawString2 = [searchBar text];
    
    NSCharacterSet *whitespace2 = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSString *trimmed2 = [rawString2 stringByTrimmingCharactersInSet:whitespace2];
    if ([trimmed2 length] == 0 || searchBar.text.length ==0)
    {
        searchBar.text=@"";
        [self resetScrollwithArray:nil];
        _view_SearchOpponent.hidden = true;
    }
    else
    {
        if(searchBar.text.length>=1)
        {}
    }

    
    [searchBar resignFirstResponder];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    /*NSCharacterSet *unacceptedInput = nil;
    
    NSInteger oldLength = [_searchBar.text length];
    NSInteger newLength = oldLength + [text length] - range.length;
    
    
    const char * _char = [text cStringUsingEncoding:NSUTF8StringEncoding];
    int isBackSpace = strcmp(_char, "\b");
    
    
    if(isBackSpace != -8 && newLength >= 31)
    {
        return NO;
    }
    
    
    unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[TextNumericspace stringByAppendingString:@""]] invertedSet];
    
    if ([[text componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1) {
    }
    else{
        return NO;
    }*/

    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSString *str = searchBar.text;
    if (![str isEqualToString:@""]) {
        _view_SearchOpponent.hidden=false;
        
        if (_saveLocatioView.hidden) {
            
            NSMutableArray*temp = [NSMutableArray array];
            
            CLLocation *locA = [[CLLocation alloc] initWithLatitude:_mylatitude longitude:_myLongitude];
            for (int i=0; i<_allLocation.count; i++)
            {
                NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:_allLocation[i]];
                
                if ([[dict[@"location_name"] lowercaseString] hasPrefix:[str lowercaseString]])
                {
                    
                    CLLocationDegrees lat2 = [dict[@"lat"] doubleValue];
                    CLLocationDegrees long2 = [dict[@"long"] doubleValue];
                    CLLocation *locB = [[CLLocation alloc] initWithLatitude:lat2 longitude:long2];
                    
                    CLLocationDistance distance = [locA distanceFromLocation:locB];
                    dict[@"distance"] = [NSNumber numberWithDouble:distance];
                    [temp addObject:dict];
                }
            }
            NSArray* arrToSearch = [NSMutableArray arrayWithArray:[temp sortedArrayUsingComparator:^NSComparisonResult(NSMutableDictionary* a, NSMutableDictionary* b) {
                double first = [a[@"distance"] doubleValue];
                double second = [b[@"distance"] doubleValue];
                return first>second;
            }]];
            
            
            [self resetScrollwithArray:arrToSearch];
        } else {
            
            [self getAutoCompletePlaces:str];
        }
        
    }else{
        _view_SearchOpponent.hidden=true;
    }

    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_searchBar resignFirstResponder];
    
    if (_saveLocatioView.hidden) {
        
        [self hideDialogPublic];
    }
}



#pragma mark
#pragma mark UISearchBar Delegates
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"regionDidChangeAnimated ,%.6f",_MAP_VIEW.region.span.latitudeDelta);
    float curdelta = _MAP_VIEW.region.span.latitudeDelta;
    if (curdelta <= _zoom_delta_t && _zoom_delta_t < _zoom_delta) {
        _zoom_delta = curdelta;
        //[self replaceMarkers];
    }else if (curdelta > _zoom_delta_t && _zoom_delta_t > _zoom_delta) {
        _zoom_delta = curdelta;
        //[self replaceMarkers];
    }
    _zoom_delta = curdelta;
    
    [[NSOperationQueue new] addOperationWithBlock:^{
        double scale = _MAP_VIEW.bounds.size.width / _MAP_VIEW.visibleMapRect.size.width;
        NSArray *annotations = [_clusteringManager clusteredAnnotationsWithinMapRect:mapView.visibleMapRect withZoomScale:scale];
        
        [_clusteringManager displayAnnotations:annotations onMapView:mapView];
    }];

}

-(void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@" updating user location . . . . . ");
    
    if (_isFirstTime)
    {
        _mylatitude = userLocation.coordinate.latitude;
        _myLongitude = userLocation.coordinate.longitude;
        
        MKCoordinateRegion region ;  // = { {0.0, 0.0 }, { 0.0, 0.0 } };
        region.center.latitude = _mylatitude;
        region.center.longitude = _myLongitude;
        region.span.longitudeDelta = 0.1f;
        region.span.latitudeDelta = 0.08f;
        
        [_MAP_VIEW setRegion:region animated:YES];
        
        _isFirstTime = false;
        
        MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
        point1.coordinate = userLocation.coordinate;
        
        point1.title = @"Current Location";
        //[MAP_VIEW addAnnotation:point1];
    }
    
    /*if (strHasUserLocation==nil && locationFlag==1)
     {
     MapVC *next=[[MapVC alloc] initWithNibName:@"MapVC" bundle:nil];
     next.strHasUserLocation = @"yes";
     [self.navigationController pushViewController:next animated:NO];
     }*/
    
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    //    NSLog(@"Changing Reagon...................");
    [_searchBar resignFirstResponder];
    //FLAG_regionChange=1;
}


- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation
{
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: @"myPin_com.yd.jelly"];
    if (pin == nil)
    {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"myPin"] ;
        //        NSLog(@"annssss");
    }
    else
    {
        //pin.annotation = annotation;
    }
    //pin.animatesDrop = YES;
    
    pin.draggable = NO;
    pin.canShowCallout = YES;
    if ([annotation isKindOfClass:MKUserLocation.class])
    {
        MKAnnotationView* userAnnotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"myPin_com.yd.jelly"];
        if (userAnnotationView == nil)
        {
            userAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myPin_com.yd.jelly"];
        }
        else
        {
            userAnnotationView.annotation = annotation;
        }
        //userAnnotationView.annotation = annotation;
        userAnnotationView.enabled = YES;
        userAnnotationView.canShowCallout = YES;
        
        userAnnotationView.image = [UIImage imageNamed:@"CUEBALL"];
        
        _isUserAnnotationView = true;
        return userAnnotationView;
    } else  if ([annotation isKindOfClass:[FBAnnotationCluster class]]) {
        FBAnnotationCluster *cluster = (FBAnnotationCluster *)annotation;
        static NSString *reuseId = @"myClusterPin_com.yd.jelly.custom";
        MKAnnotationView *av = av = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
        UILabel*lbl;
        if (av == nil) {
            av = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
            //lbl.font = [UIFont fontWithName:@"Avenir-Next-Regular" size:12];
            [lbl setFont:[UIFont systemFontOfSize:8]];
            lbl.adjustsFontSizeToFitWidth = YES;
//            lbl.layer.cornerRadius = 15.0;
            lbl.layer.masksToBounds = true;
            lbl.backgroundColor = [UIColor clearColor];
            [lbl setMinimumScaleFactor:8.0/[UIFont labelFontSize]];
            
            
            lbl.textColor = [UIColor blackColor];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.alpha = 1.0;
            lbl.tag = 42;
            av.image = [UIImage imageNamed:@"cluster"];
            [av addSubview:lbl];
        }else{
            lbl = [av viewWithTag:42];
            //av.image = [UIImage imageNamed:piece.imgname];
        }
        
        lbl.text = [NSString stringWithFormat:@"%lu", (unsigned long)cluster.annotations.count];
        av.canShowCallout = false;
        
        return av;

    }
    else if ([annotation isKindOfClass:[ArtPiece class]])
    {
        ArtPiece * piece = (ArtPiece *)annotation;
        static NSString *reuseId = @"myPin_com.yd.jelly.custom";
        MKAnnotationView *av = av = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
        
        UILabel*lbl;
        UILabel*lbl2;
        UIImageView*imageView;
        UIView* view;
        
        if (av == nil) {
            av = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
            
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 17)];
            [lbl setFont:[UIFont boldSystemFontOfSize:12.0]];
            lbl.adjustsFontSizeToFitWidth = YES;
            [lbl setMinimumScaleFactor:8.0/[UIFont labelFontSize]];
            
            
            lbl.textColor = [UIColor blackColor];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.alpha = 1.0;
            lbl.tag = 42;
            
            
            lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 32, 160, 20)];
            [lbl2 setFont:[UIFont boldSystemFontOfSize:12.0]];
            lbl2.adjustsFontSizeToFitWidth = YES;
            [lbl2 setMinimumScaleFactor:8.0/[UIFont labelFontSize]];
            lbl2.numberOfLines = 0;
            lbl2.textColor = [UIColor whiteColor];
            lbl2.textAlignment = NSTextAlignmentCenter;
            lbl2.alpha = 0.5;
            lbl2.tag = 43;
            av.image = [UIImage imageNamed:piece.imgname];
            
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 32, 15, 20)];
            imageView.tag = 44;
            
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(-82, 35, 200, 35)];
            [view setTag:142];
            
            [view addSubview:lbl];
            [view addSubview:lbl2];
            [view addSubview:imageView];
            [av addSubview:view];
            
        }else{
            
            view = [av viewWithTag:142];
            lbl = [view viewWithTag:42];
            lbl2 = [view viewWithTag:43];
            imageView = [view viewWithTag:44];
            
            av.image = [UIImage imageNamed:piece.imgname];
        }
        
        /*if (_zoom_delta>_zoom_delta_t) {
            lbl.text = @"";
        }else{
            lbl.text = [piece subtitle];
        }*/
        lbl.text = [piece subtitle];
        
        lbl.backgroundColor = [UIColor clearColor];
        av.canShowCallout = NO;
        
        if (_saveLocatioView.hidden == true) {
            
            view.frame = CGRectMake(-82, 35, 200, 17);
            view.backgroundColor = [UIColor clearColor];
            lbl.textColor = [UIColor blackColor];
            lbl.frame = CGRectMake(0, 0, 200, 17);
            [lbl setFont:[UIFont boldSystemFontOfSize:12.0]];
            imageView.image = nil;
            lbl2.text = @"";
        } else {
            
            view.frame = CGRectMake(-82, 35, 200, 60);
            view.backgroundColor = kAppThemeColor;
            lbl.textColor = [UIColor whiteColor];
            lbl.frame = CGRectMake(0, 10, 200, 17);
            [lbl setFont:[UIFont boldSystemFontOfSize:16.0]];
            
            [lbl2 setFont:[UIFont systemFontOfSize:12.0]];
            lbl2.text = piece.data[@"formattedAddress"];
            [imageView setImage:[UIImage imageNamed:@"location"]];
            
            NSLog(@"..........%@", piece.data);
        }
        return av;
    }
    else
    {
        return pin;
    }
    
    
    return pin;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MKPointAnnotation *myAnnot = (MKPointAnnotation *)view.annotation;
    // field.text = myAnnot.keyValue;
    NSLog(@"key value : %@",myAnnot.subtitle);
    NSLog(@"value id ====%@",myAnnot.title);
    
    
    if (_saveLocatioView.hidden) {
        
        
        if ([myAnnot.subtitle isEqualToString:@"(null)"]||myAnnot.subtitle == nil )
        {
            FBAnnotationCluster *cluster = (FBAnnotationCluster *)view.annotation;
            
            if ([cluster isKindOfClass:[FBAnnotationCluster class]]) {
                
                if (cluster.annotations.count > 1) {
                    /*UIEdgeInsets edgePadding = UIEdgeInsetsMake(40, 20, 44, 20);
                    [_MAP_VIEW showCluster:cluster edgePadding:edgePadding animated:YES];*/
                    
                    
                    
                    /*[[NSOperationQueue new] addOperationWithBlock:^{
                        double scale = 0.0312;//_MAP_VIEW.bounds.size.width / _MAP_VIEW.visibleMapRect.size.width;
                        NSArray *annotations = [_clusteringManager clusteredAnnotationsWithinMapRect:mapView.visibleMapRect withZoomScale:scale];
                        
                        
                        [_clusteringManager displayAnnotations:annotations onMapView:mapView];
                    }];*/
                }
            }
        }
        else
        {
            if ([myAnnot isKindOfClass:[ArtPiece class]]) {
                ArtPiece*piece = (ArtPiece*)myAnnot;
                [self goToDetail:piece.data];
            }
        }
    } else {
        
    }
    
    [mapView deselectAnnotation:view.annotation animated:false];
    
}

#pragma mark - FBClusterManager delegate - optional

- (CGFloat)cellSizeFactorForCoordinator:(FBClusteringManager *)coordinator
{
    return 1.5;
}

@end
