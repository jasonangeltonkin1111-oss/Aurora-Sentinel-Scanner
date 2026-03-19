#ifndef ASC_STORAGE_MQH
#define ASC_STORAGE_MQH

#include "ASC_Common.mqh"

#define ASC_STORAGE_RUNTIME_STATE_SCHEMA "ASC_RUNTIME_STATE_V1"
#define ASC_STORAGE_RUNTIME_TARGET_KIND  "runtime-state"

// ============================================================================
// ASC Storage Phase 1 Shell
// Runtime-state persistence only. This unit intentionally excludes market,
// conditions, surface, summary, broker, and symbol persistence concerns.
// ============================================================================

enum ASC_RuntimeStateCondition
  {
   ASC_RUNTIME_STATE_MISSING = 0,
   ASC_RUNTIME_STATE_COMPATIBLE,
   ASC_RUNTIME_STATE_INCOMPATIBLE,
   ASC_RUNTIME_STATE_CORRUPT
  };

string ASC_RuntimeStateConditionText(const ASC_RuntimeStateCondition condition)
  {
   switch(condition)
     {
      case ASC_RUNTIME_STATE_COMPATIBLE:   return("COMPATIBLE");
      case ASC_RUNTIME_STATE_INCOMPATIBLE: return("INCOMPATIBLE");
      case ASC_RUNTIME_STATE_CORRUPT:      return("CORRUPT");
      default:                             return("MISSING");
     }
  }

struct ASC_RuntimeStatePayload
  {
   string               SchemaVersion;
   string               BuildId;
   datetime             EncodedAt;
   ASC_RuntimeSnapshot  Snapshot;
  };

struct ASC_RuntimeStateLoadResult
  {
   ASC_RuntimeStateCondition Condition;
   bool                     FilePresent;
   bool                     PayloadDecoded;
   bool                     PayloadValidated;
   bool                     LastGoodAttempted;
   bool                     LastGoodLoaded;
   string                   SourcePath;
   string                   PreviousGoodPath;
   ASC_RuntimeStatePayload   Payload;
   ASC_ReasonSet            Reason;
  };

bool ASC_TryReadWholeFile(const string path,const ASC_RuntimeConfig &config,string &content);

string ASC_StorageSanitizePathToken(const string value)
  {
   string sanitized = value;
   StringReplace(sanitized,"\\","-");
   StringReplace(sanitized,"/","-");
   StringReplace(sanitized,":","-");
   StringReplace(sanitized,"*","-");
   StringReplace(sanitized,"?","-");
   StringReplace(sanitized,"\"","-");
   StringReplace(sanitized,"<","-");
   StringReplace(sanitized,">","-");
   StringReplace(sanitized,"|","-");
   StringReplace(sanitized," ","-");
   while(StringFind(sanitized,"--") >= 0)
      StringReplace(sanitized,"--","-");
   if(sanitized == "")
      sanitized = "default";
   return(sanitized);
  }

string ASC_StorageInstanceKey(const ASC_RuntimeConfig &config)
  {
   string account_login = IntegerToString((int)AccountInfoInteger(ACCOUNT_LOGIN));
   string company = ASC_StorageSanitizePathToken(AccountInfoString(ACCOUNT_COMPANY));
   string server = ASC_StorageSanitizePathToken(AccountInfoString(ACCOUNT_SERVER));
   string chart = ASC_StorageSanitizePathToken(_Symbol + "-" + IntegerToString((int)_Period));
   string build_id = ASC_StorageSanitizePathToken(config.BuildId);
   if(build_id == "")
      build_id = "build";
   return(company + "-" + server + "-" + account_login + "-" + chart + "-" + build_id);
  }

string ASC_StorageRoot(const ASC_RuntimeConfig &config)
  {
   return("AuroraSentinel/phase1/" + ASC_StorageInstanceKey(config));
  }

string ASC_RuntimeStateFolder(const ASC_RuntimeConfig &config)
  {
   return(ASC_StorageRoot(config) + "/runtime-state");
  }

string ASC_RuntimeJournalFolder(const ASC_RuntimeConfig &config)
  {
   return(ASC_StorageRoot(config) + "/journal");
  }

