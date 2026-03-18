//+------------------------------------------------------------------+
//|                                                  AFS_OutputDebug |
//|              Aegis Forge Scanner - Phase 1 / Step 5             |
//+------------------------------------------------------------------+
#ifndef __AFS_OUTPUTDEBUG_MQH__
#define __AFS_OUTPUTDEBUG_MQH__

#include "AFS_CoreTypes.mqh"

// Canonical trader-package contract (Phase 1 Step 1 safety-prep only).
// These constants make the intended live package explicit without disabling
// any legacy path or publication route that the working scanner still uses.
//
// Canonical live trader package:
//   AFS\<ServerKey>\trader\SUMMARY.txt
//   AFS\<ServerKey>\trader\<Symbol>.txt
//   AFS\<ServerKey>\logs\runtime.log
//   AFS\<ServerKey>\logs\write_failures.log
//   AFS\<ServerKey>\logs\debug.log
//
// Non-canonical but currently preserved because the live EA still references
// or publishes through them elsewhere in the codebase:
//   dev\            (includes Step 8 warm-state persistence)
//   FINAL_OUTPUT\   (legacy continuity/output path)
//   Trader-Data\    (legacy downstream trader-data export)
//   ActiveSummaryFile/scanner_summary.txt (legacy route-visible summary shell)
#define AFS_CANONICAL_TRADER_FOLDER_NAME           "trader"
#define AFS_CANONICAL_LOGS_FOLDER_NAME             "logs"
#define AFS_CANONICAL_TRADER_SUMMARY_FILE_NAME     "SUMMARY.txt"
#define AFS_CANONICAL_DOSSIER_FILE_EXTENSION       ".txt"

#define AFS_CANONICAL_RUNTIME_LOG_FILE_NAME        "runtime.log"
#define AFS_CANONICAL_WRITE_FAILURES_LOG_FILE_NAME "write_failures.log"
#define AFS_CANONICAL_DEBUG_LOG_FILE_NAME          "debug.log"

#define AFS_LEGACY_DEV_FOLDER_NAME                 "dev"
#define AFS_LEGACY_FINAL_OUTPUT_FOLDER_NAME        "FINAL_OUTPUT"
#define AFS_LEGACY_TRADER_DATA_FOLDER_NAME         "Trader-Data"

string AFS_OD_SanitizePathPart(string s)
  {
   if(StringLen(s) == 0)
      return "UNKNOWN_SERVER";

   StringReplace(s,"\\","_");
   StringReplace(s,"/","_");
   StringReplace(s,":","_");
   StringReplace(s,"*","_");
   StringReplace(s,"?","_");
   StringReplace(s,"\"","_");
   StringReplace(s,"<","_");
   StringReplace(s,">","_");
   StringReplace(s,"|","_");

   while(StringFind(s,"__") >= 0)
      StringReplace(s,"__","_");

   if(StringLen(s) == 0)
      s = "UNKNOWN_SERVER";

   return s;
  }

int AFS_OD_CommonFlag(const bool use_common_files)
  {
   return use_common_files ? FILE_COMMON : 0;
  }

string AFS_OD_BuildDailyFileName(const string prefix)
  {
   string d = TimeToString(TimeCurrent(), TIME_DATE);
   StringReplace(d, ".", "-");
   return prefix + "_" + d + ".txt";
  }

string AFS_OD_LogFilePath(const AFS_OutputPathState &paths)
  {
   return paths.LogsFolder + "\\" + AFS_OD_BuildDailyFileName("afs_log");
  }

string AFS_OD_DebugFilePath(const AFS_OutputPathState &paths)
  {
   return paths.DebugFolder + "\\" + AFS_OD_BuildDailyFileName("afs_debug");
  }

string AFS_OD_WriteFailuresFilePath(const AFS_OutputPathState &paths)
  {
   return paths.LogsFolder + "\\" + AFS_CANONICAL_WRITE_FAILURES_LOG_FILE_NAME;
  }

