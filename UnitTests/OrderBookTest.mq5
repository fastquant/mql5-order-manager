//+------------------------------------------------------------------+
//|                                               CMockOrderBook.mqh.mq5 |
//|                                     Copyright 2015, Louis Fradin |
//|                                      http://en.louis-fradin.net/ |
//+------------------------------------------------------------------+

#property copyright "Copyright 2015, Louis Fradin"
#property link      "http://en.louis-fradin.net/"
#property version   "1.00"

#include "UnitTest_Library/UnitTestCollection.mqh"
#include "../Source/OrderBook.mqh"
#include "Mock Classes/MarketMock.mqh"

//+------------------------------------------------------------------+
//| Summary of tests
//+------------------------------------------------------------------+

void OnStart(){
   CUnitTestCollection utCollection();
   
   utCollection.AddUnitTest(CreateOrder_Test());
   utCollection.AddUnitTest(CloseOrder_Test());
   utCollection.AddUnitTest(Synchronise_Test());
   utCollection.AddUnitTest(CloseAllOrders_Test());
}

//+------------------------------------------------------------------+
//| Test CreateOrder                                                 |
//+------------------------------------------------------------------+

CUnitTest* CreateOrder_Test(){
   CUnitTest* ut = new CUnitTest("CreateOrder_Test");
   
   CMarketMock *mockMarket = new CMarketMock();
   COrderBook orderBook(mockMarket);
   
   // Setting up the mock market
   double bid = 1.00000;
   double ask = 1.00010;
   mockMarket.SetAsk("EURUSD", ask);
   mockMarket.SetBid("EURUSD", bid);
   mockMarket.AddSymbol("EURUSD");
   
   string symbol = "EURUSD";
   double volume = 0.01;
   double takeProfit = ask+0.02;
   double stopLoss = ask-0.01;
   ENUM_ORDER_TYPE orderType = ORDER_TYPE_BUY;
   
   // Test of the creation of few orders
   ut.IsTrue(__FILE__, __LINE__, orderBook.CreateOrder(symbol, orderType, volume, stopLoss,takeProfit, 0)); // First order
   ut.IsTrue(__FILE__, __LINE__, orderBook.CreateOrder(symbol, orderType, volume, stopLoss,takeProfit, 0)); // Second order
   
   // Test of the creation of the reverse order + 0.01
   volume = 0.03;
   takeProfit = bid-0.02;
   stopLoss = bid+0.01;
   orderType = ORDER_TYPE_SELL;
   
   ut.IsTrue(__FILE__, __LINE__, orderBook.CreateOrder(symbol, orderType, volume, stopLoss,takeProfit, 0)); // Reverse order
   ut.IsEquals(__FILE__, __LINE__, -0.01, mockMarket.GetPositionVolume("EURUSD"));
   
   // Test of the creation of the reverse order
   volume = 0.01;
   takeProfit = 0;
   stopLoss = 0;
   orderType = ORDER_TYPE_BUY;
   
   ut.IsTrue(__FILE__, __LINE__, orderBook.CreateOrder(symbol, orderType, volume, stopLoss,
      takeProfit, 0)); // Reverse order
   ut.IsEquals(__FILE__, __LINE__, 0.0, mockMarket.GetPositionVolume("EURUSD"));
   
   delete mockMarket;
   return ut;
}

//+------------------------------------------------------------------+
//| Close Order Test                                                 |
//+------------------------------------------------------------------+

