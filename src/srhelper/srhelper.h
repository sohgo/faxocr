/*
 * srhelper.h
 *
 *  Created on: Feb 3, 2010
 *      Author: kentaro
 */

#ifndef SRHELPER_H_
#define SRHELPER_H_

typedef enum SRHELPER_SERVICE SRHELPER_SERVICE;
enum SRHELPER_SERVICE
{
	SRHELPER_SERVICE_FAXIMO = 0,
	SRHELPER_SERVICE_BIZFAX,
	SRHELPER_SERVICE_MESSAGEPLUS,
	SRHELPER_SERVICE_MKI_TELCL
};
typedef enum SRHELPER_MODE SRHELPER_MODE;
enum SRHELPER_MODE
{
	SRHELPER_MODE_FROM = 0,
	SRHELPER_MODE_TO
};

#endif /* SRHELPER_H_ */
