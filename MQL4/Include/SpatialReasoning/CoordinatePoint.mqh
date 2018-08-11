//+------------------------------------------------------------------+
//|                                              CoordinatePoint.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct CoordinatePoint
  {
public:
   double            X;
   double            Y;
   
   void CoordinatePoint()
   {
      X=0;
      Y=0;
   }
   
   void CoordinatePoint(double x,double y)
     {
      X=x;
      Y=y;
     }
  };
//+------------------------------------------------------------------+
