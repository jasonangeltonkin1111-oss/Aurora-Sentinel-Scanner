#ifndef __ASC_F1_FILEIO_MQH__
#define __ASC_F1_FILEIO_MQH__

#include "ASC_F1_Common.mqh"
#include "ASC_F1_Logging.mqh"

bool ASC_F1_WriteTextFile(const string path,const string content)
  {
   int handle=FileOpen(path,FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON);
   if(handle==INVALID_HANDLE)
      return(false);
   FileWriteString(handle,content);
   FileClose(handle);
   return(true);
  }

bool ASC_F1_ReadTextFile(const string path,string &content)
  {
   content="";
   if(!FileIsExist(path,FILE_COMMON))
      return(false);
   int handle=FileOpen(path,FILE_READ|FILE_TXT|FILE_ANSI|FILE_COMMON|FILE_SHARE_READ|FILE_SHARE_WRITE);
   if(handle==INVALID_HANDLE)
      return(false);
   while(!FileIsEnding(handle))
      content+=FileReadString(handle) + "\n";
   FileClose(handle);
   return(true);
  }

bool ASC_F1_AtomicWrite(const string final_path,const string content,ASC_F1_Logger &logger)
  {
   string temp_path=final_path + ".tmp";
   string backup_path=final_path + ".last-good";

   if(!ASC_F1_WriteTextFile(temp_path,content))
     {
      logger.Error("AtomicWrite","temp write failed for " + final_path);
      return(false);
     }

   if(FileIsExist(backup_path,FILE_COMMON))
      FileDelete(backup_path,FILE_COMMON);
   if(FileIsExist(final_path,FILE_COMMON))
      FileMove(final_path,FILE_COMMON,backup_path,FILE_COMMON|FILE_REWRITE);

   if(!FileMove(temp_path,FILE_COMMON,final_path,FILE_COMMON|FILE_REWRITE))
     {
      logger.Error("AtomicWrite","promote failed for " + final_path);
      return(false);
     }

   return(true);
  }

#endif
