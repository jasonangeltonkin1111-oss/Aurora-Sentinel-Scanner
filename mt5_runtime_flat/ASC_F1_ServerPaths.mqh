#ifndef __ASC_F1_SERVER_PATHS_MQH__
#define __ASC_F1_SERVER_PATHS_MQH__

#include "ASC_F1_Common.mqh"

bool ASC_F1_EnsureFolder(const string relative_path)
  {
   if(relative_path=="")
      return(false);
   if(FolderCreate(relative_path,FILE_COMMON))
      return(true);
   return(FolderCreate(relative_path,FILE_COMMON));
  }

bool ASC_F1_ResolveServerPaths(ASC_F1_ServerPaths &paths)
  {
   paths.server_raw=AccountInfoString(ACCOUNT_SERVER);
   paths.server_clean=ASC_F1_CleanServerName(paths.server_raw);
   paths.root_folder="AuroraSentinel";
   paths.server_folder=ASC_F1_JoinPath(paths.root_folder,paths.server_clean);
   paths.universe_folder=ASC_F1_JoinPath(paths.server_folder,"Symbol Universe");
   paths.dev_folder=ASC_F1_JoinPath(paths.server_folder,"Dev");
   paths.runtime_state_file=ASC_F1_JoinPath(paths.server_folder,paths.server_clean + " Runtime State.txt");
   paths.scheduler_state_file=ASC_F1_JoinPath(paths.server_folder,paths.server_clean + " Scheduler State.txt");
   paths.summary_file=ASC_F1_JoinPath(paths.server_folder,paths.server_clean + " Summary Top 5 per Basket.txt");
   paths.log_file=ASC_F1_JoinPath(paths.dev_folder,paths.server_clean + " Foundation Log.txt");

   if(!ASC_F1_EnsureFolder(paths.root_folder))
      return(false);
   if(!ASC_F1_EnsureFolder(paths.server_folder))
      return(false);
   if(!ASC_F1_EnsureFolder(paths.universe_folder))
      return(false);
   if(!ASC_F1_EnsureFolder(paths.dev_folder))
      return(false);
   return(true);
  }

#endif
