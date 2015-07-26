//+------------------------------------------------------------------+
//|                                                   COrderTest.mq5 |
//|                                     Copyright 2015, Louis Fradin |
//|                                      http://en.louis-fradin.net/ |
//+------------------------------------------------------------------+
// Properties
#property copyright "Copyright 2015, Louis Fradin"
#property link      "http://en.louis-fradin.net/"
#property version   "1.00"
// Includes
#include "../modules/unit-test-library/UnitTest-Library.mqh"
#include "../src/orders/Order.mqh"
//+------------------------------------------------------------------+
//| Summary of tests
//+------------------------------------------------------------------+
void OnStart(){
   CUnitTestsCollection utCollection();
   utCollection.AddUnitTests(SetSymbol_Test());
   utCollection.AddUnitTests(SetVolume_Test());
   utCollection.AddUnitTests(SetTakeProfit_Test());
   utCollection.AddUnitTests(SetStopLoss_Test());
   utCollection.AddUnitTests(SetPrice_Test());
}
//+------------------------------------------------------------------+
//| Test SetSymbol
//+------------------------------------------------------------------+
CUnitTests* SetSymbol_Test(){
   CUnitTests* ut = new CUnitTests("SetSymbol_Test");
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
CUnitTests* SetVolume_Test(){
   CUnitTests* ut = new CUnitTests("SetVolume_Test");
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
CUnitTests* SetTakeProfit_Test(){
   CUnitTests* ut = new CUnitTests("SetTakeProfit_Test");
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
CUnitTests* SetStopLoss_Test(){
   CUnitTests* ut = new CUnitTests("SetStopLoss_Test");
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
CUnitTests* SetPrice_Test(){
   CUnitTests* ut = new CUnitTests("SetPrice_Test");
   COrder order();
   // Set
   ut.IsFalse(__FILE__, __LINE__, order.SetPrice(-2)); // Price < 0
   ut.IsTrue(__FILE__, __LINE__, order.SetPrice(1.08));
   // Get
   ut.IsEquals(__FILE__, __LINE__, 1.08, order.GetPrice());
   return ut;
}
//+------------------------------------------------------------------+
