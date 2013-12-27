//
//  PlayerView.m
//  MusicDemo
//
//  Created by 6006 on 13-11-28.
//  Copyright (c) 2013年 navydun. All rights reserved.
//

#import "PlayerView.h"
#import <QuartzCore/QuartzCore.h>
@implementation PlayerView
-(void)dealloc
{
    [_specialImageView release];
    [_voliceSlider release];
    [_progress release];
    [_songNameLable release];
    [_singerNameLable release];
    [super dealloc];
}

#pragma 播放器页面布局
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        //专辑图片
        _specialImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 49, 300, 300)];
        _specialImageView.image = [UIImage imageNamed:@"apologize"];
        [self addSubview:_specialImageView];
        
        //歌手名字
        _singerNameLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 349, 80, 20)];
        _singerNameLable.text = @"singer:";
        [self addSubview:_singerNameLable];
        
        //歌曲名称
        _songNameLable = [[UILabel alloc]initWithFrame:CGRectMake(95, 349, 150, 20)];
        _songNameLable.text = @"aplogize";
        [self addSubview:_songNameLable];
        
        //歌曲播放进度
        _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(10, 374, 300, 5)];
        _progress.progress = 0.0f;
        [self addSubview:_progress];
        
        //上一首按钮
        _lastSongBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _lastSongBtn.frame = CGRectMake(10, 384, 60, 20);
        [_lastSongBtn setTitle:@"上一首" forState:UIControlStateNormal];
        [self addSubview:_lastSongBtn];
        
        
        //暂停按钮
        _stopSongBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _stopSongBtn.frame = CGRectMake(75, 384, 50, 20);
        [_stopSongBtn setTitle:@"暂停" forState:UIControlStateNormal];
        [self addSubview:_stopSongBtn];
        
        //下一首按钮
        _nextSongBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _nextSongBtn.frame = CGRectMake(125, 384, 60, 20);
        [_nextSongBtn setTitle:@"下一首" forState:UIControlStateNormal];
        [self addSubview:_nextSongBtn];
        
        //静音按钮
        _muteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _muteBtn.frame = CGRectMake(190, 384, 50, 20);
        [_muteBtn setTitle:@"静音" forState:UIControlStateNormal];
        [self addSubview:_muteBtn];
        
        //播放模式按钮
        _playModeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _playModeBtn.frame = CGRectMake(245, 384, 60, 20);
        [_playModeBtn setTitle:@"顺序播放" forState:UIControlStateNormal];
        [self addSubview:_playModeBtn];
        
        //声音按钮
        _voliceBtn  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _voliceBtn.frame = CGRectMake(10, 419, 50, 20);
        [_voliceBtn setTitle:@"声音" forState:UIControlStateNormal];
        [self addSubview:_voliceBtn];
        
        //声音大小
        _voliceSlider = [[UISlider alloc]initWithFrame:CGRectMake(55, 419, 100, 5)];
        _voliceSlider.value = 0.0f;
        [self addSubview:_voliceSlider];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
