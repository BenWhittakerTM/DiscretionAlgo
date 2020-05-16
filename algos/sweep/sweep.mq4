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

   // Inputs
   // TODO: How to calculate candles for each timeframe?
   input int number_of_bars = 300;
   
   // Arrays for storing open, high, close and time for various timeframes   
   double highs_m15[];
   double closes_m15[];
   double opens_m15[];
   double lows_m15[];
   datetime times_m15[];
   
   double highs_m30[];
   double closes_m30[];
   double opens_m30[];
   double lows_m30[];
   datetime times_m30[];
   
   double highs_h1[];
   double closes_h1[];
   double opens_h1[];
   double lows_h1[];
   datetime times_h1[];
   
   double highs_h4[];
   double closes_h4[];
   double opens_h4[];
   double lows_h4[];
   datetime times_h4[];
   
   double highs_d1[];
   double closes_d1[];
   double opens_d1[];
   double lows_d1[];
   datetime times_d1[];
   
   // Datetime for checking if we have a new candle
   datetime CandleTime;
   
   // Boolean variable for sending notifications or not
   input bool NotifyMe = False;
   
   // Boolean inputs for which sweep + cm combinations to look for
   input bool sweep_h4_cm_h1 = True;
   input bool sweep_h1_cm_m15 = True;

//+------------------------------------------------------------------+
//| Setup of arrays to use                                           |
//+------------------------------------------------------------------+
void SetupArrays(){ 

   // Resize arrays to use the number of bars in input variable
   ArrayResize(highs_m15, number_of_bars);
   ArrayResize(closes_m15, number_of_bars);
   ArrayResize(opens_m15, number_of_bars);
   ArrayResize(lows_m15, number_of_bars);
   ArrayResize(times_m15, number_of_bars);
   
   ArrayResize(highs_m30, number_of_bars);
   ArrayResize(closes_m30, number_of_bars);
   ArrayResize(opens_m30, number_of_bars);
   ArrayResize(lows_m30, number_of_bars);
   ArrayResize(times_m30, number_of_bars);
   
   ArrayResize(highs_h1, number_of_bars);
   ArrayResize(closes_h1, number_of_bars);
   ArrayResize(opens_h1, number_of_bars);
   ArrayResize(lows_h1, number_of_bars);
   ArrayResize(times_h1, number_of_bars);
   
   ArrayResize(highs_h4, number_of_bars);
   ArrayResize(closes_h4, number_of_bars);
   ArrayResize(opens_h4, number_of_bars);
   ArrayResize(lows_h4, number_of_bars);
   ArrayResize(times_h4, number_of_bars);
   
   ArrayResize(highs_d1, number_of_bars);
   ArrayResize(closes_d1, number_of_bars);
   ArrayResize(opens_d1, number_of_bars);
   ArrayResize(lows_d1, number_of_bars);
   ArrayResize(times_d1, number_of_bars);
   
   // Fill arrays
   for(int i=0; i < number_of_bars; i++){
      highs_m15[i] = iHigh(Symbol(), PERIOD_M15, number_of_bars - i);
      closes_m15[i] = iClose(Symbol(), PERIOD_M15, number_of_bars - i);
      opens_m15[i] = iOpen(Symbol(), PERIOD_M15, number_of_bars - i);
      lows_m15[i] = iLow(Symbol(), PERIOD_M15, number_of_bars - i);
      times_m15[i] = iTime(Symbol(), PERIOD_M15, number_of_bars - i);
   
      highs_m30[i] = iHigh(Symbol(), PERIOD_M30, number_of_bars - i);
      closes_m30[i] = iClose(Symbol(), PERIOD_M30, number_of_bars - i);
      opens_m30[i] = iOpen(Symbol(), PERIOD_M30, number_of_bars - i);
      lows_m30[i] = iLow(Symbol(), PERIOD_M30, number_of_bars - i);
      times_m30[i] = iTime(Symbol(), PERIOD_M30, number_of_bars - i);
   
      highs_h1[i] = iHigh(Symbol(), PERIOD_H1, number_of_bars - i);
      closes_h1[i] = iClose(Symbol(), PERIOD_H1, number_of_bars - i);
      opens_h1[i] = iOpen(Symbol(), PERIOD_H1, number_of_bars - i);
      lows_h1[i] = iLow(Symbol(), PERIOD_H1, number_of_bars - i);
      times_h1[i] = iTime(Symbol(), PERIOD_H1, number_of_bars - i);
   
      highs_h4[i] = iHigh(Symbol(), PERIOD_H4, number_of_bars - i);
      closes_h4[i] = iClose(Symbol(), PERIOD_H4, number_of_bars - i);
      opens_h4[i] = iOpen(Symbol(), PERIOD_H4, number_of_bars - i);
      lows_h4[i] = iLow(Symbol(), PERIOD_H4, number_of_bars - i);
      times_h4[i] = iTime(Symbol(), PERIOD_H4, number_of_bars - i);
      
      highs_d1[i] = iHigh(Symbol(), PERIOD_D1, number_of_bars - i);
      closes_d1[i] = iClose(Symbol(), PERIOD_D1, number_of_bars - i);
      opens_d1[i] = iOpen(Symbol(), PERIOD_D1, number_of_bars - i);
      lows_d1[i] = iLow(Symbol(), PERIOD_D1, number_of_bars - i);
      times_d1[i] = iTime(Symbol(), PERIOD_D1, number_of_bars - i);
   }
}
  