CUnitTest* CloseOrder_Test(){
   CUnitTest* ut = new CUnitTest("CloseOrder_Test");
   
   CMarketMock *mockMarket = new CMarketMock();
   COrderBook orderBook(mockMarket);
   
   // Setting up the mock market
   double bid = 1.00000;
   double ask = 1.00010;
   mockMarket.SetAsk("EURUSD", ask);
   mockMarket.SetBid("EURUSD", bid);
   mockMarket.AddSymbol("EURUSD");
   
   string symbol = "EURUSD";
   double volume = 0.01;
   double takeProfit = ask +0.02;
   double stopLoss = ask-0.01;
   ENUM_ORDER_TYPE orderType = ORDER_TYPE_BUY;
   
   ut.IsTrue(__FILE__, __LINE__, orderBook.CreateOrder(symbol, orderType, volume, stopLoss, takeProfit, 0));
   ut.IsEquals(__FILE__, __LINE__, 1, orderBook.GetNbrOfTickets());
   ut.IsTrue(__FILE__, __LINE__, orderBook.CloseOrder(0));
   ut.IsFalse(__FILE__, __LINE__, orderBook.CloseOrder(0));
   
   delete mockMarket;
   return ut;
}

//+------------------------------------------------------------------+
//| Synchronise method Test
//+------------------------------------------------------------------+

CUnitTest* Synchronise_Test(){
   CUnitTest* ut = new CUnitTest("Synchronise_Test");
   
   CMarketMock *mockMarket = new CMarketMock();
   COrderBook orderBook(mockMarket);
    
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
   
   ut.IsTrue(__FILE__, __LINE__, orderBook.CreateOrder(symbol, orderType, volume, stopLoss, takeProfit, 0)); 
   
   // Change of market conditions : Action the stop loss
   mockMarket.SetAsk("EURUSD", mockMarket.GetAsk("EURUSD")-0.02);
   mockMarket.SetBid("EURUSD", mockMarket.GetBid("EURUSD")-0.02);
         
   // Synchronisation & Tests
   if(ut.IsTrue(__FILE__, __LINE__, orderBook.Synchronise())){
      ut.IsEquals(__FILE__, __LINE__, 0.0, mockMarket.GetPositionVolume("EURUSD"));
   }
      
   // --- TEST2 : A buy order closed by its takeProfit
   // Creation of the order
   takeProfit = mockMarket.GetAsk("EURUSD")+0.02;
   stopLoss = mockMarket.GetAsk("EURUSD")-0.01;
   ut.IsTrue(__FILE__, __LINE__, orderBook.CreateOrder(symbol, orderType, volume, stopLoss, takeProfit, 0)); 
      
   // Change of market conditions : Action the take profit
   mockMarket.SetAsk("EURUSD", mockMarket.GetAsk("EURUSD")+0.03);
   mockMarket.SetBid("EURUSD", mockMarket.GetBid("EURUSD")+0.03);
         
   // Synchronisation & Tests
   if(ut.IsTrue(__FILE__, __LINE__, orderBook.Synchronise())){
      ut.IsEquals(__FILE__, __LINE__, 0.0, mockMarket.GetPositionVolume("EURUSD"));
   }
      
   // --- TEST3 : A sell order closed by its stopLoss
   // Creation of the order
   takeProfit = mockMarket.GetBid("EURUSD")-0.02;
   stopLoss = mockMarket.GetBid("EURUSD")+0.01;
   orderType = ORDER_TYPE_SELL;
   ut.IsTrue(__FILE__, __LINE__, orderBook.CreateOrder(symbol, orderType, volume, stopLoss, takeProfit, 0)); 
      
   // Change of market conditions : Action the stop loss
   mockMarket.SetAsk("EURUSD", mockMarket.GetAsk("EURUSD")+0.02);
   mockMarket.SetBid("EURUSD", mockMarket.GetBid("EURUSD")+0.02);
         
   // Synchronisation & Tests
   if(ut.IsTrue(__FILE__, __LINE__, orderBook.Synchronise())){
      ut.IsEquals(__FILE__, __LINE__, 0.0, mockMarket.GetPositionVolume("EURUSD"));
   }
      
   // --- TEST4 : A sell order closed by its takeProfit
   // Creation of the order
   takeProfit = mockMarket.GetBid("EURUSD")-0.02;
   stopLoss = mockMarket.GetBid("EURUSD")+0.01;
   ut.IsTrue(__FILE__, __LINE__, orderBook.CreateOrder(symbol, orderType, volume, stopLoss, takeProfit, 0)); 
      
   // Change of market conditions : Action the take profit
   mockMarket.SetAsk("EURUSD", mockMarket.GetAsk("EURUSD")+0.03);
   mockMarket.SetBid("EURUSD", mockMarket.GetBid("EURUSD")+0.03);
         
   // Synchronisation
   if(ut.IsTrue(__FILE__, __LINE__, orderBook.Synchronise())){
      ut.IsEquals(__FILE__, __LINE__, 0.0, mockMarket.GetPositionVolume("EURUSD"));
   }
      
   // --- TEST5 : An order without stoploss and takeprofit
   // Creation of the order
   orderType = ORDER_TYPE_BUY;
   ut.IsTrue(__FILE__, __LINE__, orderBook.CreateOrder(symbol, orderType, 0.01, 0, 0, 0)); 
   
   if(ut.IsTrue(__FILE__, __LINE__, orderBook.Synchronise())){
      ut.IsEquals(__FILE__, __LINE__, 0.01, mockMarket.GetPositionVolume("EURUSD"));
   }

   // Close the order
   ut.IsTrue(__FILE__, __LINE__, orderBook.CloseOrders());
   
   // --- TEST6 : An order which should not be closed
   // creation of the order
   takeProfit = mockMarket.GetBid("EURUSD")-0.02;
   stopLoss = mockMarket.GetBid("EURUSD")+0.01;
   volume = 0.1;
   orderType = ORDER_TYPE_SELL;
   
   ut.IsTrue(__FILE__, __LINE__, orderBook.CreateOrder(symbol, orderType, volume, stopLoss, takeProfit, 0)); 
   
   // Synchronisation
   if(ut.IsTrue(__FILE__, __LINE__, orderBook.Synchronise())){
      ut.IsEquals(__FILE__, __LINE__, -0.1, mockMarket.GetPositionVolume("EURUSD"));
   }
   
   delete mockMarket;
   return ut;
}