string ASC_RuntimeStateFinalPath(const ASC_RuntimeConfig &config)
  {
   return(ASC_RuntimeStateFolder(config) + "/runtime-state.txt");
  }

string ASC_RuntimeStateLastGoodPath(const ASC_RuntimeConfig &config)
  {
   return(ASC_RuntimeStateFolder(config) + "/runtime-state.last-good.txt");
  }

string ASC_RuntimeStateTempPath(const ASC_RuntimeConfig &config,const string commit_token)
  {
   return(ASC_RuntimeStateFolder(config) + "/runtime-state." + ASC_StorageSanitizePathToken(commit_token) + ".tmp");
  }

string ASC_RuntimeStateJournalPath(const ASC_RuntimeConfig &config,const string commit_token)
  {
   return(ASC_RuntimeJournalFolder(config) + "/runtime-state." + ASC_StorageSanitizePathToken(commit_token) + ".journal");
  }

int ASC_StorageFileFlags(const ASC_RuntimeConfig &config)
  {
   int flags = FILE_TXT | FILE_ANSI;
   if(config.UseCommonFiles)
      flags |= FILE_COMMON;
  return(flags);
  }

bool ASC_StorageEnsureFolder(const string path,const ASC_RuntimeConfig &config)
  {
   ResetLastError();
   if(FolderCreate(path,config.UseCommonFiles))
      return(true);
   ResetLastError();
   return(FileGetInteger(path,FILE_EXISTS,config.UseCommonFiles) != 0);
  }

bool ASC_StorageEnsureRuntimeTree(const ASC_RuntimeConfig &config)
  {
   return(ASC_StorageEnsureFolder("AuroraSentinel",config) &&
          ASC_StorageEnsureFolder("AuroraSentinel/phase1",config) &&
          ASC_StorageEnsureFolder(ASC_StorageRoot(config),config) &&
          ASC_StorageEnsureFolder(ASC_RuntimeStateFolder(config),config) &&
          ASC_StorageEnsureFolder(ASC_RuntimeJournalFolder(config),config));
  }

bool ASC_StorageDeleteIfExists(const string path,const ASC_RuntimeConfig &config)
  {
   if(!FileIsExist(path,config.UseCommonFiles))
      return(true);
   return(FileDelete(path,config.UseCommonFiles));
  }

string ASC_NewCommitToken()
  {
   return(IntegerToString((int)TimeCurrent()) + "-" + IntegerToString((int)GetTickCount()));
  }

void ASC_AssignReason(ASC_ReasonSet &reason,const string code,const string detail,const string context)
  {
   reason.ReasonCode = code;
   reason.ReasonDetail = detail;
   reason.ReasonContext = context;
  }

string BuildRuntimeStatePayload(const ASC_RuntimeConfig &config,const ASC_RuntimeSnapshot &snapshot)
  {
   string payload = "schema=" + config.SchemaVersion + "\n";
   payload += "storage_schema=" + (string)ASC_STORAGE_RUNTIME_STATE_SCHEMA + "\n";
   payload += "build_id=" + config.BuildId + "\n";
   payload += "encoded_at=" + IntegerToString((int)TimeCurrent()) + "\n";
   payload += "mode=" + ASC_RuntimeModeText(snapshot.Mode) + "\n";
   payload += "continuity_origin=" + ASC_ContinuityOriginText(snapshot.ContinuityOrigin) + "\n";
   payload += "hydration_state=" + ASC_HydrationStateText(snapshot.HydrationState) + "\n";
   payload += "publication_state=" + ASC_PublicationStateText(snapshot.RuntimePublicationState) + "\n";
   payload += "server_time=" + IntegerToString((int)snapshot.ServerTime) + "\n";
   payload += "local_time=" + IntegerToString((int)snapshot.LocalTime) + "\n";
   payload += "last_restore_at=" + IntegerToString((int)snapshot.LastRestoreAt) + "\n";
   payload += "last_safe_publish_at=" + IntegerToString((int)snapshot.LastSafePublishAt) + "\n";
   payload += "last_summary_eligible_at=" + IntegerToString((int)snapshot.LastSummaryEligibleAt) + "\n";
   payload += "known_symbol_count=" + IntegerToString(snapshot.KnownSymbolCount) + "\n";
   payload += "warm_symbols_ready_count=" + IntegerToString(snapshot.WarmSymbolsReadyCount) + "\n";
   payload += "pending_symbol_count=" + IntegerToString(snapshot.PendingSymbolCount) + "\n";
   payload += "promoted_symbol_count=" + IntegerToString(snapshot.PromotedSymbolCount) + "\n";
   payload += "warmup_complete=" + (snapshot.WarmupComplete ? "1" : "0") + "\n";
   payload += "degraded_active=" + (snapshot.DegradedActive ? "1" : "0") + "\n";
   payload += "recovery_blocked=" + (snapshot.RecoveryBlocked ? "1" : "0") + "\n";
   payload += "publish_headline=" + snapshot.PublishHeadline + "\n";
   return(payload);
  }

