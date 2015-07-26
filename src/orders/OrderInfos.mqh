//+------------------------------------------------------------------+
//|                                                   OrderInfos.mqh |
//|                                     Copyright 2015, Louis Fradin |
//|                                      http://en.louis-fradin.net/ |
//+------------------------------------------------------------------+
// Properties
#property copyright "Copyright 2015, Louis Fradin"
#property link      "http://en.louis-fradin.net/"
#property version   "1.00"
// Includes
#include <Trade\SymbolInfo.mqh>
// Defines
#define DIGITS_VOLUME 2
#define DIGITS_PRICE 5
//+------------------------------------------------------------------+
//| Class Prototype
//+------------------------------------------------------------------+
class COrderInfos : public CSymbolInfo{
   protected:
      int m_id;
      ENUM_ORDER_STATE m_orderStatus;
      ENUM_ORDER_TYPE m_orderType;
      double m_price;
      double m_volume;
      double m_stopLoss;
      double m_takeProfit;
      string m_comment;
   public:
      COrderInfos();
      ~COrderInfos();
      // Informations
      void DisplayTicket();
      string FormatTicket();
      // Accessors
      int GetID();
      ENUM_ORDER_STATE GetStatus();
      ENUM_ORDER_TYPE GetType();
      string GetSymbol();
      double GetPrice();
      double GetVolume();
      double GetStopLoss();
      double GetTakeProfit();
      string GetComment();
};
//+------------------------------------------------------------------+
//| Class Constructor
//+------------------------------------------------------------------+
COrderInfos::COrderInfos(){
   // Id creation
   m_id = (int)TimeLocal() * 100 + MathRand()%100; // Local Time + Random 2 digits
   // Members initialisation
   m_orderStatus = ORDER_STATE_STARTED;
   m_orderType = 0;
   m_price = 0;
   m_volume = 0;
   m_stopLoss = 0;
   m_takeProfit = 0;
}
//+------------------------------------------------------------------+
//| Class Destructor
//+------------------------------------------------------------------+
COrderInfos::~COrderInfos(){
}
//+------------------------------------------------------------------+
//| Display the ticket informations
//+------------------------------------------------------------------+
void COrderInfos::DisplayTicket(){
   Print("Order "+IntegerToString(m_id)); // Order ID
   Print("+Symbol: "+this.Name()); // Order symbol
   // Order Status
   if(m_orderStatus==ORDER_STATE_EXPIRED)
      Print("+Status: Closed");
   else if(m_orderStatus==ORDER_STATE_REJECTED)
      Print("+Executed: An error occured");
   else if(m_orderStatus==ORDER_STATE_FILLED)
      Print("+Executed: Executed");
   else if(m_orderStatus==ORDER_STATE_STARTED)
      Print("+Executed: New");
   else if(m_orderStatus==ORDER_STATE_PLACED)
      Print("+Executed: Waiting of execution");
   Print("+Price: "+DoubleToString(m_price)); // Order Price
   Print("+Volume: "+DoubleToString(m_volume)); // Order Volume
   Print("+TakeProfit: "+DoubleToString(m_takeProfit)); // Order Take Profit
   Print("+StopLoss: "+DoubleToString(m_stopLoss)); // Order Stop Loss
}
//+------------------------------------------------------------------+
//| Format the order informations in a string
//| @return The string with informations
//+------------------------------------------------------------------+
string COrderInfos::FormatTicket(){
   string description = "";
   // Put the Symbol
   description += this.Name()+"|";
   // Put BUY OR SELL
   if(m_orderType==ORDER_TYPE_BUY)
      description += "Buy";
   else if(m_orderType==ORDER_TYPE_SELL)
      description += "Sell";
   else if(m_orderType==ORDER_TYPE_BUY_LIMIT)
      description += "Buy Lim"; 
   else if(m_orderType==ORDER_TYPE_SELL_LIMIT)
      description += "Sell Lim";
   else if(m_orderType==ORDER_TYPE_BUY_STOP)
      description += "Buy Stp";
   else if(m_orderType==ORDER_TYPE_SELL_STOP)
      description += "Sell Stp";
   else if(m_orderType==ORDER_TYPE_BUY_STOP_LIMIT)
      description += "Buy Stp Lim"; 
   else if(m_orderType==ORDER_TYPE_SELL_STOP_LIMIT)
      description += "Sell Stp Lim";                 
   // Put Status
   if(m_orderStatus==ORDER_STATE_EXPIRED)
      description += "|Closed";
   else if(m_orderStatus==ORDER_STATE_REJECTED)
      description += "|Rejected";
   else if(m_orderStatus==ORDER_STATE_FILLED)
      description += "|Filled";
   else if(m_orderStatus==ORDER_STATE_STARTED)
      description += "|New";
   else if(m_orderStatus==ORDER_STATE_PLACED)
      description += "|Waiting";
   // Put the price
   description += "|"+DoubleToString(m_price,DIGITS_PRICE);
   // Put the price
   description += "|"+DoubleToString(m_volume, DIGITS_VOLUME);
   // Put the stop loss
   description += "|"+DoubleToString(m_stopLoss, DIGITS_PRICE);
   // Put the take profit
   description += "|"+DoubleToString(m_takeProfit, DIGITS_PRICE);
   return description;
}
//+------------------------------------------------------------------+
//| Get the order ID
//| @return The order ID
//+------------------------------------------------------------------+
int COrderInfos::GetID(){
   return m_id;
}
//+------------------------------------------------------------------+
//| Get the order status
//| @return The order status
//+------------------------------------------------------------------+
ENUM_ORDER_STATE COrderInfos::GetStatus(){
   return m_orderStatus;
}
//+------------------------------------------------------------------+
//| Get the order type
//| @return The order type
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE COrderInfos::GetType(){
   return m_orderType;
}
//+------------------------------------------------------------------+
//| Get the order symbol
//| @return The order symbol
//+------------------------------------------------------------------+
string COrderInfos::GetSymbol(){
   return this.Name();
}
//+------------------------------------------------------------------+
//| Get the price status
//| @return The order price
//+------------------------------------------------------------------+
double COrderInfos::GetPrice(){
   return m_price;
}
//+------------------------------------------------------------------+
//| Get the order volume
//| @return The order volume
//+------------------------------------------------------------------+
double COrderInfos::GetVolume(){
   return m_volume;
}
//+------------------------------------------------------------------+
//| Get the order stop loss
//| @return The order stop loss
//+------------------------------------------------------------------+
double COrderInfos::GetStopLoss(){
   return m_stopLoss;
}
//+------------------------------------------------------------------+
//| Get the order take profit
//| @return The order take profit
//+------------------------------------------------------------------+
double COrderInfos::GetTakeProfit(){
   return m_takeProfit;
}
//+------------------------------------------------------------------+
//| Get the order comment
//| @return The order comment
//+------------------------------------------------------------------+
string COrderInfos::GetComment(){
   return m_comment;
}
//+------------------------------------------------------------------+
