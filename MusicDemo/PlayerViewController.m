//
//  PlayerViewController.m
//  MusicDemo
//
//  Created by 6006 on 13-11-28.
//  Copyright (c) 2013年 navydun. All rights reserved.
//

#import "PlayerViewController.h"
#import "PlayerView.h"
#import "Music.h"
#import "SongListViewController.h"
#import "MapMusicViewController.h"
@interface PlayerViewController ()

@end

@implementation PlayerViewController

-(void)dealloc
{
    [musicPlayer release];
    [processTimer release];
    [songsArray release];
    [_playerView release];
    [_playingSong release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor cyanColor]];
    //自定义naviagation
      
    UIButton* left  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [left setTitle:@"歌曲列表" forState:UIControlStateNormal];
    left.frame = CGRectMake(0, 0, 60, 40);
    [left addTarget:self action:@selector(showSongsList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn release];
    
    UIButton* right  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [right setTitle:@"附近歌曲" forState:UIControlStateNormal];
    right.frame = CGRectMake(0, 0, 60, 40);
    [right addTarget:self action:@selector(songsMap) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [rightBtn release];
    
    
    //加载播放器页面UI
    _playerView = [[PlayerView alloc]initWithFrame:CGRectMake(0, 0, 320 , 566)];
    [self.view addSubview:_playerView];
    //隐藏控制声音
    [_playerView.voliceSlider setHidden:YES];
    
    //为专辑图片添加手势
    //为专辑图片添加划动手势，可以进入上一曲，下一曲
     [_playerView.specialImageView setUserInteractionEnabled:YES];
    UISwipeGestureRecognizer* swipeGesture = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureAction:)]autorelease];
    [_playerView.specialImageView addGestureRecognizer:swipeGesture];
   
    
    //左划
    UISwipeGestureRecognizer* leftSwipeGesture = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureAction:)]autorelease];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [_playerView.specialImageView addGestureRecognizer:leftSwipeGesture];
    
    //为按钮添加事件
    [_playerView.lastSongBtn addTarget:self action:@selector(playLastSong:) forControlEvents:UIControlEventTouchUpInside];
    
    [_playerView.stopSongBtn addTarget:self action:@selector(pauseSong:) forControlEvents:UIControlEventTouchUpInside];
    
    [_playerView.nextSongBtn addTarget:self action:@selector(playNextSong:) forControlEvents:UIControlEventTouchUpInside];
    
    [_playerView.muteBtn addTarget:self action:@selector(muteSong:) forControlEvents:UIControlEventTouchUpInside];
    
    [_playerView.playModeBtn addTarget:self action:@selector(playMode:) forControlEvents:UIControlEventTouchUpInside];
    [_playerView.voliceBtn addTarget:self action:@selector(showVolumeSlider:) forControlEvents:UIControlEventTouchUpInside];
    
    [_playerView.voliceSlider addTarget:self action:@selector(changeVolume:) forControlEvents:UIControlEventValueChanged];
    
    //加载数据
    songsArray = [[NSMutableArray alloc]init];
    [self initSongs];
    
    //初始化播放器
    musicIndex = 0;
    playMode = YES;
    [self prepareMusic:[songsArray objectAtIndex:musicIndex]];
}

#pragma 专辑图片手势
//专辑图片手势方法
-(void)swipeGestureAction:(UISwipeGestureRecognizer*)sender
{
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            [self playLastSong:nil];
            break;
        case UISwipeGestureRecognizerDirectionRight:
            [self playNextSong:nil];
            break;
        default:
            break;
    }
}


#pragma 初始化歌曲数组
-(void)initSongs
{
    //读取声音plist文件
    NSString* songsFilePath = [[NSBundle mainBundle]pathForResource:@"songs" ofType:@"plist"];
    //获取plist文件下的数组，
    NSArray* Array = [[NSArray alloc]initWithContentsOfFile:songsFilePath];
    for (int i=0; i<Array.count; i++)
    {
        //数组下获取字典
        NSDictionary* dic = nil;
        dic = [Array objectAtIndex:i];
        
        Music* song =[[[Music alloc]initWithName:[dic objectForKey:@"musicName"] andIcon:[dic objectForKey:@"musicIcon"] andSinger:[dic objectForKey:@"singer"]]autorelease];
        song.musicId = i;
        NSLog(@"music id ==%d",song.musicId);
        [songsArray addObject:song];
        
    }

}
#pragma 初始化播放器
-(void)prepareMusic:(Music*)song
{
    if ([processTimer isValid]) {
        [processTimer invalidate];
        //        timer = nil;
    }
    //如果播放器不为空，则把音乐停止并置为空
    if (musicPlayer) {
        [musicPlayer stop];
        musicPlayer = nil;
    }
    processTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(showProcess) userInfo:nil repeats:YES];
    //获得当前播放的歌曲

   
    NSString* filePath = [[NSBundle mainBundle]pathForResource:song.musicName ofType:@"mp3"];
    NSURL* url = [NSURL fileURLWithPath:filePath];
    musicPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    musicPlayer.delegate = self;
    [musicPlayer prepareToPlay];
  
    musicPlayer.currentTime = 0.0f;
    
    //专辑图片
    UIImage* image = [UIImage imageNamed:song.musicIcon];
    _playerView.specialImageView.image = image;
    
    //获取歌曲信息
    _playerView.singerNameLable.text =  song.singer;
    _playerView.songNameLable.text = song.musicName;
    
    //当前播放歌曲
    _playingSong = song;

}