bool ValidateRuntimeStatePayload(const string payload,ASC_ReasonSet &reason)
  {
   if(payload == "")
     {
      ASC_AssignReason(reason,"RUNTIME_STATE_EMPTY","runtime-state payload was empty","ValidateRuntimeStatePayload");
      return(false);
     }

   if(StringFind(payload,"storage_schema=" + (string)ASC_STORAGE_RUNTIME_STATE_SCHEMA) < 0)
     {
      ASC_AssignReason(reason,"RUNTIME_STATE_SCHEMA_MISSING","runtime-state payload did not include the phase-1 storage schema marker","ValidateRuntimeStatePayload");
      return(false);
     }

   if(StringFind(payload,"mode=") < 0 || StringFind(payload,"hydration_state=") < 0)
     {
      ASC_AssignReason(reason,"RUNTIME_STATE_REQUIRED_KEYS_MISSING","runtime-state payload omitted required shell fields","ValidateRuntimeStatePayload");
      return(false);
     }

   reason.ReasonCode = "";
   reason.ReasonDetail = "";
   reason.ReasonContext = "";
   return(true);
  }

bool WriteRuntimeStateTemp(const ASC_RuntimeConfig &config,const string temp_path,const string payload,ASC_ReasonSet &reason)
  {
   if(!ASC_StorageEnsureRuntimeTree(config))
     {
      ASC_AssignReason(reason,"RUNTIME_STATE_FOLDER_CREATE_FAILED","unable to create runtime-state folder",ASC_RuntimeStateFolder(config));
      return(false);
     }

   int handle = FileOpen(temp_path,FILE_WRITE | ASC_StorageFileFlags(config));
   if(handle == INVALID_HANDLE)
     {
      ASC_AssignReason(reason,"RUNTIME_STATE_TEMP_OPEN_FAILED","unable to open runtime-state temp file for writing",temp_path);
      return(false);
     }

   FileWriteString(handle,payload);
   FileFlush(handle);
   FileClose(handle);
   return(true);
  }

bool PromoteRuntimeStateTemp(const ASC_RuntimeConfig &config,const string temp_path,const string final_path,const string last_good_path,ASC_ReasonSet &reason)
  {
   string temp_payload = "";
   if(!ASC_TryReadWholeFile(temp_path,config,temp_payload))
     {
      ASC_AssignReason(reason,"RUNTIME_STATE_TEMP_READ_FAILED","unable to read runtime-state temp file before promotion",temp_path);
      return(false);
     }

   if(FileIsExist(final_path,config.UseCommonFiles))
     {
      string current_payload = "";
      if(!ASC_TryReadWholeFile(final_path,config,current_payload))
        {
         ASC_AssignReason(reason,"RUNTIME_STATE_LAST_GOOD_READ_FAILED","unable to read current runtime-state for last-good preservation",final_path);
         return(false);
        }

      ASC_StorageDeleteIfExists(last_good_path,config);
      if(!WriteRuntimeStateTemp(config,last_good_path,current_payload,reason))
        {
         ASC_AssignReason(reason,"RUNTIME_STATE_LAST_GOOD_COPY_FAILED","unable to write runtime-state last-good file",last_good_path);
         return(false);
        }
     }

   ASC_StorageDeleteIfExists(final_path,config);
   if(!WriteRuntimeStateTemp(config,final_path,temp_payload,reason))
     {
      ASC_AssignReason(reason,"RUNTIME_STATE_PROMOTE_FAILED","unable to promote runtime-state temp file to final path",final_path);
      return(false);
     }

   ASC_StorageDeleteIfExists(temp_path,config);
   return(true);
  }