//+------------------------------------------------------------------+
//| CloseAllOrders_Test
//+------------------------------------------------------------------+

CUnitTest* CloseAllOrders_Test(){
   CUnitTest* ut = new CUnitTest("CloseAllOrders_Test");
   
   CMarketMock *mockMarket = new CMarketMock();
   COrderBook orderBook(mockMarket);
   
   // Setting up the mock market
   mockMarket.SetAsk("EURUSD", 1.00000);
   mockMarket.SetBid("EURUSD", 1.00010);
   mockMarket.AddSymbol("EURUSD");
   
   string symbol = "EURUSD";
   double volume = 0.01;
   double takeProfit = mockMarket.GetAsk("EURUSD")+0.02;
   double stopLoss = mockMarket.GetAsk("EURUSD")-0.01;
   ENUM_ORDER_TYPE orderType = ORDER_TYPE_BUY;
   
   // Creation of few orders
   for(int i = 0; i < 5; i++)
      orderBook.CreateOrder(symbol, orderType, volume, stopLoss, takeProfit, 0); // First order
   
   // Verification
   ut.IsEquals(__FILE__, __LINE__, 0.05, mockMarket.GetPositionVolume("EURUSD"));
   Print("Before closing");
   // Closing   
   ut.IsTrue(__FILE__, __LINE__, orderBook.CloseOrders());
     
   // Recuperation of the order
   COrderInfos *ticket = orderBook.GetOrderInfos(0);
   
   if(ut.IsTrue(__FILE__, __LINE__, ticket!=NULL)){
      ut.IsEquals(__FILE__, __LINE__, 0.00, mockMarket.GetPositionVolume("EURUSD"));
      ut.IsTrue(__FILE__, __LINE__, ORDER_STATE_EXPIRED==ticket.GetStatus());
   }
   
   delete mockMarket;
   return ut;
}

//+------------------------------------------------------------------+
