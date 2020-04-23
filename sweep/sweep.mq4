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

   // EDIT THIS VARIABLE TO CHANGE NUMBER OF BARS
   const int number_of_bars = 300;

   // Arrays for storing open, high, close and time for our candles
   double highs[300];
   double closes[300];
   double opens[300];
   double lows[300];
   datetime times[300];
   
   // Datetime for checking if we have a new candle
   datetime CandleTime;
   
   // Boolean variable for sending notifications or not
   bool NotifyMe = True;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   // Setup arrays for obtaining open, high, close and time for our candles
   double highs_raw[];
   double closes_raw[];
   double opens_raw[];
   double lows_raw[];
   datetime times_raw[];
  
   ArraySetAsSeries(highs_raw, true);
   ArraySetAsSeries(closes_raw, true);
   ArraySetAsSeries(opens_raw, true);
   ArraySetAsSeries(lows_raw, true);
   ArraySetAsSeries(times_raw, true);

   // Obtain latest candles
   ENUM_TIMEFRAMES timeframe = Period();  
   int copied_high = CopyHigh(Symbol(), timeframe, 1, number_of_bars, highs_raw);
   int copied_close = CopyClose(Symbol(), timeframe, 1, number_of_bars, closes_raw);
   int copied_open = CopyOpen(Symbol(), timeframe, 1, number_of_bars, opens_raw);
   int copied_low = CopyOpen(Symbol(), timeframe, 1, number_of_bars, lows_raw);
   int copied_time = CopyTime(Symbol(), timeframe, 1, number_of_bars, times_raw);
   
   // Reverse order so that highest index is the latest candle, store in global arrays
   for(int c=0; c < number_of_bars; c++){
      highs[c] = highs_raw[number_of_bars - c - 1];
      closes[c] = closes_raw[number_of_bars - c - 1];
      opens[c] = opens_raw[number_of_bars - c - 1];
      lows[c] = lows_raw[number_of_bars - c - 1];
      times[c] = times_raw[number_of_bars - c - 1];
   }
   
   // Store datetime
   CandleTime = iTime(Symbol(), 0, 0);
   
   if (NotifyMe){
      SendNotification("Starting algo");
   }
   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   
   // If last stored candle time is different from newest candle time, we have new candle
   if (CandleTime != iTime(Symbol(), 0, 0))
   {  
      // Store new candle time
      datetime PreviousCandleTime = CandleTime;
      CandleTime = iTime(Symbol(), 0, 0);
      
      // Shift all elements in our arrays to the left, except last one
      for (int i = 0; i < number_of_bars - 1; i++){
         highs[i] = highs[i+1];
         closes[i] = closes[i+1];
         opens[i] = opens[i+1];
         lows[i] = lows[i+1];
         times[i] = times[i+1];
      }
      
      // Store latest candle values at end of arrays
      highs[number_of_bars-1] = High[1];
      closes[number_of_bars-1] = Close[1];
      opens[number_of_bars-1] = Open[1];
      lows[number_of_bars-1] = Low[1];
      times[number_of_bars-1] = PreviousCandleTime;
      
      // Look for sweep high
      for(int i=1;i < number_of_bars - 1;i++)
      {
         if(highs[i] > highs[i-1] && highs[i] > highs[i+1])
         {
            double swing_high = highs[i];
            for(int j=i;j < number_of_bars;j++)
            {
               if (closes[j] > swing_high)
               {
                  break;
               }
               else if(swing_high >= opens[j] && swing_high >= closes[j] && highs[j] > swing_high)
               {
                  if (j == number_of_bars - 1){
                     if (NotifyMe){
                        SendNotification("Sweep(h) " + Symbol() + TimeToString(times[j]));
                     }
                     printf("Found pattern");
                     printf("Swing high = %f at time %s", swing_high, TimeToString(times[i]));
                     printf("Sweep with open = %f, high = %f, close = %f at time = %s", opens[j], highs[j], closes[j], TimeToString(times[j]));
                     printf("At index %f", j);
                  }                  
               }
            }
         }
      }
      
      // Look for sweep low
      for(int i=1;i < number_of_bars - 1;i++)
      {
         if(lows[i] < lows[i-1] && lows[i] < lows[i+1])
         {
            double swing_low = lows[i];
            for(int j=i;j < number_of_bars;j++)
            {
               if (closes[j] < swing_low)
               {
                  break;
               }
               else if(swing_low <= opens[j] && swing_low <= closes[j] && lows[j] < swing_low)
               {
                  if (j == number_of_bars - 1){
                     if (NotifyMe){
                        SendNotification("Sweep(l) " + Symbol() + TimeToString(times[j]));
                     }
                     printf("Found pattern");
                     printf("Swing low = %f at time %s", swing_low, TimeToString(times[i]));
                     printf("Sweep with open = %f, low = %f, close = %f at time = %s", opens[j], lows[j], closes[j], TimeToString(times[j]));
                     printf("At index %f", j);
                  }                  
               }
            }
         }
      }  
   }
  }
//+------------------------------------------------------------------+