#pragma 播放器控制
//音乐播放进度条
-(void)showProcess
{
    _playerView.progress.progress = [musicPlayer currentTime] /[musicPlayer duration];
    //播放时间
//    int playtime = (int)[musicPlayer currentTime];
//    //剩余时间
//    int leavetime = (int)([musicPlayer duration]-[musicPlayer currentTime]);
    
//    self.leavetime.text = [[[NSString alloc]initWithFormat:@"-%.2d:%.2d",leavetime/60,leavetime%60 ]autorelease];
//    self.playtime.text =[[[NSString alloc]initWithFormat:@"%.2d:%.2d",playtime/60,playtime%60]autorelease];
    
}
//调解音量
- (void)changeVolume:(id)sender
{
    musicPlayer.volume = _playerView.voliceSlider.value;
}
//声音控制条显示或者隐藏
- (void)showVolumeSlider:(id)sender
{
    static BOOL volumeSliderIsHidden = TRUE;
    if (volumeSliderIsHidden)
    {
        [_playerView.voliceSlider setHidden:NO];
        volumeSliderIsHidden = false;
        
    }else{
        [_playerView.voliceSlider setHidden:YES];
        volumeSliderIsHidden = TRUE;
    }
}


//播放模式
- (void)playMode:(id)sender
{
    UIButton* btn = sender;
    if ([btn.titleLabel.text isEqualToString:@"顺序播放"])
    {
        [btn setTitle:@"随机播放" forState:UIControlStateNormal];
        playMode = NO;
        NSLog(@"随机播放");
    }else
    {
        [btn setTitle:@"顺序播放" forState:UIControlStateNormal];
        playMode = YES;
        NSLog(@"顺序播放");
    }
    
}

//关闭声音
- (void)muteSong:(id)sender {
    static BOOL volumeIsNo = TRUE;
    if (volumeIsNo) {
        musicPlayer.volume = 0;
        volumeIsNo = false;
    }else
    {
        musicPlayer.volume = _playerView.voliceSlider.value;
        volumeIsNo = TRUE;
    }
    
}

#pragma 歌曲播放
//实现代理，当播放完歌曲后，进入后下一曲
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player1 successfully:(BOOL)flag
{
    NSLog(@"歌曲播放完成");
    if (musicIndex==[songsArray count]-1) {
        musicIndex = 0;
    }
    else{
        musicIndex++;
    }
    [self prepareMusic:[songsArray objectAtIndex:musicIndex]];
    [musicPlayer play];
    [processTimer fire];
}


//播放上一曲
- (void)playLastSong:(id)sender
{
    
    if (!playMode) {
        musicIndex = arc4random()%songsArray.count;
        [self prepareMusic:[songsArray objectAtIndex:musicIndex]];
        [musicPlayer play];
        [processTimer fire];
    }else{
        if (musicIndex ==0)
        {
            musicIndex = (int)[songsArray count]-1;
            
        }else{
            musicIndex--;
            
        }
        [self prepareMusic:[songsArray objectAtIndex:musicIndex]];
        [musicPlayer play];
    }
}

//暂停播放

- (void)pauseSong:(UIButton*)sender {
    UIButton* btn = (UIButton*)sender;
 
    
    if ([btn.titleLabel.text isEqualToString:@"暂停"]) {
        [btn setTitle:@"播放" forState:UIControlStateNormal];
        processTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(showProcess) userInfo:nil repeats:YES];
        [musicPlayer play];
        [processTimer fire];
        [processTimer invalidate];
        processTimer = nil;

    }else
    {
        [btn setTitle:@"暂停" forState:UIControlStateNormal];
        [musicPlayer stop];
        
        [processTimer invalidate];
        processTimer = nil;
    }
    
    
}


//播放下一曲
- (void)playNextSong:(id)sender
{
      if (!playMode) {
        musicIndex = arc4random()%songsArray.count;
        
        [self prepareMusic:[songsArray objectAtIndex:musicIndex]];
        [musicPlayer play];
        
        [processTimer fire];
    }else{
        
        if (musicIndex==[songsArray count]-1) {
            musicIndex = 0;
        }
        else{
            musicIndex++;
        }
        
        [self prepareMusic:[songsArray objectAtIndex:musicIndex]];
        [processTimer fire];
        [musicPlayer play];
    }
    NSLog(@"当前播放第几首歌曲%d",musicIndex);
}

#pragma 展示歌曲列表
-(void)showSongsList
{
    SongListViewController* songsListViewContorller = [[SongListViewController alloc] init];
    songsListViewContorller.songsArray = songsArray;
    [songsListViewContorller setBlock:^(Music* song) {
      
        [self prepareMusic:song];
        [musicPlayer play];
    }];
    [self.navigationController pushViewController:songsListViewContorller animated:YES];
    [songsListViewContorller release];
                                                       
}

#pragma 地图上附近歌曲
-(void)songsMap
{
    MapMusicViewController* musicMapViewController = [[MapMusicViewController alloc]init];
    musicMapViewController.songsArray = songsArray;
    musicMapViewController.playingSong = [songsArray objectAtIndex:musicIndex];
    
    [musicMapViewController setBlock:^(Music *song) {
        NSLog(@"=====%d",song.musicId);
        [self prepareMusic:song];
        [musicPlayer play];
    }];
    
    [self.navigationController pushViewController:musicMapViewController animated:YES];
    [musicMapViewController release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