bool ASC_TryReadWholeFile(const string path,const ASC_RuntimeConfig &config,string &content)
  {
   content = "";
   if(!FileIsExist(path,config.UseCommonFiles))
      return(false);

   int handle = FileOpen(path,FILE_READ | ASC_StorageFileFlags(config));
   if(handle == INVALID_HANDLE)
      return(false);

   content = FileReadString(handle,(int)FileSize(handle));
   FileClose(handle);
   return(true);
  }

string ASC_RuntimeStateField(const string payload,const string key)
  {
   string token = key + "=";
   int start = StringFind(payload,token);
   if(start < 0)
      return("");
   start += StringLen(token);
   int finish = StringFind(payload,"\n",start);
   if(finish < 0)
      finish = StringLen(payload);
   return(StringSubstr(payload,start,finish - start));
  }

bool ASC_ApplyRuntimeStateShell(const string payload,ASC_RuntimeStatePayload &runtime_payload,ASC_ReasonSet &reason)
  {
   runtime_payload.SchemaVersion         = ASC_RuntimeStateField(payload,"schema");
   runtime_payload.BuildId               = ASC_RuntimeStateField(payload,"build_id");
   runtime_payload.EncodedAt             = (datetime)StringToInteger(ASC_RuntimeStateField(payload,"encoded_at"));
   runtime_payload.Snapshot.ServerTime   = (datetime)StringToInteger(ASC_RuntimeStateField(payload,"server_time"));
   runtime_payload.Snapshot.LocalTime    = (datetime)StringToInteger(ASC_RuntimeStateField(payload,"local_time"));
   runtime_payload.Snapshot.LastRestoreAt = (datetime)StringToInteger(ASC_RuntimeStateField(payload,"last_restore_at"));
   runtime_payload.Snapshot.LastSafePublishAt = (datetime)StringToInteger(ASC_RuntimeStateField(payload,"last_safe_publish_at"));
   runtime_payload.Snapshot.LastSummaryEligibleAt = (datetime)StringToInteger(ASC_RuntimeStateField(payload,"last_summary_eligible_at"));
   runtime_payload.Snapshot.KnownSymbolCount = (int)StringToInteger(ASC_RuntimeStateField(payload,"known_symbol_count"));
   runtime_payload.Snapshot.WarmSymbolsReadyCount = (int)StringToInteger(ASC_RuntimeStateField(payload,"warm_symbols_ready_count"));
   runtime_payload.Snapshot.PendingSymbolCount = (int)StringToInteger(ASC_RuntimeStateField(payload,"pending_symbol_count"));
   runtime_payload.Snapshot.PromotedSymbolCount = (int)StringToInteger(ASC_RuntimeStateField(payload,"promoted_symbol_count"));
   runtime_payload.Snapshot.WarmupComplete = (ASC_RuntimeStateField(payload,"warmup_complete") == "1");
   runtime_payload.Snapshot.DegradedActive = (ASC_RuntimeStateField(payload,"degraded_active") == "1");
   runtime_payload.Snapshot.RecoveryBlocked = (ASC_RuntimeStateField(payload,"recovery_blocked") == "1");
   runtime_payload.Snapshot.PublishHeadline = ASC_RuntimeStateField(payload,"publish_headline");

   const string mode_text = ASC_RuntimeStateField(payload,"mode");
   const string continuity_text = ASC_RuntimeStateField(payload,"continuity_origin");
   const string hydration_text = ASC_RuntimeStateField(payload,"hydration_state");
   const string publication_text = ASC_RuntimeStateField(payload,"publication_state");

   runtime_payload.Snapshot.Mode = ASC_RUNTIME_BOOT;
   if(mode_text == ASC_RuntimeModeText(ASC_RUNTIME_RESTORE)) runtime_payload.Snapshot.Mode = ASC_RUNTIME_RESTORE;
   else if(mode_text == ASC_RuntimeModeText(ASC_RUNTIME_WARMUP)) runtime_payload.Snapshot.Mode = ASC_RUNTIME_WARMUP;
   else if(mode_text == ASC_RuntimeModeText(ASC_RUNTIME_STEADY_STATE)) runtime_payload.Snapshot.Mode = ASC_RUNTIME_STEADY_STATE;
   else if(mode_text == ASC_RuntimeModeText(ASC_RUNTIME_DEGRADED)) runtime_payload.Snapshot.Mode = ASC_RUNTIME_DEGRADED;
   else if(mode_text == ASC_RuntimeModeText(ASC_RUNTIME_PAUSED)) runtime_payload.Snapshot.Mode = ASC_RUNTIME_PAUSED;
   else if(mode_text == ASC_RuntimeModeText(ASC_RUNTIME_RECOVERY_HOLD)) runtime_payload.Snapshot.Mode = ASC_RUNTIME_RECOVERY_HOLD;

   runtime_payload.Snapshot.ContinuityOrigin = ASC_CONTINUITY_FRESH;
   if(continuity_text == ASC_ContinuityOriginText(ASC_CONTINUITY_RESTORED_CURRENT)) runtime_payload.Snapshot.ContinuityOrigin = ASC_CONTINUITY_RESTORED_CURRENT;
   else if(continuity_text == ASC_ContinuityOriginText(ASC_CONTINUITY_RESTORED_LAST_GOOD)) runtime_payload.Snapshot.ContinuityOrigin = ASC_CONTINUITY_RESTORED_LAST_GOOD;
   else if(continuity_text == ASC_ContinuityOriginText(ASC_CONTINUITY_MIXED)) runtime_payload.Snapshot.ContinuityOrigin = ASC_CONTINUITY_MIXED;
   else if(continuity_text == ASC_ContinuityOriginText(ASC_CONTINUITY_FROZEN)) runtime_payload.Snapshot.ContinuityOrigin = ASC_CONTINUITY_FROZEN;
   else if(continuity_text == ASC_ContinuityOriginText(ASC_CONTINUITY_DEGRADED)) runtime_payload.Snapshot.ContinuityOrigin = ASC_CONTINUITY_DEGRADED;
   else if(continuity_text == ASC_ContinuityOriginText(ASC_CONTINUITY_REBUILT_CLEAN)) runtime_payload.Snapshot.ContinuityOrigin = ASC_CONTINUITY_REBUILT_CLEAN;
   else if(continuity_text == ASC_ContinuityOriginText(ASC_CONTINUITY_RECOVERY_HOLD)) runtime_payload.Snapshot.ContinuityOrigin = ASC_CONTINUITY_RECOVERY_HOLD;

   runtime_payload.Snapshot.HydrationState = ASC_HYDRATION_EMPTY;
   if(hydration_text == ASC_HydrationStateText(ASC_HYDRATION_RESTORE_PENDING)) runtime_payload.Snapshot.HydrationState = ASC_HYDRATION_RESTORE_PENDING;
   else if(hydration_text == ASC_HydrationStateText(ASC_HYDRATION_MINIMUM_PENDING)) runtime_payload.Snapshot.HydrationState = ASC_HYDRATION_MINIMUM_PENDING;
   else if(hydration_text == ASC_HydrationStateText(ASC_HYDRATION_MINIMUM_READY)) runtime_payload.Snapshot.HydrationState = ASC_HYDRATION_MINIMUM_READY;
   else if(hydration_text == ASC_HydrationStateText(ASC_HYDRATION_PARTIAL)) runtime_payload.Snapshot.HydrationState = ASC_HYDRATION_PARTIAL;
   else if(hydration_text == ASC_HydrationStateText(ASC_HYDRATION_CURRENT)) runtime_payload.Snapshot.HydrationState = ASC_HYDRATION_CURRENT;
   else if(hydration_text == ASC_HydrationStateText(ASC_HYDRATION_FROZEN)) runtime_payload.Snapshot.HydrationState = ASC_HYDRATION_FROZEN;

   runtime_payload.Snapshot.RuntimePublicationState = ASC_PUBLICATION_BLOCKED;
   if(publication_text == ASC_PublicationStateText(ASC_PUBLICATION_PENDING_SAFE)) runtime_payload.Snapshot.RuntimePublicationState = ASC_PUBLICATION_PENDING_SAFE;
   else if(publication_text == ASC_PublicationStateText(ASC_PUBLICATION_READY)) runtime_payload.Snapshot.RuntimePublicationState = ASC_PUBLICATION_READY;
   else if(publication_text == ASC_PublicationStateText(ASC_PUBLICATION_STAGED)) runtime_payload.Snapshot.RuntimePublicationState = ASC_PUBLICATION_STAGED;
   else if(publication_text == ASC_PublicationStateText(ASC_PUBLICATION_COMMITTED)) runtime_payload.Snapshot.RuntimePublicationState = ASC_PUBLICATION_COMMITTED;
   else if(publication_text == ASC_PublicationStateText(ASC_PUBLICATION_DEGRADED)) runtime_payload.Snapshot.RuntimePublicationState = ASC_PUBLICATION_DEGRADED;
   else if(publication_text == ASC_PublicationStateText(ASC_PUBLICATION_WITHHELD)) runtime_payload.Snapshot.RuntimePublicationState = ASC_PUBLICATION_WITHHELD;

   if(runtime_payload.SchemaVersion == "")
     {
      ASC_AssignReason(reason,"RUNTIME_STATE_DECODE_SCHEMA_MISSING","decoded runtime-state payload did not include schema version","LoadRuntimeState");
      return(false);
     }

   return(true);
  }

