//+------------------------------------------------------------------+
//|                                               ScheduleTests.mq4  |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property description "Tests functionality of the Schedule class."
#property strict
//#property script_show_inputs
#include <UnitTesting\BaseTestSuite.mqh>
#include <Generic\LinkedList.mqh>
#include <Schedule\Schedule.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ScheduleTests : BaseTestSuite
  {
private:
   Schedule         *s;
   void              AssertShouldBeInSchedule(string name,datetime time);
   void              AssertShouldBeInSchedule(string name,CLinkedList<datetime>*time);
   void              AssertShouldNotBeInSchedule(string name,datetime time);
   void              AssertShouldNotBeInSchedule(string name,CLinkedList<datetime>*time);
public:
   void              RunAllTests();
   void              CanGetExpectedStringRepresentation();
   void              CanScheduleByDay();
   void              RespectsStartMinute();
   void              RespectsEndMinute();
   void              RespectsStartHour();
   void              RespectsEndHour();
   void              ScheduleTests();
   void             ~ScheduleTests();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleTests::ScheduleTests()
  {
   ENUM_DAY_OF_WEEK StartDay=1;//Start Day
   ENUM_DAY_OF_WEEK EndDay=5;//End Day
   string   StartTime="01:15";//Start Time
   string   EndTime="14:45";//End Time
   this.s=new Schedule(StartDay,StartTime,EndDay,EndTime);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleTests::~ScheduleTests()
  {
   delete s;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleTests::AssertShouldBeInSchedule(string name,datetime time)
  {
   string message=StringConcatenate(s.ToString()," includes ",time);
   bool actual=s.IsActive(time);
   this.unitTest.assertTrue(name,message,actual);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleTests::AssertShouldBeInSchedule(string name,CLinkedList<datetime>*time)
  {
   int sz=time.Count();
   CLinkedListNode<datetime>*node=time.First();
   AssertShouldBeInSchedule(name,node.Value());

   while(node!=time.Last())
     {
      node=node.Next();
      AssertShouldBeInSchedule(name,node.Value());
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleTests::AssertShouldNotBeInSchedule(string name,datetime time)
  {
   string message=StringConcatenate(s.ToString()," includes ",time);
   bool actual=s.IsActive(time);
   this.unitTest.assertFalse(name,message,actual);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleTests::AssertShouldNotBeInSchedule(string name,CLinkedList<datetime>*time)
  {
   int sz=time.Count();
   CLinkedListNode<datetime>*node=time.First();
   AssertShouldNotBeInSchedule(name,node.Value());

   while(node!=time.Last())
     {
      node=node.Next();
      AssertShouldNotBeInSchedule(name,node.Value());
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleTests::CanGetExpectedStringRepresentation()
  {
   this.unitTest.assertEquals(__FUNCTION__,"The string representation is wrong","MONDAY at 01:15 to FRIDAY at 14:45",s.ToString());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleTests::CanScheduleByDay()
  {
   string name=__FUNCTION__;
   CLinkedList<datetime>*shouldBe=new CLinkedList<datetime>();
   CLinkedList<datetime>*shouldNotBe=new CLinkedList<datetime>();

   string time=StringConcatenate((string)(s.TimeEnd.Hour),":",(string)(s.TimeEnd.Minute - 1));

   shouldNotBe.Add(StrToTime(StringConcatenate("2018.06.10 ",time))); // sunday
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.06.16 ",time))); // saturday

   shouldBe.Add(StrToTime(StringConcatenate("2018.06.11 ",time))); // monday
   shouldBe.Add(StrToTime(StringConcatenate("2018.06.12 ",time))); // tuesday
   shouldBe.Add(StrToTime(StringConcatenate("2018.06.13 ",time))); // wednesday
   shouldBe.Add(StrToTime(StringConcatenate("2018.06.14 ",time))); // thursday
   shouldBe.Add(StrToTime(StringConcatenate("2018.06.15 ",time))); // friday

   this.AssertShouldBeInSchedule(name,shouldBe);
   this.AssertShouldNotBeInSchedule(name,shouldNotBe);

   delete shouldBe;
   delete shouldNotBe;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleTests::RespectsEndMinute()
  {
   string name=__FUNCTION__;
   CLinkedList<datetime>*shouldBe=new CLinkedList<datetime>();
   CLinkedList<datetime>*shouldNotBe=new CLinkedList<datetime>();

   shouldBe.Add(StrToTime(StringConcatenate("2018.06.11 ",(string)(s.TimeEnd.Hour),":",(string)(s.TimeEnd.Minute-1))));
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.06.11 ", (string)(s.TimeEnd.Hour), ":", (string)(s.TimeEnd.Minute))));
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.06.11 ", (string)(s.TimeEnd.Hour), ":", (string)(s.TimeEnd.Minute + 1))));

   this.AssertShouldBeInSchedule(name,shouldBe);
   this.AssertShouldNotBeInSchedule(name,shouldNotBe);

   delete shouldBe;
   delete shouldNotBe;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleTests::RespectsEndHour()
  {
   string name=__FUNCTION__;
   CLinkedList<datetime>*shouldBe=new CLinkedList<datetime>();
   CLinkedList<datetime>*shouldNotBe=new CLinkedList<datetime>();

   shouldBe.Add(StrToTime(StringConcatenate("2018.06.11 ",(string)(s.TimeEnd.Hour-1),":",(string)(s.TimeEnd.Minute))));
   shouldNotBe.Add(StrToTime(StringConcatenate("2018.06.11 ",(string)(s.TimeEnd.Hour+1),":",(string)(s.TimeEnd.Minute))));

   this.AssertShouldBeInSchedule(name,shouldBe);
   this.AssertShouldNotBeInSchedule(name,shouldNotBe);

   delete shouldBe;
   delete shouldNotBe;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleTests::RespectsStartMinute()
  {
   string name=__FUNCTION__;
   CLinkedList<datetime>*shouldBe=new CLinkedList<datetime>();
   CLinkedList<datetime>*shouldNotBe=new CLinkedList<datetime>();

   shouldNotBe.Add(StrToTime(StringConcatenate("2018.06.11 ",(string)(s.TimeStart.Hour),":",(string)(s.TimeStart.Minute-1))));
   shouldBe.Add(StrToTime(StringConcatenate("2018.06.11 ", (string)(s.TimeStart.Hour), ":", (string)(s.TimeStart.Minute))));
   shouldBe.Add(StrToTime(StringConcatenate("2018.06.11 ", (string)(s.TimeStart.Hour), ":", (string)(s.TimeStart.Minute + 1))));

   this.AssertShouldBeInSchedule(name,shouldBe);
   this.AssertShouldNotBeInSchedule(name,shouldNotBe);

   delete shouldBe;
   delete shouldNotBe;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ScheduleTests::RespectsStartHour()
  {
   string name=__FUNCTION__;
   CLinkedList<datetime>*shouldBe=new CLinkedList<datetime>();
   CLinkedList<datetime>*shouldNotBe=new CLinkedList<datetime>();

   shouldNotBe.Add(StrToTime(StringConcatenate("2018.06.11 ",(string)(s.TimeStart.Hour-1),":",(string)(s.TimeStart.Minute))));
   shouldBe.Add(StrToTime(StringConcatenate("2018.06.11 ",(string)(s.TimeStart.Hour+1),":",(string)(s.TimeStart.Minute))));

   this.AssertShouldBeInSchedule(name,shouldBe);
   this.AssertShouldNotBeInSchedule(name,shouldNotBe);

   delete shouldBe;
   delete shouldNotBe;
  }
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void ScheduleTests::RunAllTests()
  {
//---
   this.CanGetExpectedStringRepresentation();
   this.CanScheduleByDay();
   this.RespectsStartMinute();
   this.RespectsEndMinute();
   this.RespectsStartHour();
   this.RespectsEndHour();
   this.unitTest.printSummary();
  }
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   ScheduleTests *tests=new ScheduleTests();
   tests.RunAllTests();
   delete tests;
  }
//+------------------------------------------------------------------+
