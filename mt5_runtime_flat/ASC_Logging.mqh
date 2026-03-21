#ifndef __ASC_LOGGING_MQH__
#define __ASC_LOGGING_MQH__

#include "ASC_Common.mqh"

class ASC_Logger
  {
private:
   string            m_log_file;
   bool              m_ready;
   bool              m_file_failure_warned;
   ASC_LogVerbosity  m_verbosity;

   void     WarnFileFailure(const string message)
            {
             if(m_file_failure_warned)
                return;
             m_file_failure_warned=true;
             Print(TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " | WARN | Logging | " + message + " | path=" + m_log_file);
            }

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
             m_file_failure_warned=false;
             m_verbosity=ASC_LOG_NORMAL;
            }

   void     Configure(const string log_file,const ASC_LogVerbosity verbosity)
            {
             m_log_file=log_file;
             m_ready=(m_log_file!="");
             m_file_failure_warned=false;
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
               {
                WarnFileFailure("file log append disabled: unable to open log file");
                return;
               }
             FileSeek(handle,0,SEEK_END);
             uint written=FileWriteString(handle,line + "\r\n");
             if(written==0)
               {
                WarnFileFailure("file log append disabled: unable to append log line");
                FileClose(handle);
                return;
               }
             FileFlush(handle);
             FileClose(handle);
            }

   void     Debug(const string scope,const string message)   { Write("DEBUG",scope,message); }
   void     Info(const string scope,const string message)    { Write("INFO",scope,message); }
   void     Warn(const string scope,const string message)    { Write("WARN",scope,message); }
   void     Error(const string scope,const string message)   { Write("ERROR",scope,message); }
  };

#endif