bool LoadRuntimeState(const ASC_RuntimeConfig &config,const string target_path,ASC_RuntimeStateLoadResult &result)
  {
   string payload_text = "";
   result.Condition = ASC_RUNTIME_STATE_MISSING;
   result.FilePresent = FileIsExist(target_path,config.UseCommonFiles);
   result.SourcePath = target_path;
   result.PreviousGoodPath = ASC_RuntimeStateLastGoodPath(config);
   result.PayloadDecoded = false;
   result.PayloadValidated = false;
   result.LastGoodAttempted = false;
   result.LastGoodLoaded = false;

   if(!result.FilePresent)
     {
      ASC_AssignReason(result.Reason,"RUNTIME_STATE_NOT_FOUND","runtime-state file was not present",target_path);
      return(false);
     }

   if(!ASC_TryReadWholeFile(target_path,config,payload_text))
     {
      result.Condition = ASC_RUNTIME_STATE_CORRUPT;
      ASC_AssignReason(result.Reason,"RUNTIME_STATE_READ_FAILED","runtime-state file could not be read",target_path);
      return(false);
     }

   result.PayloadDecoded = ASC_ApplyRuntimeStateShell(payload_text,result.Payload,result.Reason);
   if(!result.PayloadDecoded)
     {
      result.Condition = ASC_RUNTIME_STATE_CORRUPT;
      return(false);
     }

   result.PayloadValidated = ValidateRuntimeStatePayload(payload_text,result.Reason);
   if(!result.PayloadValidated)
     {
      result.Condition = ASC_RUNTIME_STATE_CORRUPT;
      return(false);
     }

   if(result.Payload.SchemaVersion != config.SchemaVersion)
     {
      result.Condition = ASC_RUNTIME_STATE_INCOMPATIBLE;
      ASC_AssignReason(result.Reason,"RUNTIME_STATE_SCHEMA_INCOMPATIBLE","runtime-state schema version did not match current config",result.Payload.SchemaVersion);
      return(false);
     }

   if(config.BuildId != "" && result.Payload.BuildId != "" && result.Payload.BuildId != config.BuildId)
     {
      result.Condition = ASC_RUNTIME_STATE_INCOMPATIBLE;
      ASC_AssignReason(result.Reason,"RUNTIME_STATE_BUILD_INCOMPATIBLE","runtime-state build id did not match current build",result.Payload.BuildId);
      return(false);
     }

   result.Condition = ASC_RUNTIME_STATE_COMPATIBLE;
   result.Reason.ReasonCode = "";
   result.Reason.ReasonDetail = "";
   result.Reason.ReasonContext = "";
   return(true);
  }

