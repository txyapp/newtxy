/*
 * 测试用代码，可能有些头文件，你那里没有
 * 关键函数enc_data() dec_data()
 * 被注释了
 */




//#include <jni.h>
//#include <jni.h>
#include <stdio.h>
//#include <dlfcn.h>
//#include <android/log.h>
//#include <pthread.h>
//#include <fcntl.h>
//#include <sys/mman.h>
//#include <net/if.h>
//#include <sys/socket.h>
#include "base64.h"
#include "md5.h"
//#include "infohelper.h"
#include "aes.h"
#include <string>
#include <alloca.h>
#include <stdlib.h>

#define ENABLE_DEBUG    1//这个不错，log开关

#define ARRAY_SIZE(arr) (sizeof(arr)/sizeof(arr[0]))

#define LOG_TAG "TXYJNI"

#if ENABLE_DEBUG//自己替换一下日志输出函数
#define LOGD(...) ((void)__android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__))
#define LOGE(...) ((void)__android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__))
#else
#define LOGD(format,args...)
#define LOGE(format,args...)
#endif

//static bool getSignatureMD5(JNIEnv* env, jobject contextObj, char* output);
//去掉了android的c/c++环境的部分JNIEnv* env, jobject contextObj,
static bool getSignatureMD5(char* output);
char* enc_data_impl(const char* data);
char* dec_data_impl(const char* data);

::std::string simple_decstring(const char* p) {
	std::string rlt;
	unsigned char key, tmp1, tmp2;
	unsigned short length;
	key = p[0];
	tmp1 = p[1] ^ key;
	tmp2 = p[2] ^ key;
	length = ((tmp2 << 8) & 0xFF00) | (tmp1 & 0xFF);
	char * pTmp = (char*) alloca(length+1);
	memset(pTmp, 0, length + 1);
	int i = 0, j = 3;
	for (; i < length; i++, j++) {
		*(pTmp + i) = *((unsigned char*) p + j) ^ key;
	}
	int rlen = 0;
	rlt.assign(pTmp);
	return rlt;
}

void getmd5(void * buffer, size_t n_size, char * out, bool needHex) {
	int i;
	md5_state_t state;
	md5_byte_t digest[16];
	int di;
	md5_init(&state);
	md5_append(&state, (const md5_byte_t *) buffer, n_size);
	md5_finish(&state, digest);
	if (needHex) {
		for (di = 0; di < 16; ++di) {
			sprintf(out + di * 2, "%02x", digest[di]);
		}
	} else {
		memcpy(out, digest, 16);
	}
}

inline bool checkSign(unsigned char* sig) {
	if (sig[0] == 0x43 && sig[1] == 0x6d && sig[2] == 0x3b && sig[3] == 0x29) {
		if (sig[4] == 0x58 && sig[5] == 0x81 && sig[6] == 0x6c && sig[7] == 0xda) {
			if (sig[8] == 0x3d && sig[9] == 0x0e && sig[10] == 0x4d && sig[11] == 0x05) {
				if (sig[12] == 0x51 && sig[13] == 0x7c && sig[14] == 0xa6 && sig[15] == 0x41) {
					return true;
				}
			}
		}
	}
	return false;
}

//inline bool verifySignatureMD5(JNIEnv* env, jobject contextObj) {
//	char sig[16] = {0};
//	getSignatureMD5(sig);
//	return checkSign((unsigned char*)sig);
//}

bool getSignatureMD5(char* output) {

	//todo 这字符串是android特有，动态生成的，先写死，测试可行，我再把这字符串加密了
	char tmpbuf[0x4000] = {"MIICuzCCAaOgAwIBAgIEGH36QTANBgkqhkiG9w0BAQsFADANMQswCQYDVQQDEwJhaDAgFw0xNDA2MTYwNDA2NDVaGA8zMDEzMTAxNzA0MDY0NVowDTELMAkGA1UEAxMCYWgwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCZHFDGbHXGt22cCjuZG4Cp+P1Ogm/DYJBCSqrS9Jl4PKRkJCgHQlcLszFAqJ0ceDZ8ajuxcZNbEAFRVBfXbzbfJctbHePcjNoc2BOpTjjdQhglIRIvn22Ci/PQtVqQTKi9N50HT7DLI9J7zWMk6zlLQSTIXVWCOg21GPJ7nZRw/t6XKl8IgXk1rEYLV4Wu/vvJkcT3xHp1LhHipntRSxwFAn302RBKvZLnX857M30RN8fmzwNJmzveWYFEdH6mkOs5VffGFTjNFgITiO3cX9U0Zlwcsns170LRMKhjPEK1vgH4Z5ZY9FzH4QMC4bVMJ4+zm15hl834clHohauwJpZXAgMBAAGjITAfMB0GA1UdDgQWBBTfKfll97riNkpoYgRQYe1RteXAlDANBgkqhkiG9w0BAQsFAAOCAQEAj0hG5FwasHhgzB21g4lrjHdJ4pl1IOdY9WmwKoyPjztqhheSASlKk0YkfUjxLyiGUTMqf/FfzyCOpzYuIX5m1c2IduWJhkMOIpIAKqzVTJFViT4jV2MS5rNQJz5E7Od7kHr26v8U7wssQHNk8xClawKGXS6stD6rWVRp0hUsdi2wGcItzc83e2LKqROY0jyZjh3OTrUQQGHYVxg7dyApLpE6HYdVScZryhTlR2sPkOXy6g+m2ooP8qDcYRr6XitxkFRRbJ6s0mMMxW2Rawwrlk2B89I+UznzE8CEcwLIJ4RDrwJl6vfSlvLjZyqTP/GIdc+sruH7fYZGPVHXfzyLmA=="};
	int tmpLengthAfterBase64 = strlen(tmpbuf);
	getmd5(tmpbuf, tmpLengthAfterBase64, output, false);
    
    return true;
}

