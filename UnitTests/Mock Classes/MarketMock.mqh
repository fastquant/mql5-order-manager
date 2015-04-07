//+------------------------------------------------------------------+
//|                                                   MarketMock.mqh |
//|                                     Copyright 2015, Louis Fradin |
//|                                     https://en.louis-fradin.net/ |
//+------------------------------------------------------------------+

#property copyright "Copyright 2015, Louis Fradin"
#property link      "https://en.louis-fradin.net/"
#property version   "1.00"

#include <Trade\AccountInfo.mqh>
#include "../../Source/Interfaces/MarketInterface.mqh"

//+------------------------------------------------------------------+
//| Prototype
//+------------------------------------------------------------------+

class CMarketMock : public IMarket{
   private:
      string m_symbols[];
      double m_volumes[];
      double m_ask[];
      double m_bid[];

   public:
      CMarketMock();
      ~CMarketMock();
      
      // Setting functions
      void AddSymbol(string symbol);
      void SetAsk(string symbol, double ask);
      void SetBid(string symbol, double bid);
      void SetPositionVolume(string symbol, double volume);
      
      // Check functions
      bool IsSymbol(string symbol);
      double GetPositionVolume(string symbol);
      
      // Real functions
      virtual bool PositionOpen(const string symbol,const ENUM_ORDER_TYPE order_type,const double volume, const double price,const double sl,const double tp,const string comment="");
      virtual double GetAsk(string symbol);
      virtual double GetBid(string symbol);
};

//+------------------------------------------------------------------+
//| Constructor
//+------------------------------------------------------------------+

CMarketMock::CMarketMock(){
   ArrayResize(m_symbols, 0);
   ArrayResize(m_volumes, 0);
   ArrayResize(m_ask, 0);
   ArrayResize(m_bid, 0);
}

//+------------------------------------------------------------------+
//| Destructor
//+------------------------------------------------------------------+

CMarketMock::~CMarketMock(){
}

//+------------------------------------------------------------------+
//| Add a symbol to the false market
//| @param symbol Symbol to add
//+------------------------------------------------------------------+

void CMarketMock::AddSymbol(string symbol){
   int size = ArraySize(m_symbols);
   ArrayResize(m_symbols, size+1);
   ArrayResize(m_volumes, size+1);
   ArrayResize(m_bid, size+1);
   ArrayResize(m_ask, size+1);
   m_symbols[size] = symbol;
   m_volumes[size] = 0;
   m_ask[size] = 1.0001;
   m_bid[size] = 1.0000;
}

//+------------------------------------------------------------------+
//| Set the Ask value
//| @param symbol Symbol concerned
//| @param ask Value of the ask
//+------------------------------------------------------------------+

void CMarketMock::SetAsk(string symbol, double ask){
   if(!IsSymbol(symbol))
      AddSymbol(symbol);
   
   int size = ArraySize(m_symbols);
   
   for(int i = 0; i < size; i++){
      if(m_symbols[i]==symbol){
         Print("Change "+symbol+" ask to "+DoubleToString(ask));
         m_ask[i] = ask;
      }
   }
}

//+------------------------------------------------------------------+
//| Set the bid value
//| @param symbol Symbol concerned
//| @param bid Value of the bid
//+------------------------------------------------------------------+


void CMarketMock::SetBid(string symbol, double bid){
   if(!IsSymbol(symbol))
      AddSymbol(symbol);
   
   int size = ArraySize(m_symbols);
   
   for(int i = 0; i < size; i++){
      if(m_symbols[i]==symbol){
         Print("Change "+symbol+" bid to "+DoubleToString(bid));
         m_bid[i] = bid;
      }
   }
}
      
//+------------------------------------------------------------------+
//| Set the position volume of the mock market
//| @param symbol Symbol of the position
//+------------------------------------------------------------------+

void CMarketMock::SetPositionVolume(string symbol, double volume){
   if(!IsSymbol(symbol))
      AddSymbol(symbol);
   
   int size = ArraySize(m_symbols);
   
   for(int i = 0; i < size; i++){
      if(m_symbols[i]==symbol){
         Print("Change "+symbol+" volume to "+DoubleToString(volume));
         m_volumes[i] = volume;
      }
   }
}

//+------------------------------------------------------------------+
//| Check if the symbol is present in the base of the object
//| @param symbol Symbol to test
//| @return true if the symbol is present, false otherwise
//+------------------------------------------------------------------+

bool CMarketMock::IsSymbol(string symbol){
   int size = ArraySize(m_symbols);
   
   for(int i = 0; i < size; i++){
      if(m_symbols[i]==symbol)
         return true;
   }
   
   return false;
}

//+------------------------------------------------------------------+
//| Open a fake position
//| @param symbol Symbol of the position
//| @param order_type The type of order
//| @param volume The order volume
//| @param price The order price
//| @param sl The order stop loss
//| @param tp The order take profit
//| @param comment The order comment
//| @return bool if order is ok, false otherwise
//+------------------------------------------------------------------+

