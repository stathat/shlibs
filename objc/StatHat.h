//
//  StatHat.h
//
//  Created by Patrick Crosby on 4/4/11.
//  Copyright 2011 Numerotron, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StatHatDelegate;

@interface StatHat : NSObject {
        NSURLConnection* _connection;
        NSMutableString* _body;
        id<StatHatDelegate> _delegate;
}

@property (nonatomic, assign) id<StatHatDelegate> delegate;

// EZ API class convenience methods
+ (StatHat*)postEZStat:(NSString*)statName withValue:(double)value forUser:(NSString*)ezkey delegate:(id<StatHatDelegate>)delegate;
+ (StatHat*)postEZStat:(NSString*)statName withCount:(double)count forUser:(NSString*)ezkey delegate:(id<StatHatDelegate>)delegate;

// Classic API class convenience methods
+ (StatHat*)postStatKey:(NSString*)statKey withValue:(double)value forUser:(NSString*)userKey delegate:(id<StatHatDelegate>)delegate;
+ (StatHat*)postStatKey:(NSString*)statKey withCount:(double)count forUser:(NSString*)userKey delegate:(id<StatHatDelegate>)delegate;

- (id)init;

// EZ API instance methods
- (void)ezPostStat:(NSString*)statName withValue:(double)value forUser:(NSString*)ezkey;
- (void)ezPostStat:(NSString*)statName withCount:(double)count forUser:(NSString*)ezkey;

// Classic API instance methods
- (void)postStatKey:(NSString*)statKey withValue:(double)value forUserKey:(NSString*)userKey;
- (void)postStatKey:(NSString*)statKey withCount:(double)count forUserKey:(NSString*)userKey;

@end

@protocol StatHatDelegate
- (void)statHat:(StatHat*)sh postFinished:(NSString*)jsonResponse;
- (void)statHat:(StatHat*)sh postError:(NSError*)err;
@end