ASC_RuntimeStateLoadResult InspectWriteJournal(const ASC_RuntimeConfig &config,const string journal_path)
  {
   ASC_RuntimeStateLoadResult result;
   ZeroMemory(result);
   result.SourcePath = journal_path;
   result.PreviousGoodPath = ASC_RuntimeStateLastGoodPath(config);

   string payload = "";
   if(!ASC_TryReadWholeFile(journal_path,config,payload))
     {
      result.Condition = ASC_RUNTIME_STATE_MISSING;
      ASC_AssignReason(result.Reason,"JOURNAL_NOT_FOUND","runtime-state journal was not present",journal_path);
      return(result);
     }

   if(StringFind(payload,"outcome=") < 0 || StringFind(payload,"target_kind=" + (string)ASC_STORAGE_RUNTIME_TARGET_KIND) < 0)
     {
      result.Condition = ASC_RUNTIME_STATE_CORRUPT;
      ASC_AssignReason(result.Reason,"JOURNAL_CORRUPT","runtime-state journal was unreadable or incomplete",journal_path);
      return(result);
     }

   result.Condition = ASC_RUNTIME_STATE_COMPATIBLE;
   return(result);
  }

bool ASC_WriteRuntimeJournalRecord(const ASC_RuntimeConfig &config,const string journal_path,const ASC_JournalEntryMetadata &meta,const string phase,ASC_ReasonSet &reason)
  {
   if(!ASC_StorageEnsureRuntimeTree(config))
     {
      ASC_AssignReason(reason,"JOURNAL_FOLDER_CREATE_FAILED","unable to create runtime journal folder",ASC_RuntimeJournalFolder(config));
      return(false);
     }

   int handle = FileOpen(journal_path,FILE_WRITE | ASC_StorageFileFlags(config));
   if(handle == INVALID_HANDLE)
     {
      ASC_AssignReason(reason,"JOURNAL_OPEN_FAILED","unable to open runtime-state journal file",journal_path);
      return(false);
     }

   string outcome_text = ASC_ServiceOutcomeText(meta.Outcome);
   string body = "phase=" + phase + "\n";
   body += "target_kind=" + meta.TargetKind + "\n";
   body += "target_name=" + meta.TargetName + "\n";
   body += "temp_path=" + meta.TempPath + "\n";
   body += "final_path=" + meta.FinalPath + "\n";
   body += "previous_good_path=" + meta.PreviousGoodPath + "\n";
   body += "schema_version=" + meta.SchemaVersion + "\n";
   body += "build_id=" + meta.BuildId + "\n";
   body += "cycle_sequence=" + IntegerToString((int)meta.CycleSequence) + "\n";
   body += "commit_started_at=" + IntegerToString((int)meta.CommitStartedAt) + "\n";
   body += "commit_finished_at=" + IntegerToString((int)meta.CommitFinishedAt) + "\n";
   body += "outcome=" + outcome_text + "\n";
   body += "reason_code=" + meta.Reason.ReasonCode + "\n";
   body += "reason_detail=" + meta.Reason.ReasonDetail + "\n";
   body += "reason_context=" + meta.Reason.ReasonContext + "\n";
   FileWriteString(handle,body);
   FileFlush(handle);
   FileClose(handle);
   return(true);
  }

