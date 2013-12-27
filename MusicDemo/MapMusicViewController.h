//
//  MapMusicViewController.h
//  MusicDemo
//
//  Created by 6006 on 13-11-28.
//  Copyright (c) 2013年 navydun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class Music;
@class SongAnonation;
typedef void (^Block_Mapplay)(Music* song);
@interface MapMusicViewController : UIViewController<MKMapViewDelegate>
{
    
    MKCoordinateRegion region;

    Block_Mapplay block_play;
    
}
//存放音乐数组
@property(retain,nonatomic)NSMutableArray* songsArray;
//用户当前正在听的歌曲
@property(retain,nonatomic)Music* playingSong;
@property(retain,nonatomic)MKMapView* mapView;
//当前用户正在播放的标注
@property(retain,nonatomic)SongAnonation* playingAnonation;
-(void)setBlock:(Block_Mapplay)aBlock;
@end
