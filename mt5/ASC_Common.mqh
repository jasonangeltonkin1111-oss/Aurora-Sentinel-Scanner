#ifndef ASC_COMMON_MQH
#define ASC_COMMON_MQH

// ============================================================================
// ASC Common Contract
// Shared runtime vocabulary for early ASC implementation.
// This file defines canonical enums, reason containers, and foundational
// read-model structs only. It intentionally excludes market logic, ranking,
// storage I/O, and UI drawing.
// ============================================================================

// ============================================================================
// SECTION: Canonical enums
// Extend only by appending new values and updating the matching *Text helpers.
// ============================================================================

enum ASC_RuntimeMode
  {
   ASC_RUNTIME_BOOT = 0,
   ASC_RUNTIME_RESTORE,
   ASC_RUNTIME_WARMUP,
   ASC_RUNTIME_STEADY_STATE,
   ASC_RUNTIME_DEGRADED,
   ASC_RUNTIME_PAUSED,
   ASC_RUNTIME_RECOVERY_HOLD
  };

enum ASC_ServiceClass
  {
   ASC_SERVICE_BOOTSTRAP = 0,
   ASC_SERVICE_DELTA_FIRST,
   ASC_SERVICE_RETRY_FASTLANE,
   ASC_SERVICE_BACKLOG,
   ASC_SERVICE_CONTINUITY,
   ASC_SERVICE_PUBLISH_CRITICAL,
   ASC_SERVICE_OPTIONAL_ENRICHMENT,
   ASC_SERVICE_OPERATOR_REQUEST
  };

enum ASC_ServiceOutcome
  {
   ASC_OUTCOME_SUCCESS = 0,
   ASC_OUTCOME_SKIPPED,
   ASC_OUTCOME_DEFERRED,
   ASC_OUTCOME_NOT_READY,
   ASC_OUTCOME_INVALID_DATA,
   ASC_OUTCOME_FAILED,
   ASC_OUTCOME_BUDGET_EXCEEDED
  };

enum ASC_ContinuityOrigin
  {
   ASC_CONTINUITY_FRESH = 0,
   ASC_CONTINUITY_RESTORED_CURRENT,
   ASC_CONTINUITY_RESTORED_LAST_GOOD,
   ASC_CONTINUITY_MIXED,
   ASC_CONTINUITY_FROZEN,
   ASC_CONTINUITY_DEGRADED,
   ASC_CONTINUITY_REBUILT_CLEAN,
   ASC_CONTINUITY_RECOVERY_HOLD
  };

enum ASC_HydrationState
  {
   ASC_HYDRATION_EMPTY = 0,
   ASC_HYDRATION_RESTORE_PENDING,
   ASC_HYDRATION_MINIMUM_PENDING,
   ASC_HYDRATION_MINIMUM_READY,
   ASC_HYDRATION_PARTIAL,
   ASC_HYDRATION_CURRENT,
   ASC_HYDRATION_FROZEN
  };

enum ASC_PublicationState
  {
   ASC_PUBLICATION_BLOCKED = 0,
   ASC_PUBLICATION_PENDING_SAFE,
   ASC_PUBLICATION_READY,
   ASC_PUBLICATION_STAGED,
   ASC_PUBLICATION_COMMITTED,
   ASC_PUBLICATION_DEGRADED,
   ASC_PUBLICATION_WITHHELD
  };

enum ASC_LifecycleState
  {
   ASC_LIFECYCLE_NEW = 0,
   ASC_LIFECYCLE_DISCOVERED,
   ASC_LIFECYCLE_ACTIVE,
   ASC_LIFECYCLE_PENDING,
   ASC_LIFECYCLE_CLOSED,
   ASC_LIFECYCLE_DISABLED,
   ASC_LIFECYCLE_FROZEN,
   ASC_LIFECYCLE_ARCHIVED,
   ASC_LIFECYCLE_DISAPPEARED
  };

