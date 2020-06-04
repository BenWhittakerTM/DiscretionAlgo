//+------------------------------------------------------------------+
//|                                                      olvelol.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Global variables                                                 |
//+------------------------------------------------------------------+
   
   // Datetime for checking if we have a new candle
   datetime CandleTime;
   
   // Boolean variable for sending notifications or not
   input bool NotifyMe = True;
   
   // Boolean inputs for which sweep + cm combinations to look for
   input bool engulfing_m1 = True;
   input bool engulfing_m5 = True;
   input bool engulfing_m15 = True;
   input bool engulfing_m30 = True;
   input bool engulfing_h1 = True;
   input bool engulfing_h4 = True;
   input bool engulfing_d1 = True;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
  
   // Make sure changing timeframe on chart does not run OnInit again
   if (UninitializeReason() == REASON_CHARTCHANGE) {
      return(INIT_SUCCEEDED);
   }
   
   if (NotifyMe){
      SendNotification("Starting algo");
   }
   
   
   // Store datetime
   CandleTime = iTime(Symbol(), PERIOD_M1, 0);   
   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  
   // Make sure changing timeframe on chart does not run OnDeinit again
   if (UninitializeReason() == REASON_CHARTCHANGE) {
      return;
   }
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   
   // If last stored candle time is different from newest candle time, we have new candle
   if (CandleTime != iTime(Symbol(), PERIOD_M1, 0))
   {  
      // Store new candle time
      datetime PreviousCandleTime = CandleTime;
      CandleTime = iTime(Symbol(), PERIOD_M1, 0);
      
      if (engulfing_m1){
         if (CheckEngulfing(PERIOD_M1)){
            if (NotifyMe){
               SendNotification("Engulfing on " + Symbol() + ", timeframe " + PERIOD_M1);
            }
            printf("Engulfing on " + Symbol() + ", timeframe " + PERIOD_M1);
         }
      }
      if (engulfing_m5){
         if (CheckEngulfing(PERIOD_M5)){
            if (NotifyMe){
               SendNotification("Engulfing on " + Symbol() + ", timeframe " + PERIOD_M5);
            }
            printf("Engulfing on " + Symbol() + ", timeframe " + PERIOD_M5);
         }
      }
      if (engulfing_m15){
         if (CheckEngulfing(PERIOD_M15)){
            if (NotifyMe){
               SendNotification("Engulfing on " + Symbol() + ", timeframe " + PERIOD_M15);
            }
            printf("Engulfing on " + Symbol() + ", timeframe " + PERIOD_M15);
         }
      }
      if (engulfing_m30){
         if (CheckEngulfing(PERIOD_M30)){
            if (NotifyMe){
               SendNotification("Engulfing on " + Symbol() + ", timeframe " + PERIOD_M30);
            }
            printf("Engulfing on " + Symbol() + ", timeframe " + PERIOD_M30);
         }
      }
      if (engulfing_h1){
         if (CheckEngulfing(PERIOD_H1)){
            if (NotifyMe){
               SendNotification("Engulfing on " + Symbol() + ", timeframe " + PERIOD_H1);
            }
            printf("Engulfing on " + Symbol() + ", timeframe " + PERIOD_H1);
         }
      }
      if (engulfing_h4){
         if (CheckEngulfing(PERIOD_H4)){
            if (NotifyMe){
               SendNotification("Engulfing on " + Symbol() + ", timeframe " + PERIOD_H4);
            }
            printf("Engulfing on " + Symbol() + ", timeframe " + PERIOD_H4);
         }
      }
      if (engulfing_d1){
         if (CheckEngulfing(PERIOD_D1)){
            if (NotifyMe){
               SendNotification("Engulfing on " + Symbol() + ", timeframe " + PERIOD_D1);
            }
            printf("Engulfing on " + Symbol() + ", timeframe " + PERIOD_D1);
         }
      }
      
    }
  }

bool CheckEngulfing(ENUM_TIMEFRAMES timeframe){
   double high_last = iHigh(Symbol(), timeframe, 1);
   double low_last = iLow(Symbol(), timeframe, 1);
   double open_last = iOpen(Symbol(), timeframe, 1);
   double close_last = iClose(Symbol(), timeframe, 1);
   
   double high_previous = iHigh(Symbol(), timeframe, 2);
   double low_previous = iLow(Symbol(), timeframe, 2);
   double open_previous = iOpen(Symbol(), timeframe, 2);
   double close_previous = iClose(Symbol(), timeframe, 2);
   
   return ((high_last > high_previous && close_last < low_previous) || (low_last < low_previous && close_last > high_previous));
   
}
//+------------------------------------------------------------------+
