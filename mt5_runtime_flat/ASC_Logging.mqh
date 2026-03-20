#ifndef __ASC_LOGGING_MQH__
#define __ASC_LOGGING_MQH__

#include "ASC_Common.mqh"

class ASC_Logger
  {
private:
   string m_log_file;
   bool   m_ready;

public:
            ASC_Logger(void)
            {
             m_log_file="";
             m_ready=false;
            }

   void     Configure(const string log_file)
            {
             m_log_file=log_file;
             m_ready=(m_log_file!="");
            }

   void     Write(const string level,const string scope,const string message)
            {
             string line=TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " | " + level + " | " + scope + " | " + message;
             Print(line);
             if(!m_ready)
                return;

             int handle=FileOpen(m_log_file,FILE_READ|FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON|FILE_SHARE_READ|FILE_SHARE_WRITE);
             if(handle==INVALID_HANDLE)
                handle=FileOpen(m_log_file,FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_COMMON|FILE_SHARE_READ|FILE_SHARE_WRITE);
             if(handle==INVALID_HANDLE)
                return;
             FileSeek(handle,0,SEEK_END);
             FileWriteString(handle,line + "\r\n");
             FileFlush(handle);
             FileClose(handle);
            }

   void     Info(const string scope,const string message)    { Write("INFO",scope,message); }
   void     Warn(const string scope,const string message)    { Write("WARN",scope,message); }
   void     Error(const string scope,const string message)   { Write("ERROR",scope,message); }
  };

#endif