enum ASC_RecheckClass
  {
   ASC_RECHECK_STABLE_OPEN = 0,
   ASC_RECHECK_WEAK_OPEN,
   ASC_RECHECK_PENDING_UNCERTAIN,
   ASC_RECHECK_CLOSED_WITH_NEXT_OPEN,
   ASC_RECHECK_CLOSED_WITHOUT_NEXT_OPEN,
   ASC_RECHECK_DISABLED,
   ASC_RECHECK_STALE_FEED,
   ASC_RECHECK_PROMOTED_ACTIVE,
   ASC_RECHECK_DEEP_FROZEN_RETAINED,
   ASC_RECHECK_ARCHIVED_INACTIVE,
   ASC_RECHECK_DISAPPEARED_FROM_UNIVERSE
  };

// ============================================================================
// SECTION: Canonical text helpers
// Extend only when enum values are extended.
// ============================================================================

string ASC_RuntimeModeText(const ASC_RuntimeMode mode)
  {
   switch(mode)
     {
      case ASC_RUNTIME_RESTORE:        return("RESTORE");
      case ASC_RUNTIME_WARMUP:         return("WARMUP");
      case ASC_RUNTIME_STEADY_STATE:   return("STEADY_STATE");
      case ASC_RUNTIME_DEGRADED:       return("DEGRADED");
      case ASC_RUNTIME_PAUSED:         return("PAUSED");
      case ASC_RUNTIME_RECOVERY_HOLD:  return("RECOVERY_HOLD");
      default:                         return("BOOT");
     }
  }

string ASC_ServiceClassText(const ASC_ServiceClass service_class)
  {
   switch(service_class)
     {
      case ASC_SERVICE_DELTA_FIRST:         return("DELTA_FIRST");
      case ASC_SERVICE_RETRY_FASTLANE:      return("RETRY_FASTLANE");
      case ASC_SERVICE_BACKLOG:             return("BACKLOG");
      case ASC_SERVICE_CONTINUITY:          return("CONTINUITY");
      case ASC_SERVICE_PUBLISH_CRITICAL:    return("PUBLISH_CRITICAL");
      case ASC_SERVICE_OPTIONAL_ENRICHMENT: return("OPTIONAL_ENRICHMENT");
      case ASC_SERVICE_OPERATOR_REQUEST:    return("OPERATOR_REQUEST");
      default:                              return("BOOTSTRAP");
     }
  }

string ASC_ServiceOutcomeText(const ASC_ServiceOutcome outcome)
  {
   switch(outcome)
     {
      case ASC_OUTCOME_SKIPPED:          return("SKIPPED");
      case ASC_OUTCOME_DEFERRED:         return("DEFERRED");
      case ASC_OUTCOME_NOT_READY:        return("NOT_READY");
      case ASC_OUTCOME_INVALID_DATA:     return("INVALID_DATA");
      case ASC_OUTCOME_FAILED:           return("FAILED");
      case ASC_OUTCOME_BUDGET_EXCEEDED:  return("BUDGET_EXCEEDED");
      default:                           return("SUCCESS");
     }
  }

string ASC_ContinuityOriginText(const ASC_ContinuityOrigin origin)
  {
   switch(origin)
     {
      case ASC_CONTINUITY_RESTORED_CURRENT:    return("RESTORED_CURRENT");
      case ASC_CONTINUITY_RESTORED_LAST_GOOD:  return("RESTORED_LAST_GOOD");
      case ASC_CONTINUITY_MIXED:               return("MIXED");
      case ASC_CONTINUITY_FROZEN:              return("FROZEN");
      case ASC_CONTINUITY_DEGRADED:            return("DEGRADED");
      case ASC_CONTINUITY_REBUILT_CLEAN:       return("REBUILT_CLEAN");
      case ASC_CONTINUITY_RECOVERY_HOLD:       return("RECOVERY_HOLD");
      default:                                 return("FRESH");
     }
  }

string ASC_HydrationStateText(const ASC_HydrationState state)
  {
   switch(state)
     {
      case ASC_HYDRATION_RESTORE_PENDING: return("RESTORE_PENDING");
      case ASC_HYDRATION_MINIMUM_PENDING: return("MINIMUM_PENDING");
      case ASC_HYDRATION_MINIMUM_READY:   return("MINIMUM_READY");
      case ASC_HYDRATION_PARTIAL:         return("PARTIAL");
      case ASC_HYDRATION_CURRENT:         return("CURRENT");
      case ASC_HYDRATION_FROZEN:          return("FROZEN");
      default:                            return("EMPTY");
     }
  }