bool StartRuntimeJournal(const ASC_RuntimeConfig &config,ASC_JournalEntryMetadata &meta,ASC_ReasonSet &reason)
  {
   meta.CommitStartedAt = TimeCurrent();
   return(ASC_WriteRuntimeJournalRecord(config,ASC_RuntimeStateJournalPath(config,meta.TargetName),meta,"start",reason));
  }

bool FinishRuntimeJournal(const ASC_RuntimeConfig &config,ASC_JournalEntryMetadata &meta,ASC_ReasonSet &reason)
  {
   meta.CommitFinishedAt = TimeCurrent();
   return(ASC_WriteRuntimeJournalRecord(config,ASC_RuntimeStateJournalPath(config,meta.TargetName),meta,"finish",reason));
  }

bool CleanupRuntimeJournal(const ASC_RuntimeConfig &config,const string commit_token)
  {
   return(ASC_StorageDeleteIfExists(ASC_RuntimeStateJournalPath(config,commit_token),config));
  }

bool ASC_RestoreRuntimeStateLastGood(const ASC_RuntimeConfig &config,ASC_RuntimeStateLoadResult &result)
  {
   result.LastGoodAttempted = true;
   ASC_RuntimeStateLoadResult fallback_result;
   ZeroMemory(fallback_result);
   if(!LoadRuntimeState(config,ASC_RuntimeStateLastGoodPath(config),fallback_result))
      return(false);

   result = fallback_result;
   result.LastGoodAttempted = true;
   result.LastGoodLoaded = true;
   result.Payload.Snapshot.ContinuityOrigin = ASC_CONTINUITY_RESTORED_LAST_GOOD;
   return(true);
  }

