//
//  MapMusicViewController.m
//  MusicDemo
//
//  Created by 6006 on 13-11-28.
//  Copyright (c) 2013年 navydun. All rights reserved.
//

#import "MapMusicViewController.h"
#import "Music.h"
#import "PlayerViewController.h"
#import "SongAnonation.h"
@interface MapMusicViewController ()

@end

@implementation MapMusicViewController
-(void)setBlock:(Block_Mapplay)aBlock
{
    if (block_play!=aBlock) {
        Block_release(block_play);
        block_play = Block_copy(aBlock);
    }
    
    
}
-(void)dealloc
{
    [_songsArray release];
    [_playingSong release];
    [_mapView release];
    [_playingAnonation release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
////视图即将出现
//-(void)viewDidAppear:(BOOL)animated
//{
//    NSLog(@"======%@",_playingSong.musicName);
//    //更新地图上标签的歌曲信息
//    _playingAnonation.title = _playingSong.musicName;
//    _playingAnonation.subtitle = _playingSong.singer;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.title = @"附近好歌";
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 49, 320, 569)];
    _mapView.mapType = MKMapTypeStandard;
    [_mapView setScrollEnabled:YES];
    [_mapView setZoomEnabled:YES];
    _mapView.delegate = self;
    [_mapView setShowsUserLocation:YES];
    [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [self.view addSubview:_mapView];
    
}


#pragma mark-获得用户位置并且更新的方法（会多次执行）
static int count=0;
-(void)mapView:(MKMapView *)mapView1 didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"正在更新");
    //拿到当前位置
    CLLocation *loc=[userLocation location];
    if (count==0&&loc)
    {
        count++;
        NSLog(@"lat=%f,lon=%f",loc.coordinate.latitude,loc.coordinate.longitude);
        //把当前的坐标设置为我们设定区域的中心点
        region.center=loc.coordinate;
        //设置一个比例尺
        MKCoordinateSpan span;
        span.latitudeDelta=0.1;
        span.longitudeDelta=0.1;
        //将我们设置的比例尺付给region
        region.span=span;
        [_mapView setRegion:region];
        
        
        //给系统标注视图添加标题
        userLocation.title= _playingSong.musicName;
        userLocation.subtitle=_playingSong.singer;
        
        //默认一出来就显示气泡
        [_mapView selectAnnotation:userLocation animated:YES];
        
        //将音乐添加到地图上
        for (int i=0; i<_songsArray.count; i++) {
            CLLocationCoordinate2D coord2D;
            coord2D.latitude=loc.coordinate.latitude+0.001*(i+1);
            coord2D.longitude=loc.coordinate.longitude-0.01*(i+1);
            
            Music* song = [_songsArray objectAtIndex:i];
            SongAnonation * songAnonation = [[[SongAnonation alloc]init]autorelease];
            songAnonation.coordinate  = coord2D;
            songAnonation.title = song.musicName;
            songAnonation.subtitle = song.singer;
             [_mapView addAnnotation:songAnonation];
            
        }
        
    }
 }



-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString* annotationID = @"annotationPin";
    MKPinAnnotationView* annotationPin = (MKPinAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:annotationID];
    if (annotationPin==nil)
    {
        annotationPin = [[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationID]autorelease];
    }
    annotationPin.animatesDrop = YES;
    annotationPin.pinColor = MKPinAnnotationColorPurple;
    annotationPin.canShowCallout = YES;
   
    SongAnonation* ant = (SongAnonation*)annotation;
   
    for (Music* song in _songsArray)
    {
        if ([song.musicName isEqualToString:ant.title])
        {
            UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightBtn setFrame:CGRectMake(0, 0, 40, 30)];
            [rightBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
            [rightBtn setTitle:@"播放" forState:UIControlStateNormal];
             rightBtn.tag = (int)song.musicId;
            NSLog(@"rightBtn.tag ===%d",(int)rightBtn.tag);
            [rightBtn addTarget:self action:@selector(doPlayMusic:) forControlEvents:UIControlEventTouchUpInside];
            annotationPin.rightCalloutAccessoryView = rightBtn;
            
            //左边专辑图片
            UIButton*  leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [leftBtn setFrame:CGRectMake(0, 0, 40, 30)];
            NSLog(@"music icon=%@",song.musicIcon);
            [leftBtn setImage:[UIImage imageNamed:song.musicIcon] forState:UIControlStateNormal];
            [leftBtn addTarget:self action:@selector(doShowImage) forControlEvents:UIControlEventTouchUpInside];
            annotationPin.leftCalloutAccessoryView = leftBtn;


        }
    }

    
    
     //设置气泡左右两个按钮
    //右边播放按钮
    
    return annotationPin;


}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MKAnnotationView* annotationView = view;
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 40, 30)];
    Music* mysong = nil;
    for (Music* song in _songsArray)
    {
        if (annotationView.leftCalloutAccessoryView)
        {
            mysong = song;
        }
    }

    [rightBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    annotationView.leftCalloutAccessoryView = rightBtn;
}
-(void)doPlayMusic:(UIButton*)sender
{
    UIButton* btn = (UIButton*)sender;
    btn.tag = (int)sender.tag;
    if (block_play) {
        block_play([_songsArray objectAtIndex:btn.tag]);
    }
}

-(void)doShowImage
{
    NSLog(@"show image");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