//void get_ifr_mac_address(char *ifrname, char *value) {
//	char szWifimac[50] = { 0 };
//	int skfd;
//	struct ifreq ifr;
//	char szHwaddr[100];
//	skfd = socket(AF_INET, SOCK_DGRAM, 0);
//	memset((void*) &ifr, 0, sizeof(ifr));
//	strncpy(ifr.ifr_name, ifrname, IFNAMSIZ);
//	if (ioctl(skfd, SIOCGIFHWADDR, &ifr) >= 0) {
//		snprintf(szWifimac, 50, "%02X:%02X:%02X:%02X:%02X:%02X", ifr.ifr_hwaddr.sa_data[0], ifr.ifr_hwaddr.sa_data[1], ifr.ifr_hwaddr.sa_data[2], ifr.ifr_hwaddr.sa_data[3], ifr.ifr_hwaddr.sa_data[4], ifr.ifr_hwaddr.sa_data[5]);
//	}
//	close(skfd);
//	memcpy(value, szWifimac, strlen(szWifimac));
//}
//
//void getIMEI(JNIEnv* env, jobject context, char *out) {
//	jclass helperClz = env->FindClass("com/txyapp/client/AndroidHelper");
//	if (NULL == helperClz) {
//		return;
//	}
//	jmethodID getMID = env->GetStaticMethodID(helperClz, "getIMEI", "(Landroid/content/Context;)Ljava/lang/String;");
//	if (NULL == getMID) {
//		return;
//	}
//	jobject android_id_obj = env->CallStaticObjectMethod(helperClz, getMID, context);
//	if (NULL == android_id_obj) {
//		return;
//	}
//	const char* android_id_str = env->GetStringUTFChars((jstring) android_id_obj, JNI_FALSE);
//	memcpy(out, android_id_str, strlen(android_id_str));
//	env->ReleaseStringUTFChars((jstring) android_id_obj, android_id_str);
//}
//
//void getBtAddress(JNIEnv* env, jobject context, char *out) {
//	jclass helperClz = env->FindClass("com/txyapp/client/AndroidHelper");
//	if (NULL == helperClz) {
//		return;
//	}
//	jmethodID getMID = env->GetStaticMethodID(helperClz, "getBtAddress", "(Landroid/content/Context;)Ljava/lang/String;");
//	if (NULL == getMID) {
//		return;
//	}
//	jobject android_id_obj = env->CallStaticObjectMethod(helperClz, getMID, context);
//	if (NULL == android_id_obj) {
//		return;
//	}
//	const char* android_id_str = env->GetStringUTFChars((jstring) android_id_obj, JNI_FALSE);
//	memcpy(out, android_id_str, strlen(android_id_str));
//	env->ReleaseStringUTFChars((jstring) android_id_obj, android_id_str);
//}
//
//void getAndroidID(JNIEnv* env, jobject context, char *out) {
//	jclass helperClz = env->FindClass("com/txyapp/client/AndroidHelper");
//	if (NULL == helperClz) {
//		return;
//	}
//	jmethodID getMID = env->GetStaticMethodID(helperClz, "getAndroidId", "(Landroid/content/Context;)Ljava/lang/String;");
//	if (NULL == getMID) {
//		return;
//	}
//	jobject android_id_obj = env->CallStaticObjectMethod(helperClz, getMID, context);
//	if (NULL == android_id_obj) {
//		return;
//	}
//	const char* android_id_str = env->GetStringUTFChars((jstring) android_id_obj, JNI_FALSE);
//	memcpy(out, android_id_str, strlen(android_id_str));
//	env->ReleaseStringUTFChars((jstring) android_id_obj, android_id_str);
//}

