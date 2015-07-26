//+------------------------------------------------------------------+
//|                                             OrderManagerTest.mq5 |
//|                                     Copyright 2015, Louis Fradin |
//|                                      http://en.louis-fradin.net/ |
//+------------------------------------------------------------------+
// Properties
#property copyright "Copyright 2015, Louis Fradin"
#property link      "http://en.louis-fradin.net/"
#property version   "1.00"
// Includes
#include "../modules/unit-test-library/UnitTest-Library.mqh"
#include "../src/OrderManager.mqh"
#include "../src/marketInterfaces/MockMarketInterface.mqh"
//+------------------------------------------------------------------+
//| Summary of tests
//+------------------------------------------------------------------+
void OnStart(){
   CUnitTestsCollection utCollection();
   utCollection.AddUnitTests(CreateOrder_Test());
   utCollection.AddUnitTests(CloseOrder_Test());
   utCollection.AddUnitTests(Synchronise_Test());
   utCollection.AddUnitTests(CloseAllOrders_Test());
}
//+------------------------------------------------------------------+
//| Test CreateOrder                                                 |
//+------------------------------------------------------------------+
CUnitTests* CreateOrder_Test(){
   CUnitTests* ut = new CUnitTests("CreateOrder_Test");
   CMockMarketInterface *mockMarket = new CMockMarketInterface();
   COrderManager OrderManager(mockMarket);
   // Setting up the mock market
   double bid = 1.00000;
   double ask = 1.00010;
   mockMarket.SetAsk("EURUSD", ask);
   mockMarket.SetBid("EURUSD", bid);
   mockMarket.AddSymbol("EURUSD");
   // Setting main caracteristics of orders
   string symbol = "EURUSD";
   double volume = 0.01;
   double takeProfit = ask+0.02;
   double stopLoss = ask-0.01;
   ENUM_ORDER_TYPE orderType = ORDER_TYPE_BUY;
   // Test of the creation of few orders
   ut.IsTrue(__FILE__, __LINE__, OrderManager.CreateOrder(symbol, orderType, volume, stopLoss,takeProfit, 0)); // First order
   ut.IsTrue(__FILE__, __LINE__, OrderManager.CreateOrder(symbol, orderType, volume, stopLoss,takeProfit, 0)); // Second order
   // Test of the creation of the reverse order + 0.01
   volume = 0.03;
   takeProfit = bid-0.02;
   stopLoss = bid+0.01;
   orderType = ORDER_TYPE_SELL;
   ut.IsTrue(__FILE__, __LINE__, OrderManager.CreateOrder(symbol, orderType, volume, stopLoss,takeProfit, 0)); // Reverse order
   ut.IsEquals(__FILE__, __LINE__, -0.01, mockMarket.GetPositionVolume("EURUSD"));
   // Test of the creation of the reverse order
   volume = 0.01;
   takeProfit = 0;
   stopLoss = 0;
   orderType = ORDER_TYPE_BUY;
   ut.IsTrue(__FILE__, __LINE__, OrderManager.CreateOrder(symbol, orderType, volume, stopLoss,
      takeProfit, 0)); // Reverse order
   ut.IsEquals(__FILE__, __LINE__, 0.0, mockMarket.GetPositionVolume("EURUSD"));
   delete mockMarket;
   return ut;
}
//+------------------------------------------------------------------+
//| Close Order Test                                                 |
//+------------------------------------------------------------------+
CUnitTests* CloseOrder_Test(){
   CUnitTests* ut = new CUnitTests("CloseOrder_Test");
   CMockMarketInterface *mockMarket = new CMockMarketInterface();
   COrderManager OrderManager(mockMarket);
   // Setting up the mock market
   double bid = 1.00000;
   double ask = 1.00010;
   mockMarket.SetAsk("EURUSD", ask);
   mockMarket.SetBid("EURUSD", bid);
   mockMarket.AddSymbol("EURUSD");
   // Setting main caracteristics of orders
   string symbol = "EURUSD";
   double volume = 0.01;
   double takeProfit = ask +0.02;
   double stopLoss = ask-0.01;
   ENUM_ORDER_TYPE orderType = ORDER_TYPE_BUY;
   // Test
   ut.IsTrue(__FILE__, __LINE__, OrderManager.CreateOrder(symbol, orderType, volume, stopLoss, takeProfit, 0));
   ut.IsEquals(__FILE__, __LINE__, 1, OrderManager.GetNbrOfTickets());
   ut.IsTrue(__FILE__, __LINE__, OrderManager.CloseOrder(0));
   ut.IsFalse(__FILE__, __LINE__, OrderManager.CloseOrder(0));
   delete mockMarket;
   return ut;
}

