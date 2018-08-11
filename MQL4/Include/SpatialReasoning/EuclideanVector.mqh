//+------------------------------------------------------------------+
//|                                              EuclideanVector.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <SpatialReasoning\CoordinatePoint.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct EuclideanVector
  {
public:
   CoordinatePoint   A;
   CoordinatePoint   B;
   
   void EuclideanVector()
   {
   }

   void EuclideanVector(CoordinatePoint &a,CoordinatePoint &b)
     {
      this.A=a;
      this.B=b;
     }

   double GetWidth()
     {
      return this.B.Y - this.A.Y;
     }
     
   double GetHeight()
     {
      return this.B.X - this.A.X;
     }
     
   double GetMagnitude()
     {
      return MathSqrt(MathPow(this.GetHeight(),2) + MathPow(this.GetWidth(),2));
     }
     
   double GetDirection()
     {
      double result=0;
      double t=this.GetHeight()/this.GetWidth();
      double r= MathArctan(t); // radians
      result = r*(180.0/M_PI); // degrees
      return result;
     }
  };
//+------------------------------------------------------------------+
