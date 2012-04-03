//
//  StatHat.m
//
//  Created by Patrick Crosby on 4/4/11.
//  Copyright 2011 Numerotron, Inc. All rights reserved.
//

#import "StatHat.h"

@interface StatHat (Private)
- (void)httpPostDict:(NSDictionary*)params toPath:(NSString*)path;
- (void)releaseConnection;
- (NSMutableDictionary*)makeEZParamsForStat:(NSString*) statName user:(NSString*)ezkey;
- (NSMutableDictionary*)makeClassicParamsForStat:(NSString*) statKey user:(NSString*)userKey;
@end

@implementation StatHat

//
// EZ API class convenience methods
//

+ (StatHat*)postEZStat:(NSString*)statName withValue:(double)value forUser:(NSString*)ezkey delegate:(id<StatHatDelegate>)delegate
{
        StatHat* sh = [[[StatHat alloc] init] autorelease];
        sh.delegate = delegate;

        [sh ezPostStat:statName withValue:value forUser:ezkey];
        return sh;
}

+ (StatHat*)postEZStat:(NSString*)statName withCount:(double)count forUser:(NSString*)ezkey delegate:(id<StatHatDelegate>)delegate
{
        StatHat* sh = [[[StatHat alloc] init] autorelease];
        sh.delegate = delegate;

        [sh ezPostStat:statName withCount:count forUser:ezkey];

        return sh;
}

//
// Classic API class convenience methods
//

+ (StatHat*)postStatKey:(NSString*)statKey withValue:(double)value forUser:(NSString*)userKey delegate:(id<StatHatDelegate>)delegate
{
        StatHat* sh = [[[StatHat alloc] init] autorelease];
        sh.delegate = delegate;
        [sh postStatKey:statKey withValue:value forUserKey:userKey];
        return sh;
}

+ (StatHat*)postStatKey:(NSString*)statKey withCount:(double)count forUser:(NSString*)userKey delegate:(id<StatHatDelegate>)delegate
{
        StatHat* sh = [[[StatHat alloc] init] autorelease];
        sh.delegate = delegate;

        [sh postStatKey:statKey withCount:count forUserKey:userKey];

        return sh;
}

//
// Instance methods
//

@synthesize delegate = _delegate;

- (id)init
{
        if ((self = [super init]) == nil) {
                return nil;
        }

        _body = [[NSMutableString alloc] init];

        return self;
}

- (void)ezPostStat:(NSString*)statName withValue:(double)value forUser:(NSString*)ezkey
{
        NSMutableDictionary* params = [self makeEZParamsForStat:statName user:ezkey];
        [params setObject:[NSNumber numberWithDouble:value] forKey:@"value"];
        [self httpPostDict:params toPath:@"ez"];
}

- (void)ezPostStat:(NSString*)statName withCount:(double)count forUser:(NSString*)ezkey
{
        NSMutableDictionary* params = [self makeEZParamsForStat:statName user:ezkey];
        [params setObject:[NSNumber numberWithDouble:count] forKey:@"count"];
        [self httpPostDict:params toPath:@"ez"];
}

- (void)postStatKey:(NSString*)statKey withValue:(double)value forUserKey:(NSString*)userKey
{
        NSMutableDictionary* params = [self makeClassicParamsForStat:statKey user:userKey];
        [params setObject:[NSNumber numberWithDouble:value] forKey:@"value"];
        [self httpPostDict:params toPath:@"v"];
}

- (void)postStatKey:(NSString*)statKey withCount:(double)count forUserKey:(NSString*)userKey
{
        NSMutableDictionary* params = [self makeClassicParamsForStat:statKey user:userKey];
        [params setObject:[NSNumber numberWithDouble:count] forKey:@"count"];
        [self httpPostDict:params toPath:@"c"];
}

//
// NSURLConnection delegate methods
//

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
        if (connection != _connection) {
                return;
        }

        [_body appendString:[NSString stringWithUTF8String:[data bytes]]];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
        if (connection != _connection) {
                return;
        }

        [self releaseConnection];

        [_delegate statHat:self postError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
        if (connection != _connection) {
                return;
        }

        [self releaseConnection];

        [_delegate statHat:self postFinished:_body];
}

- (void)dealloc
{
        [_connection release];
        [_body release];
        [super dealloc];
}

@end

//
// Private methods
//
@implementation StatHat (Private)

- (void)httpPostDict:(NSDictionary*)params toPath:(NSString*)path
{
        NSString* url = [NSString stringWithFormat:@"http://api.stathat.com/%@", path];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];

        NSMutableArray* dataPairs = [NSMutableArray array];
        for (NSString* key in [params allKeys]) {
                NSString* pair = [NSString stringWithFormat:@"%@=%@", key, [params objectForKey:key]];
                [dataPairs addObject:pair];
        }

        NSString* dataStr = [dataPairs componentsJoinedByString:@"&"];

        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
        _connection = [[NSURLConnection connectionWithRequest:request delegate:self] retain];
}


- (NSMutableDictionary*)makeEZParamsForStat:(NSString*) statName user:(NSString*)ezkey
{
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        [params setObject:ezkey forKey:@"ezkey"];
        [params setObject:statName forKey:@"stat"];
        return params;
}

- (NSMutableDictionary*)makeClassicParamsForStat:(NSString*) statKey user:(NSString*)userKey
{
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        [params setObject:statKey forKey:@"key"];
        [params setObject:userKey forKey:@"ukey"];
        return params;
}

- (void)releaseConnection
{
        [_connection release];
        _connection = nil;
}

@end