string ASC_PublicationStateText(const ASC_PublicationState state)
  {
   switch(state)
     {
      case ASC_PUBLICATION_PENDING_SAFE: return("PENDING_SAFE");
      case ASC_PUBLICATION_READY:        return("READY");
      case ASC_PUBLICATION_STAGED:       return("STAGED");
      case ASC_PUBLICATION_COMMITTED:    return("COMMITTED");
      case ASC_PUBLICATION_DEGRADED:     return("DEGRADED");
      case ASC_PUBLICATION_WITHHELD:     return("WITHHELD");
      default:                           return("BLOCKED");
     }
  }

string ASC_LifecycleStateText(const ASC_LifecycleState state)
  {
   switch(state)
     {
      case ASC_LIFECYCLE_DISCOVERED:  return("DISCOVERED");
      case ASC_LIFECYCLE_ACTIVE:      return("ACTIVE");
      case ASC_LIFECYCLE_PENDING:     return("PENDING");
      case ASC_LIFECYCLE_CLOSED:      return("CLOSED");
      case ASC_LIFECYCLE_DISABLED:    return("DISABLED");
      case ASC_LIFECYCLE_FROZEN:      return("FROZEN");
      case ASC_LIFECYCLE_ARCHIVED:    return("ARCHIVED");
      case ASC_LIFECYCLE_DISAPPEARED: return("DISAPPEARED");
      default:                        return("NEW");
     }
  }

string ASC_RecheckClassText(const ASC_RecheckClass recheck_class)
  {
   switch(recheck_class)
     {
      case ASC_RECHECK_WEAK_OPEN:                  return("WEAK_OPEN");
      case ASC_RECHECK_PENDING_UNCERTAIN:          return("PENDING_UNCERTAIN");
      case ASC_RECHECK_CLOSED_WITH_NEXT_OPEN:      return("CLOSED_WITH_NEXT_OPEN");
      case ASC_RECHECK_CLOSED_WITHOUT_NEXT_OPEN:   return("CLOSED_WITHOUT_NEXT_OPEN");
      case ASC_RECHECK_DISABLED:                   return("DISABLED");
      case ASC_RECHECK_STALE_FEED:                 return("STALE_FEED");
      case ASC_RECHECK_PROMOTED_ACTIVE:            return("PROMOTED_ACTIVE");
      case ASC_RECHECK_DEEP_FROZEN_RETAINED:       return("DEEP_FROZEN_RETAINED");
      case ASC_RECHECK_ARCHIVED_INACTIVE:          return("ARCHIVED_INACTIVE");
      case ASC_RECHECK_DISAPPEARED_FROM_UNIVERSE:  return("DISAPPEARED_FROM_UNIVERSE");
      default:                                     return("STABLE_OPEN");
     }
  }

// ============================================================================
// SECTION: Reason containers
// Shared reason language only. Domain-specific reason catalogs are defined in
// future extensions, but all contracts should use these fields.
// ============================================================================

struct ASC_ReasonSet
  {
   string         ReasonCode;
   string         ReasonDetail;
   string         ReasonContext;
  };

// ============================================================================
// SECTION: Foundational shared structs
// Add only shared contract fields here. Domain logic belongs elsewhere.
// ============================================================================

struct ASC_RuntimeConfig
  {
   bool           ScannerEnabled;
   int            TimerSeconds;
   int            MaxWorkItemsPerCycle;
   int            MaxRestoreItemsPerCycle;
   int            MaxPublishCommitsPerCycle;
   int            WarmupTargetMinutes;
   int            Layer1CoverageTargetMinutes;
   int            SnapshotCoverageTargetMinutes;
   int            SurfaceCoverageTargetMinutes;
   int            DeepCoverageTargetMinutes;
   bool           AllowDegradedPublication;
   bool           PauseRequested;
   bool           UseCommonFiles;
   string         SchemaVersion;
   string         BuildId;
  };

struct ASC_KernelCycleCounters
  {
   long           CycleSequence;
   long           CompletedCycles;
   long           SkippedReentryCycles;
   long           ConsecutiveReentrySkips;
   long           ConsecutiveOverrunCycles;
   long           DegradedEntries;
   long           RecoveryHoldEntries;
   datetime       LastCycleStartedAt;
   datetime       LastCycleFinishedAt;
   datetime       LastHeartbeatAt;
  };

