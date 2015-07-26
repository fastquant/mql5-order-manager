//+------------------------------------------------------------------+
//|                                                        Order.mqh |
//|                                     Copyright 2014, Louis Fradin |
//|                                      http://en.louis-fradin.net/ |
//+------------------------------------------------------------------+

#property copyright "Copyright 2014, Louis Fradin"
#property link      "http://en.louis-fradin.net/"

#include <Trade\AccountInfo.mqh>
#include "OrderInfos.mqh"

//+------------------------------------------------------------------+
//| Prototype
//+------------------------------------------------------------------+

class COrder : public COrderInfos{
   public:
      COrder();
      ~COrder();
      
      // Mutators
      bool SetSymbol(string symbol);
      void SetOrderType(ENUM_ORDER_TYPE orderType);
      void SetStatus(ENUM_ORDER_STATE orderStatus);
      bool SetPrice(double price);
      bool SetVolume(double volume);
      bool SetTakeProfit(double takeProfit);
      bool SetStopLoss(double stopLoss);
};

//+------------------------------------------------------------------+
//| Constructor
//+------------------------------------------------------------------+

COrder::COrder(){
}

//+------------------------------------------------------------------+
//| Destructors
//+------------------------------------------------------------------+

COrder::~COrder(){
}

//+------------------------------------------------------------------+
//| Set the order symbol
//| @param symbol String of the symbol
//| @return true if the symbol exist on the market, false otherwise
//+------------------------------------------------------------------+

bool COrder::SetSymbol(string symbol){
   // Setting the object name
   this.Name(symbol);
   
   // Testing the selection
   return(this.Select());
}

//+------------------------------------------------------------------+
//| Set the order type
//| @param orderType The new order type
//+------------------------------------------------------------------+

void COrder::SetOrderType(ENUM_ORDER_TYPE orderType){
   // Setting the orderType
   m_orderType = orderType;
}

//+------------------------------------------------------------------+
//| Set the order status
//| @param orderStatus The order status
//+------------------------------------------------------------------+

void COrder::SetStatus(ENUM_ORDER_STATE orderStatus){
   m_orderStatus = orderStatus;
}

//+------------------------------------------------------------------+
//| Set the order price
//| @param orderType The new order price
//| @return true if the price is correct, false otherwise
//+------------------------------------------------------------------+

bool COrder::SetPrice(double price){
   // Verifying if the price is correct   
   if(price<0){
      Print("COrder::setPrice: Price below 0");
      return false;
   }
   else{
      m_price = price;
      return true;
   }
}

//+------------------------------------------------------------------+
//| Set the order volume
//| @param orderType The new order volume
//| @return true if the volume is correct, false otherwise
//+------------------------------------------------------------------+

bool COrder::SetVolume(double volume){
   // Verifying if the the volume is correct
   if(volume<=0){
      Print("COrder::setVolume: Volume below or equals to 0");
      return false;
   }
   else{
      m_volume = volume;
      return true;
   }
}

//+------------------------------------------------------------------+
//| Set the order take profit
//| @param takeProfit The new order take profit
//| @return true if the take profit is correct, false otherwise
//+------------------------------------------------------------------+

bool COrder::SetTakeProfit(double takeProfit){
   // Verifying if the take profit is correct
   if(takeProfit<0){
      Print("COrder::setTakeProfit: Take Profit below 0");
      return false;
   }
   else{
      m_takeProfit = takeProfit;
      return true;
   }
}

//+------------------------------------------------------------------+
//| Set the order stop loss
//| @param stopLoss The new order stopLoss
//| @return true if the stopLoss is correct, false otherwise
//+------------------------------------------------------------------+

bool COrder::SetStopLoss(double stopLoss){
   // Verifying if the stop loss is correct
   if(stopLoss<0){
      Print("COrder::setStopLoss: Stop Loss below 0");
      return false;
   }
   else{
      m_stopLoss = stopLoss;
      return true;
   }
}

//+------------------------------------------------------------------+