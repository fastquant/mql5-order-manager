//+------------------------------------------------------------------+
//|                                              MarketInterface.mqh |
//|                                     Copyright 2015, Louis Fradin |
//|                                     https://en.louis-fradin.net/ |
//+------------------------------------------------------------------+

#property copyright "Copyright 2015, Louis Fradin"
#property link      "https://en.louis-fradin.net/"
#property version   "1.00"

#include <Trade/Trade.mqh>
#include "../Order.mqh"

//+------------------------------------------------------------------+
//| Prototype
//+------------------------------------------------------------------+

class IMarket{
   private:
      CTrade m_trade;

   public:
      IMarket();
      ~IMarket();
      
      virtual bool PositionOpen(const string symbol,const ENUM_ORDER_TYPE order_type,
         const double volume, const double price,const double sl,const double tp,const string comment=""){
            Print("IMarket::PositionOpen: Virtual method");
            return false;
         };
      virtual double GetAsk(string symbol){
            Print("IMarket::GetAsk: Virtual method");
            return -1.0;
         };
      
      virtual double GetBid(string symbol){
            Print("IMarket::GetBid: Virtual method");
            return -1.0;
         };
};
  
//+------------------------------------------------------------------+
//| Constructor
//+------------------------------------------------------------------+

IMarket::IMarket(){
}

//+------------------------------------------------------------------+
//| Destructor
//+------------------------------------------------------------------+

IMarket::~IMarket(){
}

//+------------------------------------------------------------------+