void AFS_OD_LogWriteFailure(const AFS_OutputPathState &paths,const string msg)
  {
   if(!paths.Ready)
      return;

   string err = "";
   string line = TimeToString(TimeCurrent(), TIME_DATE|TIME_SECONDS) +
                 " | WRITE_FAIL | " + msg;
   AFS_OD_AppendLine(AFS_OD_WriteFailuresFilePath(paths), paths.UseCommonFiles, line, err);
  }

bool AFS_OD_AppendLine(const string rel_file,const bool use_common_files,const string line,string &err)
  {
   err = "";

   int flags = FILE_READ | FILE_WRITE | FILE_TXT | FILE_ANSI;
   if(use_common_files)
      flags |= FILE_COMMON;

   ResetLastError();
   int h = FileOpen(rel_file, flags);
   if(h == INVALID_HANDLE)
     {
      err = "Unable to open log file: " + rel_file +
            " | LastError=" + IntegerToString(GetLastError());
      return false;
     }

   FileSeek(h, 0, SEEK_END);
   FileWriteString(h, line + "\r\n");
   FileClose(h);
   return true;
  }

bool AFS_OD_WriteEvent(const AFS_OutputPathState &paths,
                       const string              level,
                       const string              msg,
                       const bool                use_debug_sink,
                       string                   &err)
  {
   err = "";

   if(!paths.Ready)
     {
      err = "Output paths are not ready.";
      return false;
     }

   string line = TimeToString(TimeCurrent(), TIME_DATE|TIME_SECONDS) +
                 " | " + level + " | " + msg;

   string file = (use_debug_sink ? AFS_OD_DebugFilePath(paths)
                                 : AFS_OD_LogFilePath(paths));

   return AFS_OD_AppendLine(file, paths.UseCommonFiles, line, err);
  }

void AFS_OD_LogInfo(const AFS_OutputPathState &paths,const string msg)
  {
   string err = "";
   AFS_OD_WriteEvent(paths, "INFO", msg, false, err);
  }

void AFS_OD_LogWarn(const AFS_OutputPathState &paths,const string msg)
  {
   string err = "";
   AFS_OD_WriteEvent(paths, "WARN", msg, false, err);
  }

void AFS_OD_LogError(const AFS_OutputPathState &paths,const string msg)
  {
   string err = "";
   AFS_OD_WriteEvent(paths, "ERROR", msg, false, err);
  }

void AFS_OD_LogDebug(const AFS_OutputPathState &paths,const string msg)
  {
   string err = "";
   AFS_OD_WriteEvent(paths, "DEBUG", msg, true, err);
  }

bool AFS_OD_EnsureFolderWritable(const string rel_folder,const bool use_common_files,string &err)
  {
   string folder = rel_folder;
   StringReplace(folder,"/","\\");

   if(StringLen(folder) == 0)
     {
      err = "Output folder path is empty.";
      return false;
     }

   ResetLastError();
   FolderCreate(folder, AFS_OD_CommonFlag(use_common_files));

   string probe = folder + "\\.__afs_probe.tmp";
   int flags = FILE_WRITE | FILE_BIN;
   if(use_common_files)
      flags |= FILE_COMMON;

   ResetLastError();
   int h = FileOpen(probe, flags);
   if(h == INVALID_HANDLE)
     {
      err = "Unable to create/write folder probe: " + folder +
            " | LastError=" + IntegerToString(GetLastError());
      return false;
     }

   FileClose(h);
   FileDelete(probe, AFS_OD_CommonFlag(use_common_files));
   return true;
  }

bool AFS_OD_SetActiveRoute(AFS_OutputPathState &paths,const AFS_EffectiveMode mode,string &err)
  {
   if(!paths.Ready)
     {
      err = "Output paths are not ready.";
      return false;
     }

   if(mode == MODE_TRADER)
      paths.ActiveModeFolder = paths.TraderFolder;
   else
      paths.ActiveModeFolder = paths.DevFolder;

   paths.ActiveSummaryFile = paths.ActiveModeFolder + "\\scanner_summary.txt";
   paths.ActiveCsvFile     = paths.ActiveModeFolder + "\\universe_broker_view.csv";

   return true;
  }