//+------------------------------------------------------------------+
//| Conditional update of arrays                                     |
//+------------------------------------------------------------------+
void UpdateArrays(bool update_m15, bool update_m30, bool update_h1, bool update_h4, bool update_d1){

   if(update_m15){
      for(int i=0; i < number_of_bars; i++){
         highs_m15[i] = iHigh(Symbol(), PERIOD_M15, number_of_bars - i);
         closes_m15[i] = iClose(Symbol(), PERIOD_M15, number_of_bars - i);
         opens_m15[i] = iOpen(Symbol(), PERIOD_M15, number_of_bars - i);
         lows_m15[i] = iLow(Symbol(), PERIOD_M15, number_of_bars - i);
         times_m15[i] = iTime(Symbol(), PERIOD_M15, number_of_bars - i);
      }
   }
   
   if(update_m30){
      for(int i=0; i < number_of_bars; i++){
         highs_m30[i] = iHigh(Symbol(), PERIOD_M30, number_of_bars - i);
         closes_m30[i] = iClose(Symbol(), PERIOD_M30, number_of_bars - i);
         opens_m30[i] = iOpen(Symbol(), PERIOD_M30, number_of_bars - i);
         lows_m30[i] = iLow(Symbol(), PERIOD_M30, number_of_bars - i);
         times_m30[i] = iTime(Symbol(), PERIOD_M30, number_of_bars - i);
      }
   }
   
   if(update_h1){
      for(int i=0; i < number_of_bars; i++){
         highs_h1[i] = iHigh(Symbol(), PERIOD_H1, number_of_bars - i);
         closes_h1[i] = iClose(Symbol(), PERIOD_H1, number_of_bars - i);
         opens_h1[i] = iOpen(Symbol(), PERIOD_H1, number_of_bars - i);
         lows_h1[i] = iLow(Symbol(), PERIOD_H1, number_of_bars - i);
         times_h1[i] = iTime(Symbol(), PERIOD_H1, number_of_bars - i);
      }
   }
   
   if(update_h4){
      for(int i=0; i < number_of_bars; i++){
         highs_h4[i] = iHigh(Symbol(), PERIOD_H4, number_of_bars - i);
         closes_h4[i] = iClose(Symbol(), PERIOD_H4, number_of_bars - i);
         opens_h4[i] = iOpen(Symbol(), PERIOD_H4, number_of_bars - i);
         lows_h4[i] = iLow(Symbol(), PERIOD_H4, number_of_bars - i);
         times_h4[i] = iTime(Symbol(), PERIOD_H4, number_of_bars - i);
      }
   }
   
   if (update_d1){
      for (int i = 0; i < number_of_bars; i++){
         highs_d1[i] = iHigh(Symbol(), PERIOD_D1, number_of_bars - i);
         closes_d1[i] = iClose(Symbol(), PERIOD_D1, number_of_bars - i);
         opens_d1[i] = iOpen(Symbol(), PERIOD_D1, number_of_bars - i);
         lows_d1[i] = iLow(Symbol(), PERIOD_D1, number_of_bars - i);
         times_d1[i] = iTime(Symbol(), PERIOD_D1, number_of_bars - i);
      }
   }
}

