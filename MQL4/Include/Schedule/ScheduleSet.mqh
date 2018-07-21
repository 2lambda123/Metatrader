//+------------------------------------------------------------------+
//|                                                  ScheduleSet.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property description "Scheduling helper."
#property strict

#include <Generic\LinkedList.mqh>
#include <Schedule\Schedule.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ScheduleSet : public CLinkedList<Schedule *>
  {
public:
   string            Name;
   bool              DeleteSchedulesOnClear;
   bool              IsActive(datetime when);
   void              Clear(bool deleteSchedules=true);
   string            ToString();
   void              ScheduleSet();
   void             ~ScheduleSet();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ScheduleSet::ScheduleSet():CLinkedList<Schedule *>()
  {
   this.DeleteSchedulesOnClear=true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ScheduleSet::~ScheduleSet()
  {
   this.Clear(this.DeleteSchedulesOnClear);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string  ScheduleSet::ToString(void)
  {
   return this.Name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleSet::Clear(bool deleteSchedules=true)
  {
   if(deleteSchedules)
     {
      CLinkedListNode<Schedule*>*node=this.First();

      delete node.Value();

      do
        {
         node=node.Next();
         delete node.Value();
        }
      while(this.Last()!=node);
     }

   CLinkedList<Schedule *>::Clear();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ScheduleSet::IsActive(datetime when)
  {
   bool out=false;

   CLinkedListNode<Schedule*>*node=this.First();
   Schedule *s=node.Value();
   out=node.Value().IsActive(when);

   do
     {
      node=node.Next();
      s=node.Value();
      out=node.Value().IsActive(when);
      if(out==true) break;
     }
   while(this.Last()!=node);

   return out;
  }
//+------------------------------------------------------------------+