bool CMarketMock::PositionOpen(const string symbol,const ENUM_ORDER_TYPE order_type,const double volume, const double price,const double sl,const double tp,const string comment=""){
   CAccountInfo accountInfos;
   double spread = MathAbs(GetBid(symbol)-GetAsk(symbol));
   
   // Verification of the symbol
   if(!this.IsSymbol(symbol))
      return false;
   
   // Verification of the volume
   if(volume<=0||volume>accountInfos.MaxLotCheck(symbol, order_type, price))
      return false;
   
   // Verification of the price
   if(price<0)
      return false;
   else if(order_type==ORDER_TYPE_BUY_LIMIT&&price>GetAsk(symbol))
      return false;
   else if(order_type==ORDER_TYPE_BUY_STOP&&price<GetAsk(symbol))
      return false;
   else if(order_type==ORDER_TYPE_BUY_STOP_LIMIT&&price<GetAsk(symbol))
      return false;
   else if(order_type==ORDER_TYPE_SELL_LIMIT&&price<GetBid(symbol))
      return false;
   else if(order_type==ORDER_TYPE_SELL_STOP&&price>GetBid(symbol))
      return false;
   else if(order_type==ORDER_TYPE_SELL_STOP_LIMIT&&price>GetBid(symbol))
      return false;
      
   // Verification of the stop loss
   if(order_type==ORDER_TYPE_BUY&&sl>GetBid(symbol))
      return false;
   else if(order_type==ORDER_TYPE_BUY_LIMIT&&sl>(price-spread)) // Price - spread = Bid if buy
      return false;
   else if(order_type==ORDER_TYPE_BUY_STOP&&sl>(price-spread)) // Price - spread = Bid if buy
      return false;
   else if(order_type==ORDER_TYPE_BUY_STOP_LIMIT&&sl>(price-spread)) // Price - spread = Bid if buy
      return false;
   else if(order_type==ORDER_TYPE_SELL&&sl<GetAsk(symbol)&&sl!=0)
      return false;
   else if(order_type==ORDER_TYPE_SELL_LIMIT&&sl<(price+spread)&&sl!=0) // Price + spread = Ask if sell
      return false;
   else if(order_type==ORDER_TYPE_SELL_STOP&&sl<(price+spread)&&sl!=0) // Price + spread = Ask if sell
      return false;
   else if(order_type==ORDER_TYPE_SELL_STOP_LIMIT&&sl<(price+spread)&&sl!=0) // Price + spread = Ask if sell
      return false;
      
   // Verification of the take profit
   if(order_type==ORDER_TYPE_BUY&&tp<GetBid(symbol)&&tp!=0)
      return false;
   else if(order_type==ORDER_TYPE_BUY_LIMIT&&tp<(price-spread)&&tp!=0) // Price - spread = Bid if buy
      return false;
   else if(order_type==ORDER_TYPE_BUY_STOP&&tp<(price-spread)&&tp!=0) // Price - spread = Bid if buy
      return false;
   else if(order_type==ORDER_TYPE_BUY_STOP_LIMIT&&tp<(price-spread)&&tp!=0) // Price - spread = Bid if buy
      return false;
   else if(order_type==ORDER_TYPE_SELL&&tp>GetAsk(symbol))
      return false;
   else if(order_type==ORDER_TYPE_SELL_LIMIT&&tp>(price+spread)) // Price + spread = Ask if sell
      return false;
   else if(order_type==ORDER_TYPE_SELL_STOP&&tp>(price+spread)) // Price + spread = Ask if sell
      return false;
   else if(order_type==ORDER_TYPE_SELL_STOP_LIMIT&&tp>(price+spread)) // Price + spread = Ask if sell
      return false;
   
   double newVolume = volume;
   
   if(order_type==ORDER_TYPE_SELL||order_type==ORDER_TYPE_SELL_LIMIT||order_type==ORDER_TYPE_SELL_STOP||order_type==ORDER_TYPE_SELL_STOP_LIMIT)
      newVolume *= -1;
   
   newVolume += GetPositionVolume(symbol);
   SetPositionVolume(symbol, newVolume);
   return true;
}

//+------------------------------------------------------------------+
//| Return the actual position volume of the mock market
//| @param symbol Symbol of the position
//| @return the volume (negative=sell, positive=buy) if the symbol exist, false otherwise
//+------------------------------------------------------------------+

double CMarketMock::GetPositionVolume(string symbol){
   int size = ArraySize(m_symbols);
   string value;
   
   for(int i = 0; i < size; i++){
      if(m_symbols[i]==symbol)
         value = DoubleToString(m_volumes[i]);
         if(m_volumes[i]>0)
            return StringToDouble(StringSubstr(value,0,4));
         else
            return StringToDouble(StringSubstr(value,0,5));
   }
   
   return -1;
}

//+------------------------------------------------------------------+
//| Return the actual fake Ask
//| @param symbol Symbol concerned
//| @return Actual fake ask
//+------------------------------------------------------------------+

double CMarketMock::GetAsk(string symbol){
   int size = ArraySize(m_symbols);
   
   for(int i = 0; i < size; i++){
      if(m_symbols[i]==symbol)
         return m_ask[i];
   }
   
   return -1.0;
}

//+------------------------------------------------------------------+
//| Return the actual fake Bid
//| @param symbol Symbol concerned
//| @return Actual fake bid
//+------------------------------------------------------------------+

double CMarketMock::GetBid(string symbol){
   int size = ArraySize(m_symbols);
   
   for(int i = 0; i < size; i++){
      if(m_symbols[i]==symbol)
         return m_bid[i];
   }
   
   return -1.0;
}

//+------------------------------------------------------------------+