void xor_data(char *data, int datalen, char *key, int keylen) {
	int i = 0;
	for (; i < datalen; i++) {
		data[i] ^= key[i % keylen];
	}
}

//jstring getCode(JNIEnv* env, jobject obj, jobject context, int type) {
//	char sigmd5[16] = { 0 };
//	char tmp[64] = { 0 };
//	char tmpdatabuf[0x1000] = { 0 };
//	char wifiaddress[64] = { 0 };
//	char uuid[64] = { 0 };
//	char brand[64] = { 0 };
//	char model[64] = { 0 };
//	char imei[64] = { 0 };
//	char cpuid[64] = { 0 };
//	char android_id[64] = { 0 };
//	char bluetooth_address[64] = { 0 };
//	char realuuid[16] = { 0 };
//	getUUID(uuid);
//	get_sys_property("wifi.interface", tmp, "wlan0");
//	get_ifr_mac_address(tmp, wifiaddress);
//	get_sys_property("ro.product.brand", brand, "NULL");
//	get_sys_property("ro.product.model", model, "NULL");
//	getcpuid(cpuid);
//	getSignatureMD5(sigmd5);
//	getBtAddress(env, context, bluetooth_address);
//	getAndroidID(env, context, android_id);
//	getIMEI(env, context, imei);
//	snprintf(tmpdatabuf, sizeof(tmpdatabuf), "%s", "kingofthelab");
//	snprintf(tmpdatabuf, sizeof(tmpdatabuf), "%s%s", tmpdatabuf, uuid);
//	if (type & 2) {
//		snprintf(tmpdatabuf, sizeof(tmpdatabuf), "%s%s", tmpdatabuf, brand);
//	}
//	if (type & 128) {
//		snprintf(tmpdatabuf, sizeof(tmpdatabuf), "%s%s", tmpdatabuf, wifiaddress);
//	}
//	if (type & 4) {
//		snprintf(tmpdatabuf, sizeof(tmpdatabuf), "%s%s", tmpdatabuf, model);
//	}
//	if (type & 16) {
//		snprintf(tmpdatabuf, sizeof(tmpdatabuf), "%s%s", tmpdatabuf, android_id);
//	}
//	if (type & 32) {
//		snprintf(tmpdatabuf, sizeof(tmpdatabuf), "%s%s", tmpdatabuf, cpuid);
//	}
//	if (type & 8) {
//		snprintf(tmpdatabuf, sizeof(tmpdatabuf), "%s%s", tmpdatabuf, imei);
//	}
//	if (type & 64) {
//		snprintf(tmpdatabuf, sizeof(tmpdatabuf), "%s%s", tmpdatabuf, bluetooth_address);
//	}
//	int datalen = strlen(tmpdatabuf);
//	if (type & 1) {
//		xor_data(tmpdatabuf, datalen, sigmd5, sizeof(sigmd5));
//	}
//	getmd5(tmpdatabuf, datalen, realuuid, false);
//	uint32_t uid_one = crc32((unsigned char*) realuuid, sizeof(realuuid));
//	uint32_t uid_two = crc32((unsigned char*) &uid_one, sizeof(int));
//	char final_uuid[40] = { 0 };
//	snprintf(final_uuid, sizeof(final_uuid), "%s%02X", final_uuid, uid_one & 0xFF);
//	snprintf(final_uuid, sizeof(final_uuid), "%s%02X-", final_uuid, (uid_one >> 8) & 0xFF);
//	snprintf(final_uuid, sizeof(final_uuid), "%s%02X", final_uuid, (uid_one >> 16) & 0xFF);
//	snprintf(final_uuid, sizeof(final_uuid), "%s%02X-", final_uuid, (uid_one >> 24) & 0xFF);
//	snprintf(final_uuid, sizeof(final_uuid), "%s%02X", final_uuid, uid_two & 0xFF);
//	snprintf(final_uuid, sizeof(final_uuid), "%s%02X-", final_uuid, (uid_two >> 8) & 0xFF);
//	snprintf(final_uuid, sizeof(final_uuid), "%s%02X", final_uuid, (uid_two >> 16) & 0xFF);
//	snprintf(final_uuid, sizeof(final_uuid), "%s%02X", final_uuid, (uid_two >> 24) & 0xFF);
//	return env->NewStringUTF(final_uuid);
//}