bool AFS_OD_BuildOutputShell(const string root_folder_name,
                             const string server_name,
                             const bool   use_common_files,
                             AFS_OutputPathState &paths,
                             string &err)
  {
   err = "";
   ZeroMemory(paths);

   paths.UseCommonFiles = use_common_files;
   paths.RootFolderName = root_folder_name;
   paths.ServerKey      = AFS_OD_SanitizePathPart(server_name);

   string root = root_folder_name;
   if(StringLen(root) == 0)
      root = "AFS";

   paths.RootFolder       = root;
   paths.ServerFolder     = root + "\\" + paths.ServerKey;
   paths.RuntimeFolder    = ""; // retired in Phase 1 output architecture cleanup
   paths.LogsFolder       = paths.ServerFolder + "\\logs";
   paths.DebugFolder      = paths.ServerFolder + "\\debug";
   paths.DevFolder        = paths.ServerFolder + "\\dev";
   paths.TraderFolder     = paths.ServerFolder + "\\trader";

   // --- FIX: assign final output route before validating it ---
   paths.FinalOutputFolder = paths.RootFolder + "\\FINAL_OUTPUT";
   paths.FinalOutputFile   = paths.FinalOutputFolder + "\\" + paths.ServerKey + ".txt";
   paths.TraderDataFolder  = paths.RootFolder + "\\Trader-Data";
   paths.TraderDataFile    = paths.TraderDataFolder + "\\" + paths.ServerKey + "_TRADER_DATA.txt";

   if(!AFS_OD_EnsureFolderWritable(paths.RootFolder,        use_common_files, err)) return false;
   if(!AFS_OD_EnsureFolderWritable(paths.ServerFolder,      use_common_files, err)) return false;
   if(!AFS_OD_EnsureFolderWritable(paths.LogsFolder,        use_common_files, err)) return false;
   if(!AFS_OD_EnsureFolderWritable(paths.DebugFolder,       use_common_files, err)) return false;
   if(!AFS_OD_EnsureFolderWritable(paths.DevFolder,         use_common_files, err)) return false;
   if(!AFS_OD_EnsureFolderWritable(paths.DevFolder + "\\warm_state", use_common_files, err)) return false;
   if(!AFS_OD_EnsureFolderWritable(paths.TraderFolder,      use_common_files, err)) return false;
   if(!AFS_OD_EnsureFolderWritable(paths.FinalOutputFolder, use_common_files, err)) return false;

   paths.Ready = true;

   if(!AFS_OD_SetActiveRoute(paths, MODE_DEV, err))
      return false;

   return true;
  }