//+------------------------------------------------------------------+
//| Sweep + CM function                                              |
//+------------------------------------------------------------------+
void SweepWithCM(ENUM_TIMEFRAMES timeframe_sweep, ENUM_TIMEFRAMES timeframe_cm, bool initial_search){
   
   // Initialize arrays to use
   double highs_sweep[];
   double closes_sweep[];
   double opens_sweep[];
   double lows_sweep[];
   double times_sweep[];
   
   double highs_cm[];
   double closes_cm[];
   double opens_cm[];
   double lows_cm[];
   double times_cm[];
   
   // First find out which arrays to search for the sweep
   if (timeframe_sweep == PERIOD_M15){
      ArrayCopy(highs_sweep, highs_m15);
      ArrayCopy(closes_sweep, closes_m15);
      ArrayCopy(opens_sweep, opens_m15);
      ArrayCopy(lows_sweep, lows_m15);
      ArrayCopy(times_sweep, times_m15);
   }
   else if (timeframe_sweep == PERIOD_M30){
      ArrayCopy(highs_sweep, highs_m30);
      ArrayCopy(closes_sweep, closes_m30);
      ArrayCopy(opens_sweep, opens_m30);
      ArrayCopy(lows_sweep, lows_m30);
      ArrayCopy(times_sweep, times_m30);
   }
   else if (timeframe_sweep == PERIOD_H1){
      ArrayCopy(highs_sweep, highs_h1);
      ArrayCopy(closes_sweep, closes_h1);
      ArrayCopy(opens_sweep, opens_h1);
      ArrayCopy(lows_sweep, lows_h1);
      ArrayCopy(times_sweep, times_h1);
   }
   else if (timeframe_sweep == PERIOD_H4){
      ArrayCopy(highs_sweep, highs_h4);
      ArrayCopy(closes_sweep, closes_h4);
      ArrayCopy(opens_sweep, opens_h4);
      ArrayCopy(lows_sweep, lows_h4);
      ArrayCopy(times_sweep, times_h4);
   }
   else if (timeframe_sweep == PERIOD_D1){
      ArrayCopy(highs_sweep, highs_d1);
      ArrayCopy(closes_sweep, closes_d1);
      ArrayCopy(opens_sweep, opens_d1);
      ArrayCopy(lows_sweep, lows_d1);
      ArrayCopy(times_sweep, times_d1);
   }
   
   // And for the CM
   if (timeframe_cm == PERIOD_M15){
      ArrayCopy(highs_cm, highs_m15);
      ArrayCopy(closes_cm, closes_m15);
      ArrayCopy(opens_cm, opens_m15);
      ArrayCopy(lows_cm, lows_m15);
      ArrayCopy(times_cm, times_m15);
   }
   else if (timeframe_cm == PERIOD_M30){
      ArrayCopy(highs_cm, highs_m30);
      ArrayCopy(closes_cm, closes_m30);
      ArrayCopy(opens_cm, opens_m30);
      ArrayCopy(lows_cm, lows_m30);
      ArrayCopy(times_cm, times_m30);
   }
   else if (timeframe_cm == PERIOD_H1){
      ArrayCopy(highs_cm, highs_h1);
      ArrayCopy(closes_cm, closes_h1);
      ArrayCopy(opens_cm, opens_h1);
      ArrayCopy(lows_cm, lows_h1);
      ArrayCopy(times_cm, times_h1);
   }
   else if (timeframe_cm == PERIOD_H4){
      ArrayCopy(highs_cm, highs_h4);
      ArrayCopy(closes_cm, closes_h4);
      ArrayCopy(opens_cm, opens_h4);
      ArrayCopy(lows_cm, lows_h4);
      ArrayCopy(times_cm, times_h4);
   }
   else if (timeframe_cm == PERIOD_D1){
      ArrayCopy(highs_cm, highs_d1);
      ArrayCopy(closes_cm, closes_d1);
      ArrayCopy(opens_cm, opens_d1);
      ArrayCopy(lows_cm, lows_d1);
      ArrayCopy(times_cm, times_d1);
   }

   // Find all sweeps
   for(int i=1;i < number_of_bars - 1;i++){
   
      if(highs_sweep[i] > highs_sweep[i-1] && highs_sweep[i] > highs_sweep[i+1]){
      
         double swing_high = highs_sweep[i];
      
            for(int j=i;j < number_of_bars;j++){
            
               if (closes_sweep[j] > swing_high){
                  break;
               }
               else if(swing_high >= opens_sweep[j] && swing_high >= closes_sweep[j] && highs_sweep[j] > swing_high){
               
                  // To look for CM, find highest high in sweep
                  double highest_high_in_sweep = 0;
                  int highest_high_in_sweep_index = 0;
                  
                  // TODO: Look for highest high on CM timeframe, not sweep timeframe!!!!
                  // TODO: This should be in the sweeping candle
                  for (int k=i+1; k < j; k++){
                     if (highs_sweep[k] >= highest_high_in_sweep){
                        highest_high_in_sweep = highs_sweep[k];
                        highest_high_in_sweep_index = k;
                     }
                  }
               
                  // Look for swing lows in sweep before highest high, on CM timeframe
                  int last_swing_low_cm_index = 0;
                  for (int k=1; k < number_of_bars-1; k++){
                     
                     // Find swing low ..                                           between swing high and sweep ..                                   lower than the swing high ..    before highest high in sweep
                     if (lows_cm[k] < lows_cm[k-1] && lows_cm[k] < lows_cm[k+1] && times_cm[k] > times_sweep[i] && times_cm[k] < times_sweep[j + 1] && lows_cm[k] < swing_high && times_cm[k] < times_sweep[highest_high_in_sweep_index + 1]){
                        last_swing_low_cm_index = k;
                     }
                  }
                  
                  // Check if we close below this swing low, on CM timeframe
                  for (int l=last_swing_low_cm_index; l < number_of_bars; l++){
                     if (closes_cm[l] < lows_cm[last_swing_low_cm_index]){
                        
                        // TODO: Must this be after sweep?
                        if (times_cm[l] > times_sweep[j]){
                        
                           // TODO: Initial sweep report all?
                           if (NotifyMe){
                              SendNotification("Sweep(h) + CM on " + Symbol() + " sweep_timeframe " + timeframe_sweep + "m cm timeframe: " + timeframe_sweep + "m");
                           }
                           printf("Sweep(h) + CM on " + Symbol() + " sweep_timeframe " + timeframe_sweep + "m cm timeframe: " + timeframe_cm + "m");
                           printf("Swing high at " + TimeToString(times_sweep[i]) + ", sweep above at " + TimeToString(times_sweep[j]));
                           printf("Highest high in sweep at " + TimeToString(times_sweep[highest_high_in_sweep_index]));
                           printf("Last swing low in sweep at " + TimeToString(times_cm[last_swing_low_cm_index]) + ", closed below at " + TimeToString(times_cm[l]));
                           break;
                        }
                     }
                  }
               }
            }
         }
      }
}

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
   
   // Obtain initial candle info
   SetupArrays();
   
   // Store datetime
   CandleTime = iTime(Symbol(), PERIOD_M1, 0);
   
   // Run initial sweep + cm search
   if (sweep_h4_cm_h1 == True){
      SweepWithCM(PERIOD_H4, PERIOD_H1, True);
   }
   if (sweep_h1_cm_m15 == True){
      SweepWithCM(PERIOD_H1, PERIOD_M15, True);
   }
   
   
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
      
      // Sjekke hvilke timeframes som har nytt candle close
      
      // Oppdater disse timeframe arrayene
      
      // Hvis bruker vil kjøre h4 h1 sweep + cm, og h1 timeframe har ny candle close: kjør sweepwithcm(h4, h1);
      
    }
  }
//+------------------------------------------------------------------+
