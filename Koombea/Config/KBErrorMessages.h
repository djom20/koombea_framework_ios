//
//  KBErrorMessages.h
//  TrackTopia
//
//  Created by Oscar De Moya on 11/29/11.
//  Copyright (c) 2011 Koombea S.A.S. All rights reserved.
//

#define ERROR_MESSAGE @"ERROR: %@" // (error)
#define ERROR_DATABASE_PROVIDER @"Database error: %@, %@" // (error, [error userInfo])
#define ERROR_PARSE_PROVIDER @"Parse error: %@, %@" // (error, [error userInfo])
#define ERROR_PERSISTENT_STORE @"Unresolved error: %@, %@" // (error, [error userInfo])
#define EXCEPTION_MESSAGE @"EXCEPTION: %@" // (exception)

#define ERROR_CONNECTION 10001;
#define ERROR_TRANSFER   10002;