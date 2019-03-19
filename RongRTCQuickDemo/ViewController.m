//
//  ViewController.m
//  RongRTCQuickDemo
//
//  Created by jfdreamyang on 2019/3/19.
//  Copyright © 2019 RongCloud. All rights reserved.
//

#import "ViewController.h"
#import <RongRTCLib/RongRTCLib.h>

@interface ViewController ()<RongRTCRoomDelegate>
@property (nonatomic,strong)RongRTCRoom *room;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // AppKey 设置
    [[RCIMClient sharedRCIMClient] initWithAppKey:@"c9kqb3rdkbb8j"];
    [[RCIMClient sharedRCIMClient] useRTCOnly];
    [[RCIMClient sharedRCIMClient] setServerInfo:@"http://navqa.cn.ronghub.com" fileServer:@"xiaxie"];
    
    // 加入房间
    [[RongRTCEngine sharedEngine] joinRoom:@"HelloRTC" completion:^(RongRTCRoom * _Nullable room, RongRTCCode code) {
        room.delegate = self;
        self.room = room;
        // 发布资源
        [room.localUser publishDefaultAVStream:^(BOOL isSuccess, NSString *desc) {
            
        }];
        
    }];
    
    // 设置本地渲染视图
    RongRTCLocalVideoView * localView = [[RongRTCLocalVideoView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [[RongRTCAVCapturer sharedInstance] setVideoRender:localView];
}

-(void)didPublishStreams:(NSArray<RongRTCAVInputStream *> *)streams{
    
    // 订阅资源
    [self.room.remoteUsers.firstObject subscribeAVStream:streams tinyStreams:nil completion:^(BOOL isSuccess, NSString *desc) {
        
    }];
    // 设置远端渲染视图
    for (RongRTCAVInputStream * stream in streams) {
        if (stream.streamType == RTCMediaTypeVideo) {
            RongRTCRemoteVideoView * videoView = [[RongRTCRemoteVideoView alloc]initWithFrame:CGRectMake(100, 250, 100, 100)];
            [stream setVideoRender:videoView];
        }
    }
}


@end
