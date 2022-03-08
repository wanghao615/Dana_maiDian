//
//  DAMessageQueueBySqlite.m
//  DanaAnalyticsSDK
//
//  Created by Kingnet on 15/7/7.
//  Copyright (c) 2015年 KingNet. All rights reserved.
//

#import <sqlite3.h>

#import "DAJSONUtil.h"
#import "DAMessageQueueBySqlite.h"
#import "DALogger.h"

#define MAX_MESSAGE_SIZE 10000   // 最多缓存10000条

@implementation DAMessageQueueBySqlite {
    sqlite3 *_database;
    DAJSONUtil *_DAJSONUtil;
    NSUInteger _messageCount;
}

- (void) closeDatabase {
    sqlite3_close(_database);
    sqlite3_shutdown();
    DADebug(@"%@ close database", self);
}

- (void) dealloc {
    [self closeDatabase];
}

- (id)initWithFilePath:(NSString *)filePath {
    self = [super init];
    _DAJSONUtil = [[DAJSONUtil alloc] init];
    if (sqlite3_initialize() != SQLITE_OK) {
        DAError(@"failed to initialize SQLite.");
        return nil;
    }
    if (sqlite3_open_v2([filePath UTF8String], &_database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL) == SQLITE_OK ) {
        // 创建一个缓存表
        NSString *_sql = @"create table if not exists dataCache (id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, content TEXT)";
        char *errorMsg;
        if (sqlite3_exec(_database, [_sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK) {
            DADebug(@"Create dataCache Success.");
        } else {
            DAError(@"Create dataCache Failure %s",errorMsg);
            return nil;
        }
        _messageCount = [self sqliteCount];
        DADebug(@"SQLites is opened. current count is %ul", _messageCount);
    } else {
        DAError(@"failed to open SQLite db.");
        return nil;
    }
    return self;
}

- (void)addObejct:(id)obj withType:(NSString *)type {
    if (_messageCount >= MAX_MESSAGE_SIZE) {
        DAError(@"touch MAX_MESSAGE_SIZE:%d, do not insert", MAX_MESSAGE_SIZE);
        return;
    }
    NSData* jsonData = [_DAJSONUtil JSONSerializeObject:obj];
    NSString* jsonString = nil;
    @try {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } @catch (NSException *exception) {
        DAError(@"Found NON UTF8 String, ignore");
        return;
    }
    NSString* query = @"INSERT INTO dataCache(type, content) values(?, ?)";
    sqlite3_stmt *insertStatement;
    int rc;
    rc = sqlite3_prepare_v2(_database, [query UTF8String],-1, &insertStatement, nil);
    if (rc == SQLITE_OK) {
        sqlite3_bind_text(insertStatement, 1, [type UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insertStatement, 2, [jsonString UTF8String], -1, SQLITE_TRANSIENT);
        rc = sqlite3_step(insertStatement);
        if(rc != SQLITE_DONE) {
            DAError(@"insert into dataCache fail, rc is %d", rc);
        } else {
            sqlite3_finalize(insertStatement);
            _messageCount ++;
            DADebug(@"insert into dataCache success, current count is %lu", _messageCount);
        }
    } else {
        DAError(@"insert into dataCache error");
    }
}



- (NSArray *) getFirstRecords:(NSUInteger)recordSize withType:(NSString *)type {
    if (_messageCount == 0) {
        return @[];
    }
    
    NSMutableArray* contentArray = [[NSMutableArray alloc] init];
    
    NSString* query = [NSString stringWithFormat:@"SELECT content FROM dataCache WHERE type='%@' ORDER BY id ASC LIMIT %lu", type, (unsigned long)recordSize];
    
    sqlite3_stmt* stmt = NULL;
    int rc = sqlite3_prepare_v2(_database, [query UTF8String], -1, &stmt, NULL);
    if(rc == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            char *ch = (char*)sqlite3_column_text(stmt, 0);
            if (ch) {
                @try {
                    NSString *content =[NSString stringWithUTF8String:ch];
                    if (content) {
                        [contentArray addObject:content];
                    }
                } @catch (NSException *exception) {
                    DAError(@"Found NON UTF8 String, ignore");
                }
            }
        }
        sqlite3_finalize(stmt);
    }
    else {
        DAError(@"Failed to prepare statement with rc:%d, error:%s", rc, sqlite3_errmsg(_database));
        return nil;
    }
    return [NSArray arrayWithArray:contentArray];
}

- (BOOL) removeFirstRecords:(NSUInteger)recordSize withType:(NSString *)type {
    NSUInteger removeSize = MIN(recordSize, _messageCount);
    NSString* query = [NSString stringWithFormat:@"DELETE FROM dataCache WHERE id IN (SELECT id FROM dataCache WHERE type = '%@' ORDER BY id ASC LIMIT %lu);", type, (unsigned long)removeSize];
    char* errMsg;
    @try {
        if (sqlite3_exec(_database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
            DAError(@"Failed to delete record msg=%s", errMsg);
            return NO;
        }
    } @catch (NSException *exception) {
        DAError(@"Failed to delete record exception=%@",exception);
        return NO;
    }
    _messageCount = [self sqliteCount];
    return YES;
}

- (NSUInteger) count {
    return _messageCount;
}

- (NSInteger) sqliteCount {
    NSString* query = @"select count(*) from dataCache";
    sqlite3_stmt* statement = NULL;
    NSInteger count = -1;
    int rc = sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, NULL);
    if(rc == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            count = sqlite3_column_int(statement, 0);
        }
        sqlite3_finalize(statement);
    }
    else {
        DAError(@"Failed to prepare statement, rc is %d", rc);
    }
    return count;
}

- (BOOL) vacuum {
#ifdef SENSORS_ANALYTICS_ENABLE_VACUUM
    @try {
        NSString* query = @"VACUUM";
        char* errMsg;
        if (sqlite3_exec(_database, [query UTF8String], NULL, NULL, &errMsg) != SQLITE_OK) {
            DAError(@"Failed to delete record msg=%s", errMsg);
            return NO;
        }
        return YES;
    } @catch (NSException *exception) {
        return NO;
    }
#else
    return YES;
#endif
}


@end
