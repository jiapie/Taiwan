//
//  ViewController.m
//  kcg
//
//  Created by Lee, Chia-Pei on 2015/9/3.
//  Copyright (c) 2015年 Lee, Chia-Pei. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

-(IBAction)bChoose_Action:(id)sender
{
    [self showCountryList];
}

-(void) showCountryList
{
    NSArray *array = [[NSArray alloc] initWithObjects:
                      @"臺北市",@"新北市",@"桃園縣",@"臺中市",@"臺南市",@"高雄市",
                      @"基隆市",@"新竹縣",@"新竹市",@"苗栗縣",@"彰化縣",@"南投縣",
                      @"雲林縣",@"嘉義縣",@"嘉義市",@"屏東縣",@"宜蘭縣",@"花蓮縣",
                      @"臺東縣",@"澎湖縣",@"連江縣",@"金門縣",nil];
    
    tableArray = [[NSMutableArray alloc]initWithArray:array];
    [thisTableView reloadData];

    if(thisTableView.isHidden)
    {
        [thisTableView setHidden:NO];
    }
    else
    {
        [thisTableView setHidden:YES];
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;//NSLineBreakByCharWrapping;
    cell.textLabel.numberOfLines = 1;
    cell.textLabel.text = tableArray[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [bChoose setTitle:tableArray[indexPath.row] forState:UIControlStateNormal];
    [self getContryLocation:tableArray[indexPath.row]];
    [thisTableView setHidden:YES];
}

-(void)getContryLocation:(NSString *)sLoaction
{
    //clear
    NSArray *pointsArray = [thisMap overlays];
    [thisMap removeOverlays:pointsArray];
    
    allPoint = [[NSMutableArray alloc]init];
    NSArray *features = [dAllTaiwan valueForKey:@"features"];
    for(id aType in features)
    {
        NSDictionary *dfeatures = aType;
        NSDictionary *dProperties = [dfeatures valueForKey:@"properties"];
        //城市、城市編號、面積
        NSData *dCountry = [dProperties valueForKey:@"county"];
        //NSLog(@"country:%@,id:%@",dCountry,[dProperties valueForKey:@"county_id"]);
        NSDictionary *dGeometry = [dfeatures valueForKey:@"geometry"];
        //NSDictionary *dType = [dGeometry valueForKey:@"type"];
        //經緯度
        NSArray *aCoordinates = [dGeometry valueForKey:@"coordinates"];
        NSString *sCountry = [NSString stringWithFormat:@"%@",dCountry];
        if([sCountry isEqualToString:sLoaction])
        {
            for(id a in aCoordinates)
            {
                NSArray *aCoordinatesLine = a;
                for(id point in aCoordinatesLine)
                {
                    MKMapPoint points[[point count]];
                    
                    CLLocationCoordinate2D *pointsCoOrds = (CLLocationCoordinate2D*)malloc(sizeof(CLLocationCoordinate2D) * [point count]);
                    
                    NSUInteger index = 0;
                    for(id xy in point)
                    {
                        NSArray *aXY = xy;
                        //緯度
                        NSString *latitude = aXY[1];
                        float fLatitude = [latitude floatValue];
                        
                        //經度
                        NSString *longitude = aXY[0];
                        float fLongitude = [longitude floatValue];
                        
                        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(fLatitude,fLongitude);
                        points[index] = MKMapPointForCoordinate(coord);
                        
                        pointsCoOrds[index++] = CLLocationCoordinate2DMake(fLatitude,fLongitude);
                    }
                    
                    //畫線
                    MKPolyline *line = [MKPolyline polylineWithPoints:points count:[point count]];
                    [thisMap addOverlay:line];
                    
                    //塗滿
                    //MKPolygon *polygon =[MKPolygon polygonWithCoordinates:pointsCoOrds count:[point count]];
                    //[thisMap addOverlay:polygon];
                }
            }
        }
    }
}

- (void)ScreenResize
{//Screen
    //NSLog(@"W:%f,H:%f",UI_SCREEN_W,UI_SCREEN_H);
    //MapView
    [thisMap setFrame:CGRectMake(0, 40, UI_SCREEN_W, (UI_SCREEN_H - 40))];
    
    //X,Y,W,H
    [bChoose setFrame:CGRectMake(0, 40, (UI_SCREEN_W/5), 40)];
    [[bChoose layer] setCornerRadius:10.0f];
    [[bChoose layer] setBorderWidth:1.0f];
    [[bChoose layer] setBorderColor:[UIColor lightGrayColor].CGColor];

    //TableView
    [bChoose setFrame:CGRectMake(0, 80, (UI_SCREEN_W/5), (UI_SCREEN_H - 80))];
}

- (void)viewDidLoad
{
    //NSLog(@"Map");
    [super viewDidLoad];
    
    [self ScreenResize];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if(UI_IS_IOS8_AND_HIGHER)
    {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    //Taiwan Center
    //MKCoordinateRegion region = {TaiwanCenter, AllMap};
    //[thisMap setRegion:region animated:YES];
    
    //Get Country Point
    [self getContryLocation:bChoose.titleLabel.text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    //int color = arc4random()%3;
    //UIColor *colorValue = (color==0)?[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1] :((color==1)? [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1] : [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1] );
    
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        //NSLog(@"Line");
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.strokeColor = [UIColor blueColor];
        return routeRenderer;
    }
    else if([overlay isKindOfClass:[MKPolygon class]])
    {
        //NSLog(@"Region");
        MKPolygon *polygon = overlay;
        MKPolygonRenderer *routeRenderer = [[MKPolygonRenderer alloc] initWithOverlay:polygon];
        routeRenderer.strokeColor = [UIColor blueColor];
        routeRenderer.fillColor = [UIColor blueColor];
        return routeRenderer;
    }
    else return nil;
}

//換圖, 換顏色
/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    NSString *sTitle = [annotation title];
    NSString *firstLetter = [sTitle substringToIndex:1];
    firstLetter = [firstLetter uppercaseString];
    
    //換圖
    MKAnnotationView *annotationView = (MKAnnotationView *)[thisMap dequeueReusableAnnotationViewWithIdentifier:annotationViewReuseIdentifier];
    
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewReuseIdentifier];
    }
    
    if([[annotation title] isEqualToString:CurrentLocation])
    {//不換
        annotationView = nil;
    }
    else
    {
        if([firstLetter isEqualToString:@"R"])
        {//紅線
            annotationView.image = [UIImage imageNamed:sIconRed];
        }
        else //if([firstLetter isEqualToString:@"O"])
        {//橘線
            annotationView.image = [UIImage imageNamed:sIconOrange];
        }
    }
    
    annotationView.annotation = annotation;
    // add below line of code to enable selection on annotation view
    annotationView.canShowCallout = YES;
    
    return annotationView;
}
*/
@end
