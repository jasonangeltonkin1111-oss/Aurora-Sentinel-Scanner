#ifndef ASC_LOGGER_MQH
#define ASC_LOGGER_MQH

#include "ASC_Common.mqh"

#define ASC_LOGGER_ROOT_PATH "AuroraSentinelCore\\Logs\\"
#define ASC_LOGGER_FILE_NAME ASC_LOGGER_ROOT_PATH "ASC_Debug.log"

static bool              g_asc_logger_started = false;
static ASC_RuntimeConfig g_asc_logger_config;

int ASC_Logger_OpenFlags(const bool use_common_files)
  {
   return(FILE_TXT | FILE_ANSI | FILE_READ | FILE_WRITE | FILE_SHARE_READ | FILE_SHARE_WRITE | (use_common_files ? FILE_COMMON : 0));
  }

string ASC_Logger_Timestamp()
  {
   datetime now = TimeCurrent();
   if(now <= 0)
      now = TimeLocal();
   return(TimeToString(now,TIME_DATE | TIME_SECONDS));
  }

void ASC_Logger_WriteLine(const string line)
  {
   const int handle = FileOpen(ASC_LOGGER_FILE_NAME,ASC_Logger_OpenFlags(g_asc_logger_config.UseCommonFiles));
   if(handle == INVALID_HANDLE)
     {
      Print("ASC_LOGGER_FALLBACK ",line);
      return;
     }

   FileSeek(handle,0,SEEK_END);
   FileWrite(handle,line);
   FileClose(handle);
  }

bool ASC_Logger_Start(const ASC_RuntimeConfig &config)
  {
   g_asc_logger_config = config;
   FolderCreate("AuroraSentinelCore",config.UseCommonFiles ? FILE_COMMON : 0);
   FolderCreate(ASC_LOGGER_ROOT_PATH,config.UseCommonFiles ? FILE_COMMON : 0);
   g_asc_logger_started = true;
   ASC_Logger_WriteLine(ASC_Logger_Timestamp() + " | INFO | LOGGER | ASC_Logger_Start | logger session started");
   return(true);
  }

void ASC_Logger_Stop(const string reason)
  {
   if(!g_asc_logger_started)
      return;

   ASC_Logger_WriteLine(ASC_Logger_Timestamp() + " | INFO | LOGGER | ASC_Logger_Stop | " + reason);
   g_asc_logger_started = false;
  }

void ASC_Logger_Log(const string level,
                    const string module,
                    const string function_name,
                    const string message)
  {
   const string line = ASC_Logger_Timestamp() + " | " + level + " | " + module + " | " + function_name + " | " + message;

   if(g_asc_logger_started)
      ASC_Logger_WriteLine(line);

   Print(line);
  }

void ASC_Logger_LogResult(const string module,
                          const string function_name,
                          const bool ok,
                          const string message)
  {
   ASC_Logger_Log(ok ? "INFO" : "ERROR",module,function_name,message);
  }

#endif
