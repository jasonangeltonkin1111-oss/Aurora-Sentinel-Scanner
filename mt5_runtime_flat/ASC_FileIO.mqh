#ifndef __ASC_FILEIO_MQH__
#define __ASC_FILEIO_MQH__

#include "ASC_Common.mqh"
#include "ASC_Logging.mqh"

string ASC_FileErrorText(const int code)
  {
   return("error " + IntegerToString(code));
  }

bool ASC_WriteTextFile(const string path,const string content)
  {
   uchar bytes[];
   int byte_count=StringToCharArray(content,bytes,0,StringLen(content));
   if(byte_count<0)
      return(false);

   int handle=FileOpen(path,FILE_WRITE|FILE_BIN|FILE_COMMON);
   if(handle==INVALID_HANDLE)
      return(false);

   bool ok=(FileWriteArray(handle,bytes,0,byte_count)==byte_count);
   FileFlush(handle);
   FileClose(handle);
   return(ok);
  }

bool ASC_ReadTextFile(const string path,string &content)
  {
   content="";
   if(!FileIsExist(path,FILE_COMMON))
      return(false);

   int handle=FileOpen(path,FILE_READ|FILE_BIN|FILE_COMMON|FILE_SHARE_READ|FILE_SHARE_WRITE);
   if(handle==INVALID_HANDLE)
      return(false);

   int size=(int)FileSize(handle);
   if(size>0)
     {
      uchar bytes[];
      ArrayResize(bytes,size);
      int read=FileReadArray(handle,bytes,0,size);
      if(read>0)
         content=CharArrayToString(bytes,0,read);
     }
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

   ResetLastError();
   if(!ASC_WriteTextFile(temp_path,content))
     {
      int error=GetLastError();
      logger.Error("AtomicWrite","temp write failed for " + final_path + " (" + ASC_FileErrorText(error) + ")");
      return(false);
     }

   ResetLastError();
   if(!ASC_ReadTextFile(temp_path,verify))
     {
      int error=GetLastError();
      FileDelete(temp_path,FILE_COMMON);
      logger.Error("AtomicWrite","temp validation read failed for " + final_path + " (" + ASC_FileErrorText(error) + ")");
      return(false);
     }

   verify=ASC_NormalizeTextForValidation(verify);
   if(verify!=expected)
     {
      FileDelete(temp_path,FILE_COMMON);
      logger.Error("AtomicWrite","temp validation mismatch for " + final_path + "; expected bytes=" + IntegerToString(StringLen(expected)) + ", actual bytes=" + IntegerToString(StringLen(verify)));
      return(false);
     }

   if(FileIsExist(backup_path,FILE_COMMON))
     {
      ResetLastError();
      if(!FileDelete(backup_path,FILE_COMMON))
        {
         int error=GetLastError();
         logger.Warn("AtomicWrite","could not clear prior last-good for " + final_path + " (" + ASC_FileErrorText(error) + ")");
        }
     }

   bool final_existed=FileIsExist(final_path,FILE_COMMON);
   if(final_existed)
     {
      ResetLastError();
      if(!FileMove(final_path,FILE_COMMON,backup_path,FILE_COMMON|FILE_REWRITE))
        {
         int error=GetLastError();
         FileDelete(temp_path,FILE_COMMON);
         logger.Error("AtomicWrite","could not preserve last-good for " + final_path + " (" + ASC_FileErrorText(error) + ")");
         return(false);
        }
     }

   ResetLastError();
   if(FileMove(temp_path,FILE_COMMON,final_path,FILE_COMMON|FILE_REWRITE))
     {
      logger.Debug("AtomicWrite","promoted " + final_path + (final_existed ? " with last-good backup" : ""));
      return(true);
     }

   int promote_error=GetLastError();
   if(final_existed && FileIsExist(backup_path,FILE_COMMON))
     {
      ResetLastError();
      if(!FileMove(backup_path,FILE_COMMON,final_path,FILE_COMMON|FILE_REWRITE))
        {
         int restore_error=GetLastError();
         logger.Error("AtomicWrite","promote failed for " + final_path + " and rollback also failed (promote " + ASC_FileErrorText(promote_error) + ", rollback " + ASC_FileErrorText(restore_error) + ")");
        }
      else
         logger.Warn("AtomicWrite","promote failed for " + final_path + " but last-good was restored (" + ASC_FileErrorText(promote_error) + ")");
     }
   else
      logger.Error("AtomicWrite","promote failed for " + final_path + " (" + ASC_FileErrorText(promote_error) + ")");

   FileDelete(temp_path,FILE_COMMON);
   return(false);
  }

#endif
