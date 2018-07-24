//+------------------------------------------------------------------+
//|                                                        Utils.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <stdlib.mqh>
#include <Generic\ArrayList.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Utils
  {
public:
   static long       OpenChart(string symbol,ENUM_TIMEFRAMES timeframe);
   static long       OpenChartIfMissing(string symbol,ENUM_TIMEFRAMES timeframe);
   static long       GetChartId(string symbol,ENUM_TIMEFRAMES timeframe);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long Utils::OpenChart(string symbol,ENUM_TIMEFRAMES timeframe)
  {
   long chartId=ChartOpen(symbol,timeframe);
   if(chartId==0)
     {
      Print("the chart didn't open, error: ",GetLastError());
      Print(ErrorDescription(GetLastError()));
      chartId=(-1);
     }
   return chartId;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long Utils::OpenChartIfMissing(string symbol,ENUM_TIMEFRAMES timeframe)
  {
   long chartId=GetChartId(symbol,timeframe);
   if(chartId==-1)
     {
      chartId=OpenChart(symbol,timeframe);
     }
   return chartId;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long Utils::GetChartId(string symbol,ENUM_TIMEFRAMES timeframe)
  {
   long chartId=ChartFirst();
   while(chartId>=0)
     {
      if(symbol==ChartSymbol(chartId) && timeframe==ChartPeriod(chartId))
        {
         break;
        }
      chartId=ChartNext(chartId);
     }
   return chartId;
  }
//+------------------------------------------------------------------+