//+------------------------------------------------------------------+
//| Synchronise method Test
//+------------------------------------------------------------------+

CUnitTests* Synchronise_Test(){
   CUnitTests* ut = new CUnitTests("Synchronise_Test");
   CMockMarketInterface *mockMarket = new CMockMarketInterface();
   COrderManager OrderManager(mockMarket);
   // Setting up the mock market
   mockMarket.SetAsk("EURUSD", 1.00000);
   mockMarket.SetBid("EURUSD", 1.00010);
   mockMarket.AddSymbol("EURUSD");
   // --- TEST1 : A buy order closed by its stopLoss
   // Creation of the order
   string symbol = "EURUSD";
   double volume = 0.01;
   double takeProfit = mockMarket.GetAsk("EURUSD")+0.02;
   double stopLoss = mockMarket.GetAsk("EURUSD")-0.01;
   ENUM_ORDER_TYPE orderType = ORDER_TYPE_BUY;
   ut.IsTrue(__FILE__, __LINE__, OrderManager.CreateOrder(symbol, orderType, volume, stopLoss, takeProfit, 0)); 
   // Change of market conditions : Action the stop loss
   mockMarket.SetAsk("EURUSD", mockMarket.GetAsk("EURUSD")-0.02);
   mockMarket.SetBid("EURUSD", mockMarket.GetBid("EURUSD")-0.02); 
   // Synchronisation & Tests
   if(ut.IsTrue(__FILE__, __LINE__, OrderManager.Synchronise())){
      ut.IsEquals(__FILE__, __LINE__, 0.0, mockMarket.GetPositionVolume("EURUSD"));
   }
   // --- TEST2 : A buy order closed by its takeProfit
   // Creation of the order
   takeProfit = mockMarket.GetAsk("EURUSD")+0.02;
   stopLoss = mockMarket.GetAsk("EURUSD")-0.01;
   ut.IsTrue(__FILE__, __LINE__, OrderManager.CreateOrder(symbol, orderType, volume, stopLoss, takeProfit, 0)); 
   // Change of market conditions : Action the take profit
   mockMarket.SetAsk("EURUSD", mockMarket.GetAsk("EURUSD")+0.03);
   mockMarket.SetBid("EURUSD", mockMarket.GetBid("EURUSD")+0.03);  
   // Synchronisation & Tests
   if(ut.IsTrue(__FILE__, __LINE__, OrderManager.Synchronise())){
      ut.IsEquals(__FILE__, __LINE__, 0.0, mockMarket.GetPositionVolume("EURUSD"));
   }
   // --- TEST3 : A sell order closed by its stopLoss
   // Creation of the order
   takeProfit = mockMarket.GetBid("EURUSD")-0.02;
   stopLoss = mockMarket.GetBid("EURUSD")+0.01;
   orderType = ORDER_TYPE_SELL;
   ut.IsTrue(__FILE__, __LINE__, OrderManager.CreateOrder(symbol, orderType, volume, stopLoss, takeProfit, 0)); 
   // Change of market conditions : Action the stop loss
   mockMarket.SetAsk("EURUSD", mockMarket.GetAsk("EURUSD")+0.02);
   mockMarket.SetBid("EURUSD", mockMarket.GetBid("EURUSD")+0.02);
   // Synchronisation & Tests
   if(ut.IsTrue(__FILE__, __LINE__, OrderManager.Synchronise())){
      ut.IsEquals(__FILE__, __LINE__, 0.0, mockMarket.GetPositionVolume("EURUSD"));
   }
   // --- TEST4 : A sell order closed by its takeProfit
   // Creation of the order
   takeProfit = mockMarket.GetBid("EURUSD")-0.02;
   stopLoss = mockMarket.GetBid("EURUSD")+0.01;
   ut.IsTrue(__FILE__, __LINE__, OrderManager.CreateOrder(symbol, orderType, volume, stopLoss, takeProfit, 0)); 
   // Change of market conditions : Action the take profit
   mockMarket.SetAsk("EURUSD", mockMarket.GetAsk("EURUSD")+0.03);
   mockMarket.SetBid("EURUSD", mockMarket.GetBid("EURUSD")+0.03);
   // Synchronisation
   if(ut.IsTrue(__FILE__, __LINE__, OrderManager.Synchronise())){
      ut.IsEquals(__FILE__, __LINE__, 0.0, mockMarket.GetPositionVolume("EURUSD"));
   }
   // --- TEST5 : An order without stoploss and takeprofit
   // Creation of the order
   orderType = ORDER_TYPE_BUY;
   ut.IsTrue(__FILE__, __LINE__, OrderManager.CreateOrder(symbol, orderType, 0.01, 0, 0, 0)); 
   if(ut.IsTrue(__FILE__, __LINE__, OrderManager.Synchronise())){
      ut.IsEquals(__FILE__, __LINE__, 0.01, mockMarket.GetPositionVolume("EURUSD"));
   }
   // Close the order
   ut.IsTrue(__FILE__, __LINE__, OrderManager.CloseOrders());
   // --- TEST6 : An order which should not be closed
   // creation of the order
   takeProfit = mockMarket.GetBid("EURUSD")-0.02;
   stopLoss = mockMarket.GetBid("EURUSD")+0.01;
   volume = 0.1;
   orderType = ORDER_TYPE_SELL;
   ut.IsTrue(__FILE__, __LINE__, OrderManager.CreateOrder(symbol, orderType, volume, stopLoss, takeProfit, 0)); 
   // Synchronisation
   if(ut.IsTrue(__FILE__, __LINE__, OrderManager.Synchronise())){
      ut.IsEquals(__FILE__, __LINE__, -0.1, mockMarket.GetPositionVolume("EURUSD"));
   }
   delete mockMarket;
   return ut;
}
//+------------------------------------------------------------------+
//| CloseAllOrders_Test
//+------------------------------------------------------------------+
CUnitTests* CloseAllOrders_Test(){
   CUnitTests* ut = new CUnitTests("CloseAllOrders_Test");
   CMockMarketInterface *mockMarket = new CMockMarketInterface();
   COrderManager OrderManager(mockMarket);
   // Setting up the mock market
   mockMarket.SetAsk("EURUSD", 1.00000);
   mockMarket.SetBid("EURUSD", 1.00010);
   mockMarket.AddSymbol("EURUSD");
   // Setting main caracteristics of orders
   string symbol = "EURUSD";
   double volume = 0.01;
   double takeProfit = mockMarket.GetAsk("EURUSD")+0.02;
   double stopLoss = mockMarket.GetAsk("EURUSD")-0.01;
   ENUM_ORDER_TYPE orderType = ORDER_TYPE_BUY;
   // Creation of few orders
   for(int i = 0; i < 5; i++)
      OrderManager.CreateOrder(symbol, orderType, volume, stopLoss, takeProfit, 0); // First order
   // Verification
   ut.IsEquals(__FILE__, __LINE__, 0.05, mockMarket.GetPositionVolume("EURUSD"));
   Print("Before closing");
   // Closing   
   ut.IsTrue(__FILE__, __LINE__, OrderManager.CloseOrders());
   // Recuperation of the order
   COrderInfos *ticket = OrderManager.GetOrderInfos(0);
   if(ut.IsTrue(__FILE__, __LINE__, ticket!=NULL)){
      ut.IsEquals(__FILE__, __LINE__, 0.00, mockMarket.GetPositionVolume("EURUSD"));
      ut.IsTrue(__FILE__, __LINE__, ORDER_STATE_EXPIRED==ticket.GetStatus());
   }
   delete mockMarket;
   return ut;
}
//+------------------------------------------------------------------+