struct ASC_ServiceLedgerEntry
  {
   ASC_ServiceClass   ServiceClass;
   ASC_ServiceOutcome Outcome;
   string             ServiceKey;
   string             Symbol;
   long               CycleSequence;
   datetime           StartedAt;
   datetime           FinishedAt;
   double             BudgetMs;
   double             CostMs;
   bool               UsedReservedBudget;
   ASC_ReasonSet      Reason;
  };

struct ASC_BudgetDebtSnapshot
  {
   double         CycleBudgetMs;
   double         ReservedPublishBudgetMs;
   double         UsedBudgetMs;
   double         RemainingBudgetMs;
   double         CycleDebtMs;
   double         CoverageDebtLayer1Minutes;
   double         CoverageDebtFastlaneMinutes;
   double         CoverageDebtSnapshotMinutes;
   double         CoverageDebtSurfaceMinutes;
   double         CoverageDebtDeepMinutes;
   double         CoverageDebtFrozenRecheckMinutes;
   double         CoverageDebtPublicationMinutes;
   double         CoverageDebtCleanupMinutes;
  };

struct ASC_CursorState
  {
   int            Layer1Index;
   int            SnapshotIndex;
   int            SurfaceIndex;
   int            DeepIndex;
   int            FastlaneIndex;
   int            PublicationIndex;
   int            CleanupIndex;
   long           FastlaneSequence;
   datetime       LastCoverageSampleAt;
  };

struct ASC_JournalEntryMetadata
  {
   string         TargetKind;
   string         TargetName;
   string         TempPath;
   string         FinalPath;
   string         PreviousGoodPath;
   string         SchemaVersion;
   string         BuildId;
   long           CycleSequence;
   datetime       CommitStartedAt;
   datetime       CommitFinishedAt;
   ASC_ServiceOutcome Outcome;
   ASC_ReasonSet  Reason;
  };

struct ASC_RuntimeRestoreOutcome
  {
   ASC_ServiceOutcome Outcome;
   ASC_RuntimeMode    RecommendedMode;
   ASC_ContinuityOrigin ContinuityOrigin;
   bool               JournalsInspected;
   bool               RuntimeStateLoaded;
   bool               UniverseLoaded;
   bool               SymbolContinuityLoaded;
   bool               CompatibilityHold;
   int                RestoredSymbolCount;
   int                RejectedSymbolCount;
   int                MigratableFileCount;
   int                CorruptFileCount;
   ASC_ReasonSet      Reason;
  };

struct ASC_SymbolShell
  {
   string             Symbol;
   string             CanonicalSymbol;
   string             Description;
   string             PrimaryBucket;
   ASC_LifecycleState LifecycleState;
   ASC_ContinuityOrigin ContinuityOrigin;
   ASC_HydrationState HydrationState;
   ASC_PublicationState PublicationState;
   ASC_RecheckClass   RecheckClass;
   bool               IsPromoted;
   bool               IsCustomSymbol;
   bool               IsFromCurrentDiscovery;
   datetime           LastTouchedAt;
   datetime           NextRecheckAt;
   ASC_ReasonSet      Reason;
  };

struct ASC_RuntimeSnapshot
  {
   ASC_RuntimeMode         Mode;
   ASC_ContinuityOrigin    ContinuityOrigin;
   ASC_HydrationState      HydrationState;
   ASC_PublicationState    RuntimePublicationState;
   ASC_KernelCycleCounters CycleCounters;
   ASC_BudgetDebtSnapshot  BudgetDebt;
   ASC_CursorState         Cursors;
   datetime                ServerTime;
   datetime                LocalTime;
   datetime                LastRestoreAt;
   datetime                LastSafePublishAt;
   datetime                LastSummaryEligibleAt;
   int                     KnownSymbolCount;
   int                     WarmSymbolsReadyCount;
   int                     PendingSymbolCount;
   int                     PromotedSymbolCount;
   bool                    WarmupComplete;
   bool                    DegradedActive;
   bool                    RecoveryBlocked;
   string                  PublishHeadline;
   ASC_ReasonSet           Reason;
  };

#endif // ASC_COMMON_MQH
