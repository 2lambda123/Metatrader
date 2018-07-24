//+------------------------------------------------------------------+
//|                                                    SymbolSet.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Common\SimpleParsers.mqh>
#include <Common\ValidationResult.mqh>
#include <Common\BaseLogger.mqh>
#include <MarketWatch\MarketWatch.mqh>
#include <Generic\ArrayList.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SymbolSet
  {
private:
   bool              _deleteLogger;
   SimpleParsers     _simpleParsers;
protected:
   BaseLogger       *_logger;
public:
   CArrayList<string>Symbols;
   void              SymbolSet(BaseLogger *aLogger=NULL);
   void             ~SymbolSet();
   bool              LoadSymbolsInMarketWatch();
   bool              ValidateSymbolsExist();
   void              AddSymbolsFromCsv(string csv);
   bool              DoSymbolsExist(ValidationResult *validationResult);
   bool              LoadSymbolHistory(string symbol,ENUM_TIMEFRAMES timeframe,bool force);
   bool              LoadSymbolsHistory(ENUM_TIMEFRAMES timeframe,bool force);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SymbolSet::SymbolSet(BaseLogger *aLogger=NULL)
  {
   if(aLogger==NULL)
     {
      this._logger=new BaseLogger();
      this._deleteLogger=true;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SymbolSet::AddSymbolsFromCsv(string csv)
  {
   string arr[];
   this._simpleParsers.ParseCsvLine(csv,arr);
   this.Symbols.AddRange(arr);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SymbolSet::~SymbolSet()
  {
   if(this._deleteLogger==true)
     {
      delete this._logger;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SymbolSet::DoSymbolsExist(ValidationResult *validationResult)
  {
   validationResult.Result=true;

   string message="";
   string sym;

   int k=this.Symbols.Count();

   if(k>0)
     {
      for(int i=0;i<k;i++)
        {
         if(!(this.Symbols.TryGetValue(i,sym)))
           {
            validationResult.Result=false;
           }
         if(!MarketWatch::DoesSymbolExist(sym,false))
           {
            validationResult.Result=false;
            message=StringConcatenate("Symbol %s does not exist.",sym);
            validationResult.AddMessage(message);
           }
         else
           {
            //message=StringConcatenate("Symbol %s exists.",result[i]);
           }
        }
     }
   return validationResult.Result;
  }
//+------------------------------------------------------------------+
//| Validate that watched pairs exist and are in the market watch.   |
//+------------------------------------------------------------------+
bool SymbolSet::ValidateSymbolsExist()
  {
   ValidationResult *validationResult=new ValidationResult();
   this.DoSymbolsExist(validationResult);

   if(validationResult.Result==false)
     {
      this._logger.Error(validationResult.Messages);
     }
   bool out=validationResult.Result;
   delete validationResult;
   return out;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SymbolSet::LoadSymbolsInMarketWatch()
  {
   bool out=false;
   string sym;

   int k=this.Symbols.Count();

   if(k>0)
     {
      for(int i=0;i<k;i++)
        {
         if(!(this.Symbols.TryGetValue(i,sym)))
           {
            out=false;
           }
         if(!MarketWatch::AddSymbolToMarketWatch(sym))
           {
            out=false;
           }
        }
     }
   return out;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SymbolSet::LoadSymbolHistory(string symbol,ENUM_TIMEFRAMES timeframe,bool force)
  {
   MqlRates r[];
   int ct= ArrayCopyRates(r,symbol,timeframe);
   if(ct>=0)
     {
      return true;
     }

   bool out=false;
   int error=GetLastError();
   if(error==4066 && force)
     {
      for(int i=0;i<30; i++)
        {
         Sleep(1000);
         ct=ArrayCopyRates(r,symbol,timeframe);
         if(ct<0)
           {
            //---- check the current bar time
            datetime timestamp=r[0].time;
            if(timestamp>=(TimeCurrent()-(timeframe*60)))
              {
               out=true;
               break;
              }
           }
        }
     }
   return out;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SymbolSet::LoadSymbolsHistory(ENUM_TIMEFRAMES timeframe,bool force)
  {
   bool out=false;
   string sym;

   int k=this.Symbols.Count();

   if(k>0)
     {
      for(int i=0;i<k;i++)
        {
         if(!(this.Symbols.TryGetValue(i,sym)))
           {
            out=false;
           }
         if(!this.LoadSymbolHistory(sym,timeframe,force))
           {
            out=false;
           }
        }
     }
   return out;
  }
//+------------------------------------------------------------------+
