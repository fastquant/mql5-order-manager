//+------------------------------------------------------------------+
//|                                                   COrderTest.mq5 |
//|                                     Copyright 2015, Louis Fradin |
//|                                      http://en.louis-fradin.net/ |
//+------------------------------------------------------------------+

#property copyright "Copyright 2015, Louis Fradin"
#property link      "http://en.louis-fradin.net/"
#property version   "1.00"

#include "../modules/unittest_library/UnitTestCollection.mqh"
#include "../src/orders/Order.mqh"

//+------------------------------------------------------------------+
//| Summary of tests
//+------------------------------------------------------------------+

void OnStart(){
   CUnitTestCollection utCollection();
   
   utCollection.AddUnitTest(SetSymbol_Test());
   utCollection.AddUnitTest(SetVolume_Test());
   utCollection.AddUnitTest(SetTakeProfit_Test());
   utCollection.AddUnitTest(SetStopLoss_Test());
   utCollection.AddUnitTest(SetPrice_Test());
}

//+------------------------------------------------------------------+
//| Test SetSymbol
//+------------------------------------------------------------------+

CUnitTest* SetSymbol_Test(){
   CUnitTest* ut = new CUnitTest("SetSymbol_Test");
   COrder order();
   
   // Set
   ut.IsFalse(__FILE__, __LINE__, order.SetSymbol("ABCDEF"));
   ut.IsTrue(__FILE__, __LINE__, order.SetSymbol("EURUSD"));
   
   // Get
   ut.IsEquals(__FILE__, __LINE__, "EURUSD",order.GetSymbol());
   
   return ut;
}

//+------------------------------------------------------------------+
//| Test SetVolume
//+------------------------------------------------------------------+

CUnitTest* SetVolume_Test(){
   CUnitTest* ut = new CUnitTest("SetVolume_Test");
   COrder order();
   
   // Set
   ut.IsFalse(__FILE__, __LINE__, order.SetVolume(-2)); // Volume < 0
   ut.IsTrue(__FILE__, __LINE__, order.SetVolume(1));

   // Get
   ut.IsEquals(__FILE__, __LINE__, 1.0, order.GetVolume());

   return ut;
}

//+------------------------------------------------------------------+
//| Test SetTakeProfit
//+------------------------------------------------------------------+

CUnitTest* SetTakeProfit_Test(){
   CUnitTest* ut = new CUnitTest("SetTakeProfit_Test");
   COrder order();
   
   // Set
   ut.IsFalse(__FILE__, __LINE__, order.SetTakeProfit(-2)); // Takeprofit < 0
   ut.IsTrue(__FILE__, __LINE__, order.SetTakeProfit(1.08));
   
   // Get
   ut.IsEquals(__FILE__, __LINE__, 1.08, order.GetTakeProfit());
   
   return ut;
}

//+------------------------------------------------------------------+
//| Test setStopLoss
//+------------------------------------------------------------------+

CUnitTest* SetStopLoss_Test(){
   CUnitTest* ut = new CUnitTest("SetStopLoss_Test");
   COrder order();
   
   // Set
   ut.IsFalse(__FILE__, __LINE__, order.SetStopLoss(-2)); // StopLoss < 0
   ut.IsTrue(__FILE__, __LINE__, order.SetStopLoss(1.08));
   
   // Get
   ut.IsEquals(__FILE__, __LINE__, 1.08, order.GetStopLoss());
   
   return ut;
}

//+------------------------------------------------------------------+
//| Test SetPrice
//+------------------------------------------------------------------+

CUnitTest* SetPrice_Test(){
   CUnitTest* ut = new CUnitTest("SetPrice_Test");
   COrder order();
   
   // Set
   ut.IsFalse(__FILE__, __LINE__, order.SetPrice(-2)); // Price < 0
   ut.IsTrue(__FILE__, __LINE__, order.SetPrice(1.08));
   
   // Get
   ut.IsEquals(__FILE__, __LINE__, 1.08, order.GetPrice());
   
   return ut;
}

//+------------------------------------------------------------------+
