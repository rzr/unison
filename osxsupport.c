/* $I1: Unison file synchronizer: src/osxsupport.c $ */
/* $I2: Last modified by vouillon on Tue, 31 Aug 2004 11:33:38 -0400 $ */
/* $I3: Copyright 1999-2004 (see COPYING for details) $ */

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#ifdef __APPLE__
#include <sys/attr.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#endif
#include <errno.h>

extern void unix_error (int errcode, char * cmdname, value arg) Noreturn;
extern void uerror (char * cmdname, value arg) Noreturn;

CAMLprim value isMacOSX (value nothing) {
#ifdef __APPLE__
  return Val_true;
#else
  return Val_false;
#endif
}

/* FIX: this should be somewhere else */ 
/* Only used to check whether pty is supported */
CAMLprim value isLinux (value nothing) {
#ifdef __linux__
  return Val_true;
#else
  return Val_false;
#endif
}

CAMLprim value getFileInfos (value path) {
#ifdef __APPLE__

  CAMLparam1(path);
  CAMLlocal3(res, typeCreator, length);
  int retcode;
  struct attrlist attrList;
  unsigned long options = 0;
  struct {
    unsigned long length;
    char          fileTypeCreator [8];
    char          reserved [32 - 8];
    off_t         rsrcLength;
  } attrBuf;

  attrList.bitmapcount = ATTR_BIT_MAP_COUNT;
  attrList.reserved = 0;
  attrList.commonattr = ATTR_CMN_FNDRINFO;
  attrList.volattr = 0;     /* volume attribute group */
  attrList.dirattr = 0;     /* directory attribute group */
  attrList.fileattr = ATTR_FILE_RSRCLENGTH;    /* file attribute group */
  attrList.forkattr = 0;    /* fork attribute group */

  retcode = getattrlist(String_val (path), &attrList, &attrBuf,
                        sizeof attrBuf, options);

  if (retcode == -1) uerror("getattrlist", path);

  /* Just for debugging...
  printf("file type    = '%.8s'\n", attrBuf.fileTypeCreator);
  printf("rsrc length = %20qu\n", attrBuf.rsrcLength);
  */

  typeCreator = alloc_string (8);
  memcpy (String_val (typeCreator), attrBuf.fileTypeCreator, 8);
  length = copy_int64 (attrBuf.rsrcLength);

  res = alloc_small (2, 0);
  Field (res, 0) = typeCreator;
  Field (res, 1) = length;

  CAMLreturn (res);

#else

  unix_error (ENOSYS, "getattrlist", path);

#endif
}

CAMLprim value setFileInfos (value path, value typeCreator) {
#ifdef __APPLE__

  CAMLparam2(path, typeCreator);
  int retcode;
  struct attrlist attrList;
  unsigned long options = 0;
  struct {
    unsigned long length;
    char          finderInfo [32];
  } attrBuf;

  attrList.bitmapcount = ATTR_BIT_MAP_COUNT;
  attrList.reserved = 0;
  attrList.commonattr = ATTR_CMN_FNDRINFO;
  attrList.volattr = 0;     /* volume attribute group */
  attrList.dirattr = 0;     /* directory attribute group */
  attrList.fileattr = 0;    /* file attribute group */
  attrList.forkattr = 0;    /* fork attribute group */

  retcode = getattrlist(String_val (path), &attrList, &attrBuf,
                        sizeof attrBuf, options);

  if (retcode == -1) uerror("getattrlist", path);

  memcpy (attrBuf.finderInfo, String_val (typeCreator), 8);

  retcode = setattrlist(String_val (path), &attrList, attrBuf.finderInfo,
                        sizeof attrBuf.finderInfo, options);

  if (retcode == -1) uerror("setattrlist", path);

  CAMLreturn (Val_unit);

#else

  unix_error (ENOSYS, "setattrlist", path);

#endif
}
