//+------------------------------------------------------------------+
//|                                               AbstractMarket.mqh |
//|                                     Copyright 2015, Louis Fradin |
//|                                     https://en.louis-fradin.net/ |
//+------------------------------------------------------------------+

#property copyright "Copyright 2015, Louis Fradin"
#property link      "https://en.louis-fradin.net/"
#property version   "1.00"

#include <Trade/Trade.mqh>
#include "../orders/Order.mqh"

//+------------------------------------------------------------------+
//| Prototype
//+------------------------------------------------------------------+

class CAbstractMarket{
   private:
      CTrade m_trade;

   public:
      CAbstractMarket();
      ~CAbstractMarket();
      
      virtual bool PositionOpen(const string symbol,const ENUM_ORDER_TYPE order_type,
         const double volume, const double price,const double sl,const double tp,const string comment=""){
            Print("CAbstractMarket::PositionOpen: Virtual method");
            return false;
         };
      virtual double GetAsk(string symbol){
            Print("CAbstractMarket::GetAsk: Virtual method");
            return -1.0;
         };
      
      virtual double GetBid(string symbol){
            Print("CAbstractMarket::GetBid: Virtual method");
            return -1.0;
         };
};
  
//+------------------------------------------------------------------+
//| Constructor
//+------------------------------------------------------------------+

CAbstractMarket::CAbstractMarket(){
}

//+------------------------------------------------------------------+
//| Destructor
//+------------------------------------------------------------------+

CAbstractMarket::~CAbstractMarket(){
}

//+------------------------------------------------------------------+
