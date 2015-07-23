//+------------------------------------------------------------------+
//|                                                   ExampleGUI.mq5 |
//|                                     Copyright 2015, Louis Fradin |
//|                                     https://en.louis-fradin.net/ |
//+------------------------------------------------------------------+

#property copyright "Copyright 2015, Louis Fradin"
#property link      "https://en.louis-fradin.net/"
#property version   "1.00"

#include "../UnitTests/Mock Classes/MarketMock.mqh"
#include "../Source/Market.mqh"
#include "../GUI/OrderManagerGUI.mqh"

#define REAL_MARKET false

int g_counter;
CMarketMock *g_mockMarket;
CMarket *g_realMarket;
COrderManager *g_OrderManager;
COrderManagerGUI *g_OrderManagerGUI;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

int OnInit(){
   g_counter = 0;
   
   if(REAL_MARKET){
      g_realMarket = new CMarket();
      g_OrderManager = new COrderManager(g_realMarket);
   }
   else{
      g_mockMarket = new CMarketMock();
   
      // Configurate the mock market
      g_mockMarket.AddSymbol("EURUSD");
      g_mockMarket.AddSymbol("GBPUSD");
      g_mockMarket.AddSymbol("USDCHF");
      g_mockMarket.AddSymbol("USDJPY");
      g_mockMarket.AddSymbol("USDCAD");
      g_mockMarket.AddSymbol("AUDUSD");
      g_mockMarket.AddSymbol("AUDNZD");
      g_mockMarket.AddSymbol("AUDCAD");
      g_mockMarket.AddSymbol("AUDCHF");
      g_mockMarket.AddSymbol("AUDJPY");
      
      g_OrderManager = new COrderManager(g_mockMarket);
   }
   
   g_OrderManagerGUI = new COrderManagerGUI(g_OrderManager);
   
   if(!g_OrderManagerGUI.Create("Example OrderManager"))
      return (INIT_FAILED);
   if(!g_OrderManagerGUI.Run())
      return (INIT_FAILED);
  
   EventSetTimer(1);
   return(INIT_SUCCEEDED);
}
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+

void OnDeinit(const int reason){
   g_OrderManager.CloseOrders();
   Sleep(1000);

   //--- destroying the dialog
   g_OrderManagerGUI.Destroy(reason);

   delete g_mockMarket;
   delete g_OrderManager;
   delete g_OrderManagerGUI;
}

//+------------------------------------------------------------------+
//| Expert event function
//+------------------------------------------------------------------+

void OnTimer(){
   OrderManagerGUITest(g_counter, "EURUSD");
   OrderManagerGUITest(g_counter, "GBPUSD");
   OrderManagerGUITest(g_counter, "USDCHF");
   OrderManagerGUITest(g_counter, "USDJPY");
   OrderManagerGUITest(g_counter, "USDCAD");
   OrderManagerGUITest(g_counter, "AUDUSD");
   OrderManagerGUITest(g_counter, "AUDNZD");
   OrderManagerGUITest(g_counter, "AUDCAD");
   OrderManagerGUITest(g_counter, "AUDCHF");
   OrderManagerGUITest(g_counter, "AUDJPY");
   
   g_OrderManagerGUI.Update();
   g_counter++;
}

//+------------------------------------------------------------------+
//| Chart event handler                                              |
//+------------------------------------------------------------------+

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam){
   //--- Handling the event
   g_OrderManagerGUI.ChartEvent(id,lparam,dparam,sparam);
}

//+------------------------------------------------------------------+
//| Function to test the OrderManager GUI
//+------------------------------------------------------------------+

void OrderManagerGUITest(int counter, string symbol){
   double volume, takeProfit, stopLoss, ask, bid;
   ENUM_ORDER_TYPE orderType;
  
   if(REAL_MARKET){
      ask = g_realMarket.GetAsk(symbol);
      bid = g_realMarket.GetBid(symbol);
   }
   else{
      ask = 1.0010;
      bid = 1.0000;
   
      g_mockMarket.SetAsk(symbol, ask);
      g_mockMarket.SetBid(symbol, bid);
   }
  
   counter = counter%4;
   
   switch(counter){
      case(0):
         symbol = symbol;
         volume = 0.10;
         takeProfit = ask+0.02;
         stopLoss = ask-0.01;
         orderType = ORDER_TYPE_BUY;
         
         g_OrderManager.CreateOrder(symbol, orderType, volume, stopLoss, takeProfit, 0);
         break;
      case(1):
         symbol = symbol;
         volume = 0.01;
         takeProfit = bid-0.001;
         stopLoss = bid+0.002;
         orderType = ORDER_TYPE_SELL;
         
         g_OrderManager.CreateOrder(symbol, orderType, volume, stopLoss, takeProfit, 0);
         break;
      case(2):
         symbol = symbol;
         volume = 0.10;
         takeProfit = bid-0.001;
         stopLoss = bid+0.002;
         orderType = ORDER_TYPE_SELL;
         
         g_OrderManager.CreateOrder(symbol, orderType, volume, stopLoss, takeProfit, 0);
         break;
      default:
         g_OrderManager.CloseOrders();
         break;
   }
}

//+------------------------------------------------------------------+
