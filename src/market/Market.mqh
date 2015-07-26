//+------------------------------------------------------------------+
//|                                                       Market.mqh |
//|                                     Copyright 2015, Louis Fradin |
//|                                     https://en.louis-fradin.net/ |
//+------------------------------------------------------------------+

#property copyright "Copyright 2015, Louis Fradin"
#property link      "https://en.louis-fradin.net/"
#property version   "1.00"

#include <Trade/Trade.mqh>
#include "AbstractMarket.mqh"
#include "../orders/Order.mqh"

//+------------------------------------------------------------------+
//| Prototype
//+------------------------------------------------------------------+

class CMarket : public CAbstractMarket{
   private:
      CTrade m_trade;
      
   public:
      CMarket();
      ~CMarket();
      
      virtual bool PositionOpen(const string symbol,const ENUM_ORDER_TYPE order_type,const double volume, const double price,const double sl,const double tp,const string comment="");
      virtual double GetAsk(string symbol);
      virtual double GetBid(string symbol);
};

//+------------------------------------------------------------------+
//| Constructor
//+------------------------------------------------------------------+

CMarket::CMarket(){
}
  
  
//+------------------------------------------------------------------+
//| Destructor
//+------------------------------------------------------------------+

CMarket::~CMarket(){
}

//+------------------------------------------------------------------+
//| Open a position
//| @param symbol Symbol of the position
//| @param order_type The type of order
//| @param volume The order volume
//| @param price The order price
//| @param sl The order stop loss
//| @param tp The order take profit
//| @param comment The order comment
//| @return bool if order is ok, false otherwise
//+------------------------------------------------------------------+

bool CMarket::PositionOpen(const string symbol,const ENUM_ORDER_TYPE order_type,const double volume, const double price,const double sl,const double tp,const string comment=""){
   return m_trade.PositionOpen(symbol,order_type,volume,price,sl,tp,comment);
}

//+------------------------------------------------------------------+
//| Return the actual Bid
//| @param symbol Symbol concerned
//| @return Actual bid
//+------------------------------------------------------------------+

double CMarket::GetBid(string symbol){
   return SymbolInfoDouble(symbol,SYMBOL_BID);
}

//+------------------------------------------------------------------+
//| Return the actual Ask
//| @param symbol Symbol concerned
//| @return Actual ask
//+------------------------------------------------------------------+

double CMarket::GetAsk(string symbol){
   return SymbolInfoDouble(symbol,SYMBOL_ASK);
}

//+------------------------------------------------------------------+
