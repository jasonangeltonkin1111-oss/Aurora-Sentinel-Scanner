// Aurora Sentinel EA entry point
// This file will orchestrate runtime initialization and heartbeat

int OnInit()
{
    return(INIT_SUCCEEDED);
}

void OnTick()
{
    // heartbeat will be timer-driven, not tick-driven
}

void OnTimer()
{
    // main runtime heartbeat
}
