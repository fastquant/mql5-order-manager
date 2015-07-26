//+------------------------------------------------------------------+
//|                                      AbstractMarketInterface.mqh |
//|                                     Copyright 2015, Louis Fradin |
//|                                     https://en.louis-fradin.net/ |
//+------------------------------------------------------------------+
// Properties
#property copyright "Copyright 2015, Louis Fradin"
#property link      "https://en.louis-fradin.net/"
#property version   "1.00"
// Includes
#include <Trade/Trade.mqh>
#include "../orders/Order.mqh"
//+------------------------------------------------------------------+
//| Class Prototype
//+------------------------------------------------------------------+
class CAbstractMarketInterface{
   private:
      CTrade m_trade;
   public:
      CAbstractMarketInterface();
      ~CAbstractMarketInterface();
      virtual bool PositionOpen(const string symbol,const ENUM_ORDER_TYPE order_type,
         const double volume, const double price,const double sl,const double tp,const string comment=""){
            Print("CAbstractMarketInterface::PositionOpen: Virtual method");
            return false;
         };
      virtual double GetAsk(string symbol){
            Print("CAbstractMarketInterface::GetAsk: Virtual method");
            return -1.0;
         };
      
      virtual double GetBid(string symbol){
            Print("CAbstractMarketInterface::GetBid: Virtual method");
            return -1.0;
         };
      virtual double MaxLotCheck(string symbol, ENUM_ORDER_TYPE orderType, double price){
            Print("CAbstractMarketInterface::MaxLotCheck: Virtual method");
            return -1.0;
         };
};
//+------------------------------------------------------------------+
//| Class Constructor
//+------------------------------------------------------------------+
CAbstractMarketInterface::CAbstractMarketInterface(){
}
//+------------------------------------------------------------------+
//| Class Destructor
//+------------------------------------------------------------------+
CAbstractMarketInterface::~CAbstractMarketInterface(){
}
//+------------------------------------------------------------------+