////封装接口，适应android
//jstring enc_data(JNIEnv* env, jobject obj, jobject context, jstring data) {
//	if (NULL == data) {
//		return NULL;
//	}
//	const char* tmpdata = env->GetStringUTFChars(data, JNI_FALSE);
//	//此处是真正实现
//	char* tmpBufAfterbase64=enc_data_impl(tmpdata);
//
//	env->ReleaseStringUTFChars(data, tmpdata);
//	jstring retstring = env->NewStringUTF(tmpBufAfterbase64);
//	free(tmpBufAfterbase64);//释放
//	return retstring;
//}
////封装接口，适应android
//jstring dec_data(JNIEnv* env, jobject obj, jobject context, jstring data) {
//	if (NULL == data) {
//		return NULL;
//	}
//	const char* tmpdata = env->GetStringUTFChars(data, JNI_FALSE);
//	//此处是真正实现
//	char* tmpBufAfterDec=dec_data_impl(tmpdata);
//
//	env->ReleaseStringUTFChars(data, tmpdata);
//	jstring retstring = env->NewStringUTF(tmpBufAfterDec);
//	free(tmpBufAfterDec);//释放
//	return retstring;
//}

char* enc_data_impl(const char* data) {//返回的是堆里的char*，要记得释放
	if (NULL == data) {
		return NULL;
	}
	char sig[16] = {0};
	getSignatureMD5(sig);
	const char* tmpdata = data;
	const int tmpdatalen = strlen(data);
	if (0 == tmpdatalen) {
		return NULL;
	}
	char* decdata = (char*)malloc(tmpdatalen + 16);
	if (NULL == decdata) {
		return NULL;
	}
	int decdatalen = 0;
	memset(decdata, 0, tmpdatalen + 16);
	t1((uint8_t*)sig, K_128, (const char*)tmpdata, tmpdatalen, decdata, &decdatalen);
	if (0 == decdatalen) {
		return NULL;
	}
	char* tmpBufAfterbase64 = (char*)malloc((decdatalen / 2) * 3+1);
	if (NULL == tmpBufAfterbase64) {
		free(decdata);
		return NULL;
	}
	int tmpLengthAfterBase64 = 0;
	memset(tmpBufAfterbase64, 0, (decdatalen / 2) * 3+1);
	base64_context base64Ctx;
	base64_init_ex(&base64Ctx, 0, '+', '/', '=');
	base64_encode_ex(&base64Ctx, (char*) decdata, decdatalen, tmpBufAfterbase64, &tmpLengthAfterBase64, 1);

	free(decdata);
	return tmpBufAfterbase64;
}

char* dec_data_impl(const char* data) {//返回的是堆里的char*，要记得释放
	if (NULL == data) {
		return NULL;
	}
	char sig[16] = {0};
	getSignatureMD5(sig);
	const char* tmpdata = data;
	const int tmpdatalen = strlen(data);
	if (0 == tmpdatalen) {
		return NULL;
	}
	char* tmpBufAfterBase64 = (char*)malloc(tmpdatalen);
	if (NULL == tmpBufAfterBase64) {
		return NULL;
	}
	int tmpLengthAfterBase64 = 0;
	memset(tmpBufAfterBase64, 0, tmpdatalen);
	base64_context base64Ctx;
	base64_init_ex(&base64Ctx, 0, '+', '/', '=');
	base64_decode(&base64Ctx, (char*) tmpdata, tmpdatalen, tmpBufAfterBase64, &tmpLengthAfterBase64);

	char* tmpBufAfterDec = (char*)malloc(tmpLengthAfterBase64);
	if (NULL == tmpBufAfterDec) {
		free(tmpBufAfterBase64);
		return NULL;
	}
	memset(tmpBufAfterDec, 0, tmpLengthAfterBase64);
	int tmpLengthAfterDec = 0;
	t2((uint8_t*)sig, K_128, (const char*)tmpBufAfterBase64, tmpLengthAfterBase64, tmpBufAfterDec, &tmpLengthAfterDec);
	free(tmpBufAfterBase64);
	return tmpBufAfterDec;
}

//JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM *vm, void *reserved) {
//	JNIEnv *env = NULL;
//	if (vm->GetEnv((void **) &env, JNI_VERSION_1_4) != JNI_OK) {
//		return JNI_ERR;
//	}
//	::std::string getCodeStr = "getCode";
//	::std::string encDataStr = "encData";
//	::std::string decDataStr = "decData";
//	::std::string getCodeMethodSigStr = "(Landroid/content/Context;I)Ljava/lang/String;";
//	::std::string encDataMethodSigStr = "(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;";
//	::std::string decDataMethodSigStr = "(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;";
//
//	JNINativeMethod methods[] = {
//		{ getCodeStr.c_str(), getCodeMethodSigStr.c_str(), (void *) getCode },
//		{ encDataStr.c_str(), encDataMethodSigStr.c_str(), (void *) enc_data },
//		{ decDataStr.c_str(), decDataMethodSigStr.c_str(), (void *) dec_data }
//	};
//	jclass clazz = env->FindClass("com/txyapp/client/Native");
//	if (NULL == clazz) {
//		return JNI_ERR;
//	}
//
//	if (env->RegisterNatives(clazz, methods, 3) < 0) {
//		return JNI_ERR;
//	}
//	return JNI_VERSION_1_4;
//}