bool AFS_OD_WriteStep2Summary(const AFS_OutputPathState &paths,
                              const AFS_MemoryShell    &memory_shell,
                              const AFS_EffectiveMode   requested_mode,
                              const AFS_EffectiveMode   effective_mode,
                              const string              phase_tag,
                              const string              step_tag,
                              const string              build_label,
                              const int                 timer_seconds,
                              const int                 surface_batch_size,
                              const string              rotation_mode_text,
                              const string              surface_policy_text,
                              const string              batch_range_text,
                              string &err)
  {
   err = "";

   if(!paths.Ready)
     {
      err = "Cannot write runtime summary because output paths are not ready.";
      return false;
     }

   int flags = FILE_WRITE | FILE_TXT | FILE_ANSI;
   if(paths.UseCommonFiles)
      flags |= FILE_COMMON;

   int h = FileOpen(paths.ActiveSummaryFile, flags);
   if(h == INVALID_HANDLE)
     {
      err = "Unable to open summary file: " + paths.ActiveSummaryFile +
            " | LastError=" + IntegerToString(GetLastError());
      return false;
     }

   int excluded_count = memory_shell.BrokerSymbolCount - memory_shell.EligibleSymbolCount;

   FileSeek(h, 0, SEEK_SET);

   FileWriteString(h, "Aegis Forge Scanner - Runtime Summary\r\n");
   FileWriteString(h, "Phase: " + phase_tag + "\r\n");
   FileWriteString(h, "Step: " + step_tag + "\r\n");
   FileWriteString(h, "BuildLabel: " + build_label + "\r\n");
   FileWriteString(h, "RequestedMode: " + AFS_ModeToText(requested_mode) + "\r\n");
   FileWriteString(h, "EffectiveMode: " + AFS_ModeToText(effective_mode) + "\r\n");
   FileWriteString(h, "ServerKey: " + paths.ServerKey + "\r\n");
   FileWriteString(h, "UseCommonFiles: " + (paths.UseCommonFiles ? "true" : "false") + "\r\n");
   FileWriteString(h, "ServerFolder: " + paths.ServerFolder + "\r\n");
   FileWriteString(h, "RuntimeFolder: RETIRED\r\n");
   FileWriteString(h, "LogsFolder: " + paths.LogsFolder + "\r\n");
   FileWriteString(h, "DebugFolder: " + paths.DebugFolder + "\r\n");
   FileWriteString(h, "FinalOutputFolder: " + paths.FinalOutputFolder + "\r\n");
   FileWriteString(h, "FinalOutputFile: " + paths.FinalOutputFile + "\r\n");
   FileWriteString(h, "ActiveModeFolder: " + paths.ActiveModeFolder + "\r\n");
   FileWriteString(h, "ActiveSummaryFile: " + paths.ActiveSummaryFile + "\r\n");
   FileWriteString(h, "ActiveCsvFile: " + paths.ActiveCsvFile + "\r\n");
   FileWriteString(h, "MemoryReady: " + (memory_shell.Ready ? "true" : "false") + "\r\n");
   FileWriteString(h, "RunStartedAt: " + TimeToString(memory_shell.CreatedAt, TIME_DATE|TIME_SECONDS) + "\r\n");
   FileWriteString(h, "MemoryCreatedAt: " + TimeToString(memory_shell.CreatedAt, TIME_DATE|TIME_SECONDS) + "\r\n");
   FileWriteString(h, "MemoryLastTouchedAt: " + TimeToString(memory_shell.LastTouchedAt, TIME_DATE|TIME_SECONDS) + "\r\n");
   FileWriteString(h, "TimerSeconds: " + IntegerToString(timer_seconds) + "\r\n");
   FileWriteString(h, "SurfaceBatchSize: " + IntegerToString(surface_batch_size) + "\r\n");
   FileWriteString(h, "RotationMode: " + rotation_mode_text + "\r\n");
   FileWriteString(h, "SurfaceUpdatePolicy: " + surface_policy_text + "\r\n");
   FileWriteString(h, "SurfaceBatchRange: " + batch_range_text + "\r\n");
   FileWriteString(h, "LastSurfaceAt: " + TimeToString(memory_shell.LastSurfaceAt, TIME_DATE|TIME_SECONDS) + "\r\n");
   FileWriteString(h, "LastFullSurfaceAt: " + TimeToString(memory_shell.LastFullSurfaceAt, TIME_DATE|TIME_SECONDS) + "\r\n");
   FileWriteString(h, "LastSurfaceResetAt: " + TimeToString(memory_shell.LastSurfaceResetAt, TIME_DATE|TIME_SECONDS) + "\r\n");
   FileWriteString(h, "LastSurfaceResetReason: " + memory_shell.LastSurfaceResetReason + "\r\n");
   FileWriteString(h, "BrokerSymbolCount: " + IntegerToString(memory_shell.BrokerSymbolCount) + "\r\n");
   FileWriteString(h, "LoadedUniverseCount: " + IntegerToString(memory_shell.LoadedUniverseCount) + "\r\n");
   FileWriteString(h, "EligibleSymbolCount: " + IntegerToString(memory_shell.EligibleSymbolCount) + "\r\n");
   FileWriteString(h, "ExcludedSymbolCount: " + IntegerToString(excluded_count) + "\r\n");
   FileWriteString(h, "UniverseCount: " + IntegerToString(memory_shell.UniverseCount) + " (active scope)\r\n");
   FileWriteString(h, "ClassifiedSymbolCount: " + IntegerToString(memory_shell.ClassifiedSymbolCount) + "\r\n");
   FileWriteString(h, "UnresolvedSymbolCount: " + IntegerToString(memory_shell.UnresolvedSymbolCount) + "\r\n");
   FileWriteString(h, "SurfaceCount: " + IntegerToString(memory_shell.SurfaceCount) + " (active scope covered)\r\n");
   FileWriteString(h, "SurfaceLoadedCount: " + IntegerToString(memory_shell.SurfaceLoadedCount) + " (loaded universe covered)\r\n");
   FileWriteString(h, "DeepCount: " + IntegerToString(memory_shell.DeepCount) + "\r\n");
   FileWriteString(h, "FinalistCount: " + IntegerToString(memory_shell.FinalistCount) + "\r\n");
   FileWriteString(h, "ExchangeCoverageCount: " + IntegerToString(memory_shell.ExchangeCoverageCount) + "\r\n");
   FileWriteString(h, "ISINCoverageCount: " + IntegerToString(memory_shell.ISINCoverageCount) + "\r\n");
   FileWriteString(h, "BrokerSectorCoverageCount: " + IntegerToString(memory_shell.BrokerSectorCoverageCount) + "\r\n");
   FileWriteString(h, "BrokerIndustryCoverageCount: " + IntegerToString(memory_shell.BrokerIndustryCoverageCount) + "\r\n");
   FileWriteString(h, "BrokerClassCoverageCount: " + IntegerToString(memory_shell.BrokerClassCoverageCount) + "\r\n");
   FileWriteString(h, "SurfaceCursor: " + IntegerToString(memory_shell.SurfaceCursor) + "\r\n");
   FileWriteString(h, "SurfaceLastBatchCount: " + IntegerToString(memory_shell.SurfaceLastBatchCount) + "\r\n");
   FileWriteString(h, "SurfacePassCount: " + IntegerToString(memory_shell.SurfacePassCount) + "\r\n");
   FileWriteString(h, "SurfaceFreshCount: " + IntegerToString(memory_shell.SurfaceFreshCount) + "\r\n");
   FileWriteString(h, "SurfaceStaleCount: " + IntegerToString(memory_shell.SurfaceStaleCount) + "\r\n");
   FileWriteString(h, "SurfaceNoQuoteCount: " + IntegerToString(memory_shell.SurfaceNoQuoteCount) + "\r\n");
   FileWriteString(h, "SurfacePromotedCount: " + IntegerToString(memory_shell.SurfacePromotedCount) + "\r\n");
   FileWriteString(h, "SurfaceFirstSeenCount: " + IntegerToString(memory_shell.SurfaceFirstSeenCount) + "\r\n");
   FileWriteString(h, "SpecCount: " + IntegerToString(memory_shell.SpecCount) + " (active scope spec-touched)\r\n");
   FileWriteString(h, "SpecPassCount: " + IntegerToString(memory_shell.SpecPassCount) + "\r\n");
   FileWriteString(h, "SpecWeakCount: " + IntegerToString(memory_shell.SpecWeakCount) + "\r\n");
   FileWriteString(h, "SpecFailCount: " + IntegerToString(memory_shell.SpecFailCount) + "\r\n");
   FileWriteString(h, "SpecCursor: " + IntegerToString(memory_shell.SpecCursor) + "\r\n");

   FileClose(h);
   return true;
  }

#endif
