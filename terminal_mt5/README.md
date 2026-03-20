# MT5 Terminal Runtime Folder

This folder is intended for direct MT5 terminal usage.

Rules:
- Only MQL5 files (.mq5, .mqh)
- No markdown or documentation files
- This folder should be structured exactly as it will be placed inside the MT5 terminal

Purpose:
- Drop-in runnable EA environment
- Contains EA, Include files, and all runtime modules

Suggested structure:

terminal_mt5/
  AuroraSentinel.mq5
  Include/
    ASC/
      Common/
      Discovery/
      Runtime/
      Layers/
      Publication/
      Presentation/

This folder is separate from blueprint and design documents.
