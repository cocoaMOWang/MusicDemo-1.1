//
//  PlayerView.h
//  MusicDemo
//
//  Created by 6006 on 13-11-28.
//  Copyright (c) 2013年 navydun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerView : UIView
//专辑封面
@property(retain,nonatomic)UIImageView* specialImageView;
//上一首按钮
@property(retain,nonatomic)UIButton* lastSongBtn;
//暂停按钮
@property(retain,nonatomic)UIButton* stopSongBtn;
//下一首按钮
@property(retain,nonatomic)UIButton* nextSongBtn;
//播放模式按钮
@property(retain,nonatomic)UIButton* playModeBtn;
//静音按钮
@property(retain,nonatomic)UIButton* muteBtn;
//显示声音控制条按钮
@property(retain,nonatomic)UIButton* voliceBtn;
//声音大小
@property(retain,nonatomic)UISlider* voliceSlider;

//播放进度条
@property(retain,nonatomic)UIProgressView* progress;
//歌曲名
@property(retain,nonatomic)UILabel* songNameLable;
//歌手名
@property(retain,nonatomic)UILabel* singerNameLable;


@end
