//+------------------------------------------------------------------+
//|                                              MarketInterface.mqh |
//|                                     Copyright 2015, Louis Fradin |
//|                                     https://en.louis-fradin.net/ |
//+------------------------------------------------------------------+

#property copyright "Copyright 2015, Louis Fradin"
#property link      "https://en.louis-fradin.net/"
#property version   "1.00"
#include <Trade/AccountInfo.mqh>
#include <Trade/Trade.mqh>
#include "AbstractMarketInterface.mqh"
#include "../orders/Order.mqh"

//+------------------------------------------------------------------+
//| Prototype
//+------------------------------------------------------------------+

class CMarketInterface : public CAbstractMarketInterface{
   private:
      CAccountInfo m_accountInfo;
      CTrade m_trade;
      
   public:
      CMarketInterface();
      ~CMarketInterface();
      
      virtual bool PositionOpen(const string symbol,const ENUM_ORDER_TYPE order_type,const double volume, const double price,const double sl,const double tp,const string comment="");
      virtual double GetAsk(string symbol);
      virtual double GetBid(string symbol);
      virtual double MaxLotCheck(string symbol, ENUM_ORDER_TYPE orderType, double price);
};

//+------------------------------------------------------------------+
//| Constructor
//+------------------------------------------------------------------+

CMarketInterface::CMarketInterface(){
}
  
  
//+------------------------------------------------------------------+
//| Destructor
//+------------------------------------------------------------------+

CMarketInterface::~CMarketInterface(){
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

bool CMarketInterface::PositionOpen(const string symbol,const ENUM_ORDER_TYPE order_type,const double volume, const double price,const double sl,const double tp,const string comment=""){
   return m_trade.PositionOpen(symbol,order_type,volume,price,sl,tp,comment);
}

//+------------------------------------------------------------------+
//| Return the actual Bid
//| @param symbol Symbol concerned
//| @return Actual bid
//+------------------------------------------------------------------+

double CMarketInterface::GetBid(string symbol){
   return SymbolInfoDouble(symbol,SYMBOL_BID);
}

//+------------------------------------------------------------------+
//| Return the actual Ask
//| @param symbol Symbol concerned
//| @return Actual ask
//+------------------------------------------------------------------+

double CMarketInterface::GetAsk(string symbol){
   return SymbolInfoDouble(symbol,SYMBOL_ASK);
}

//+------------------------------------------------------------------+
//| Return the max lot authorized
//| @param symbol Symbol
//| @param orderType Order type
//| @param price Price
//| @return Max Lot
//+------------------------------------------------------------------+
double CMarketInterface::MaxLotCheck(string symbol, ENUM_ORDER_TYPE orderType, double price){
   return m_accountInfo.MaxLotCheck(symbol, orderType, price); 
}

//+------------------------------------------------------------------+