bool ASC_RestoreRuntimeStateCompatibility(const ASC_RuntimeConfig &config,ASC_RuntimeStateLoadResult &result)
  {
   ZeroMemory(result);
   if(LoadRuntimeState(config,ASC_RuntimeStateFinalPath(config),result))
     {
      result.Payload.Snapshot.ContinuityOrigin = ASC_CONTINUITY_RESTORED_CURRENT;
      return(true);
     }

   if(result.Condition == ASC_RUNTIME_STATE_CORRUPT || result.Condition == ASC_RUNTIME_STATE_INCOMPATIBLE)
      ASC_RestoreRuntimeStateLastGood(config,result);

   return(false);
  }

bool ASC_CommitRuntimeStateClassA(const ASC_RuntimeConfig &config,const ASC_RuntimeSnapshot &snapshot,ASC_JournalEntryMetadata &meta,ASC_ReasonSet &reason)
  {
   const string commit_token = ASC_NewCommitToken();
   const string final_path = ASC_RuntimeStateFinalPath(config);
   const string last_good_path = ASC_RuntimeStateLastGoodPath(config);
   const string temp_path = ASC_RuntimeStateTempPath(config,commit_token);
   const string payload = BuildRuntimeStatePayload(config,snapshot);

   meta.TargetKind = ASC_STORAGE_RUNTIME_TARGET_KIND;
   meta.TargetName = commit_token;
   meta.TempPath = temp_path;
   meta.FinalPath = final_path;
   meta.PreviousGoodPath = last_good_path;
   meta.SchemaVersion = config.SchemaVersion;
   meta.BuildId = config.BuildId;
   meta.Outcome = ASC_OUTCOME_FAILED;
   meta.CommitFinishedAt = 0;

   if(!ValidateRuntimeStatePayload(payload,reason))
     {
      meta.Reason = reason;
      return(false);
     }

   if(!StartRuntimeJournal(config,meta,reason))
     {
      meta.Reason = reason;
      return(false);
     }

   if(!WriteRuntimeStateTemp(config,temp_path,payload,reason))
     {
      meta.Reason = reason;
      meta.Outcome = ASC_OUTCOME_FAILED;
      FinishRuntimeJournal(config,meta,reason);
      return(false);
     }

   if(!PromoteRuntimeStateTemp(config,temp_path,final_path,last_good_path,reason))
     {
      meta.Reason = reason;
      meta.Outcome = ASC_OUTCOME_FAILED;
      FinishRuntimeJournal(config,meta,reason);
      return(false);
     }

   meta.Outcome = ASC_OUTCOME_SUCCESS;
   meta.Reason.ReasonCode = "";
   meta.Reason.ReasonDetail = "";
   meta.Reason.ReasonContext = "";

   if(!FinishRuntimeJournal(config,meta,reason))
      return(false);

   return(CleanupRuntimeJournal(config,commit_token));
  }

#endif // ASC_STORAGE_MQH
