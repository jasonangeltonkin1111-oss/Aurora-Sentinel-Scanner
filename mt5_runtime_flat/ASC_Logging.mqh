#ifndef __ASC_LOGGING_MQH__
#define __ASC_LOGGING_MQH__

#include "ASC_Common.mqh"

class ASC_Logger
  {
private:
   string            m_log_file;
   bool              m_ready;
   ASC_LogVerbosity  m_verbosity;

   bool     ShouldWrite(const string level)
            {
             if(level=="ERROR")
                return(true);
             if(level=="WARN")
                return(m_verbosity>=ASC_LOG_NORMAL);
             if(level=="DEBUG")
                return(m_verbosity>=ASC_LOG_DEBUG);
             return(m_verbosity>=ASC_LOG_NORMAL);
            }

public:
            ASC_Logger(void)
            {
             m_log_file="";
             m_ready=false;
             m_verbosity=ASC_LOG_NORMAL;
            }

   void     Configure(const string log_file,const ASC_LogVerbosity verbosity)
            {
             m_log_file=log_file;
             m_ready=(m_log_file!="");
             m_verbosity=verbosity;
            }

   void     Write(const string level,const string scope,const string message)
            {
             if(!ShouldWrite(level))
                return;

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

   void     Debug(const string scope,const string message)   { Write("DEBUG",scope,message); }
   void     Info(const string scope,const string message)    { Write("INFO",scope,message); }
   void     Warn(const string scope,const string message)    { Write("WARN",scope,message); }
   void     Error(const string scope,const string message)   { Write("ERROR",scope,message); }
  };

#endif
