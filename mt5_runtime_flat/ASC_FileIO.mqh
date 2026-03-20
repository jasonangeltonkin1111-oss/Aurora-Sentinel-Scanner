#ifndef __ASC_FILEIO_MQH__
#define __ASC_FILEIO_MQH__

#include "ASC_Common.mqh"
#include "ASC_Logging.mqh"

bool ASC_WriteTextFile(const string path,const string content)
  {
   int handle=FileOpen(path,FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON);
   if(handle==INVALID_HANDLE)
      return(false);
   FileWriteString(handle,content);
   FileFlush(handle);
   FileClose(handle);
   return(true);
  }

bool ASC_ReadTextFile(const string path,string &content)
  {
   content="";
   if(!FileIsExist(path,FILE_COMMON))
      return(false);

   int handle=FileOpen(path,FILE_READ|FILE_TXT|FILE_ANSI|FILE_COMMON|FILE_SHARE_READ|FILE_SHARE_WRITE);
   if(handle==INVALID_HANDLE)
      return(false);

   int size=(int)FileSize(handle);
   if(size>0)
      content=FileReadString(handle,size);
   FileClose(handle);
   return(true);
  }

string ASC_NormalizeTextForValidation(const string value)
  {
   string normalized=value;
   StringReplace(normalized,"\r\n","\n");
   StringReplace(normalized,"\r","\n");
   return(normalized);
  }

bool ASC_AtomicWrite(const string final_path,const string content,ASC_Logger &logger)
  {
   string temp_path=final_path + ".tmp";
   string backup_path=final_path + ".last-good";
   string verify="";
   string expected=ASC_NormalizeTextForValidation(content);

   if(!ASC_WriteTextFile(temp_path,content))
     {
      logger.Error("AtomicWrite","temp write failed for " + final_path);
      return(false);
     }

   if(!ASC_ReadTextFile(temp_path,verify))
     {
      FileDelete(temp_path,FILE_COMMON);
      logger.Error("AtomicWrite","temp validation read failed for " + final_path);
      return(false);
     }

   verify=ASC_NormalizeTextForValidation(verify);
   if(verify!=expected)
     {
      FileDelete(temp_path,FILE_COMMON);
      logger.Error("AtomicWrite","temp validation mismatch for " + final_path);
      return(false);
     }

   if(FileIsExist(backup_path,FILE_COMMON))
      FileDelete(backup_path,FILE_COMMON);

   bool final_existed=FileIsExist(final_path,FILE_COMMON);
   if(final_existed && !FileMove(final_path,FILE_COMMON,backup_path,FILE_COMMON|FILE_REWRITE))
     {
      FileDelete(temp_path,FILE_COMMON);
      logger.Error("AtomicWrite","could not preserve last-good for " + final_path);
      return(false);
     }

   if(FileMove(temp_path,FILE_COMMON,final_path,FILE_COMMON|FILE_REWRITE))
      return(true);

   if(final_existed && FileIsExist(backup_path,FILE_COMMON))
      FileMove(backup_path,FILE_COMMON,final_path,FILE_COMMON|FILE_REWRITE);

   FileDelete(temp_path,FILE_COMMON);
   logger.Error("AtomicWrite","promote failed for " + final_path);
   return(false);
  }

#endif
