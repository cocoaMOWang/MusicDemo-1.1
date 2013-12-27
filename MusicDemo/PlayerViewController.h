//
//  PlayerViewController.h
//  MusicDemo
//
//  Created by 6006 on 13-11-28.
//  Copyright (c) 2013年 navydun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@class PlayerView;
@class Music;
@interface PlayerViewController : UIViewController<AVAudioPlayerDelegate>
{
    //声明一个音乐播放器
    AVAudioPlayer* musicPlayer;
    
    //播放进度定时器
    NSTimer* processTimer;
    
    //歌曲数组
    NSMutableArray* songsArray;
    
    //播放模式
    BOOL playMode;
    
    //当前歌曲播放位置
    int musicIndex;
}
@property(strong,nonatomic)PlayerView* playerView;
@property(retain,nonatomic)Music* playingSong;
@end
