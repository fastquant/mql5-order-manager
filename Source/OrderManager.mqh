//+------------------------------------------------------------------+
//|                                                 OrderManager.mqh |
//|                                     Copyright 2014, Louis Fradin |
//|                                      http://en.louis-fradin.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, Louis Fradin"
#property link      "http://en.louis-fradin.net/"
#property version   "1.00"

#include <Arrays\List.mqh>
#include <Expert\ExpertMoney.mqh>
#include <Trade\AccountInfo.mqh>
#include "Order.mqh"
#include "Interfaces/MarketInterface.mqh"

//+------------------------------------------------------------------+
//| Prototype of the class                                           
//+------------------------------------------------------------------+

class COrderManager : public CExpertMoney{
   private:
      CList *m_orderList;
      IMarket *m_market;
      
      bool Close(COrder *order);
      bool Execute(COrder *order);
   public:
      COrderManager(IMarket *market);
     ~COrderManager();
     
     // Log functions
     void DisplayOrders();
     
     // Informations functions
     int GetNbrOfTickets();
     COrderInfos* GetOrderInfos(uint position);
     
     // Orders management
     bool CreateOrder(string symbol, ENUM_ORDER_TYPE orderType,
                        double volume, double stopLoss = 0,
                        double takeProfit = 0, double price = 0);
     bool Clean();
     bool CloseOrder(uint position);
     bool CloseOrders();
     bool Synchronise();
};

//+------------------------------------------------------------------+
//| Execute an order
//| @param order A pointer to the order to execute
//+------------------------------------------------------------------+

bool COrderManager::Execute(COrder *order){
   CAccountInfo accountInfos;
   
   if(order.GetType()==ORDER_TYPE_BUY||order.GetType()==ORDER_TYPE_SELL){ // If it is a simple order (buy or sell)
      // Setting the price
      if(order.GetType()==ORDER_TYPE_BUY)
         order.SetPrice(m_market.GetBid(order.GetSymbol()));
      else
         order.SetPrice(m_market.GetAsk(order.GetSymbol()));
      
      // Volume check
      if(order.GetVolume()>accountInfos.MaxLotCheck(order.GetSymbol(), order.GetType(), order.GetPrice())){
         Print("CMarket::Execute: The volume ("+DoubleToString(order.GetVolume())
            +") is not allowed (max="
            +DoubleToString(accountInfos.MaxLotCheck(order.GetSymbol(), order.GetType(), order.GetPrice()))+")");
         return false;
      }
      
      string comment = "Order "+IntegerToString(order.GetID());
      
      // Execution   
      if(m_market.PositionOpen(order.GetSymbol(), order.GetType(),
         order.GetVolume(), order.GetPrice(), 0, 0, comment)){ // If the execution is correct
         order.SetStatus(ORDER_STATE_FILLED); // The ticket is tagged as executed
         return true;
      }
      else{
         order.SetStatus(ORDER_STATE_REJECTED); // The ticket is tagged as having an error
         Print("CMarket::Execute: An error occured during the order execution.");
         return false;
      }
   }
   else{
      Print("CMarket::Execute: This type of order is not implemented yet. Type:  "+IntegerToString(order.GetType()));
      return false;
   }
}

//+------------------------------------------------------------------+
//| Close an order
//| @param order A pointer to the order to execute
//+------------------------------------------------------------------+

bool COrderManager::Close(COrder *order){
   CAccountInfo accountInfos;
   
   if(order.GetStatus() == ORDER_STATE_FILLED){
      ENUM_ORDER_TYPE orderType;
      double price;
      string comment;
      
      // Setting the price and the orderType
      if(order.GetType()==ORDER_TYPE_BUY||order.GetType()==ORDER_TYPE_BUY_LIMIT
         ||order.GetType()==ORDER_TYPE_BUY_STOP||order.GetType()==ORDER_TYPE_BUY_STOP_LIMIT){ // If it is a buy order
         orderType = ORDER_TYPE_SELL; // The close order will be a sell order
         price = m_market.GetAsk(order.GetSymbol()); // So the price is the bid
      }
      else{ // If it is a sell order
         orderType = ORDER_TYPE_BUY; // The close order will be a buy order
         price = m_market.GetBid(order.GetSymbol()); // So the price is the ask
      }
      
      comment = "Closing order "+IntegerToString(order.GetID());
      
      // Execution
      if(m_market.PositionOpen(order.GetSymbol(), orderType, order.GetVolume(), price, 0, 0, comment)){ // If the close order has been sent successfully
         order.SetStatus(ORDER_STATE_EXPIRED); // The ticket is tagged as closed
         return true;
      }
      else{
         Print("COrder::Close: Impossible to close the order "+IntegerToString(order.GetID()));
         return false;
      }
   }
   else{
      Print("COrder::Close: Impossible to close a none executed order. Order "+IntegerToString(order.GetID())+".");
      return false;
   }
}

//+------------------------------------------------------------------+
//| Constructor                                                      
//+------------------------------------------------------------------+

COrderManager::COrderManager(IMarket *market){
   MathSrand(GetTickCount());
   m_orderList = new CList();
   m_market = market;
}

//+------------------------------------------------------------------+
//| Destructor                                                       
//+------------------------------------------------------------------+

COrderManager::~COrderManager(){
   m_orderList.Clear();
   delete m_orderList;
}

//+------------------------------------------------------------------+
//| Display orders in the logs
//+------------------------------------------------------------------+

void COrderManager::DisplayOrders(){
   Print("+--- Display the tickets ---+");
   int listSize = m_orderList.Total();
   COrder *ticket = m_orderList.GetFirstNode();
   
   // For each ticket
   for(int i = 0; i < listSize; i++){
      ticket.DisplayTicket();
      ticket = m_orderList.GetNextNode();
   }
}

//+------------------------------------------------------------------+
//| Get the number of tickets in the OrderManager
//| @return The number of tickets
//+------------------------------------------------------------------+

int COrderManager::GetNbrOfTickets(){
   return m_orderList.Total();
}

//+------------------------------------------------------------------+
//| Get the info about an order
//| @param position The position in the list of orders
//| @return The orderInfo pointer if it exists, NULL otherwise
//+------------------------------------------------------------------+

COrderInfos* COrderManager::GetOrderInfos(uint position){
   if(position<(uint)m_orderList.Total()){
      return m_orderList.GetNodeAtIndex(position);
   }
   else{
      Print("COrderManager::GetOrderInfos: There is no order at position "+IntegerToString(position));
      return NULL;
   }
} 

//+------------------------------------------------------------------+
//| Create orders
//| @param symbol The order symbol
//| @param orderType The order Type
//| @param volume The order volume
//| @param stopLoss The order stop loss
//| @param takeProfit The order take profit
//| @param price The order price
//| @param comment The order comment
//| @return true if the order is correct, false otherwise
//+------------------------------------------------------------------+

bool COrderManager::CreateOrder(string symbol, ENUM_ORDER_TYPE orderType,
                              double volume, double stopLoss=0,
                              double takeProfit=0, double price = 0){
   COrder *ticket = new COrder(); // Ticket creation
   
   // Insertion of the symbol
   if(!ticket.SetSymbol(symbol)){
      delete ticket;
      Print("COrderManager::CreateOrder: Symbol error, order creation aborted.");
      return false;
   }
   
   // Insertion of the order type
   ticket.SetOrderType(orderType);
   
   // Insertion of the price
   if(!ticket.SetPrice(price)){
      delete ticket;
      Print("COrderManager::CreateOrder: Price error, order creation aborted.");
      return false;
   }
   
   // Insertion of the volume
   if(!ticket.SetVolume(volume)){
      delete ticket;
      Print("COrderManager::CreateOrder: Volume error, order creation aborted.");
      return false;
   }
   
   // Insertion of the take profit
   if(!ticket.SetTakeProfit(takeProfit)){
      delete ticket;
      Print("COrderManager::CreateOrder: TakeProfit error, order creation aborted.");
      return false;
   }
   
   // Insertion of the stop loss
   if(!ticket.SetStopLoss(stopLoss)){
      delete ticket;
      Print("COrderManager::CreateOrder: StopLoss error, order creation aborted.");
      return false;
   }
   
   if(this.Execute(ticket)){
      // Insertion of the ticket
      m_orderList.Add(ticket);
         
      return true;
   }
   else{
      delete ticket;
      Print("COrderManager::CreateOrder: Error during execution.");
      return false;
   }
}

//+------------------------------------------------------------------+
//| Clean useless orders (closed, error, etc.)
//| @return true if successful, false otherwise
//+------------------------------------------------------------------+

bool COrderManager::Clean(){
   int listSize = m_orderList.Total();
   COrder *ticket = m_orderList.GetLastNode();
   
   for(int i = listSize-1; i >= 0; i--){
      ticket = m_orderList.GetPrevNode();
   
      if(ticket.GetStatus()==ORDER_STATE_CANCELED
         ||ticket.GetStatus()==ORDER_STATE_REJECTED
         ||ticket.GetStatus()==ORDER_STATE_EXPIRED){
         m_orderList.Delete(i);
      }
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Close ticket selected by its ID
//| @param id Order ID
//| @return true if the order is closed, false otherwise
//+------------------------------------------------------------------+

bool COrderManager::CloseOrder(uint nbr){
   if(nbr<(uint)m_orderList.Total()){
      COrder *ticket = m_orderList.GetNodeAtIndex(nbr);
          
      if(ticket.GetStatus()==ORDER_STATE_FILLED){ // If the order is executed
         if(!this.Close(ticket)){
            Print("COrderManager::CloseOrder: Impossible to close the order");
            return false;
         }
         else
            return true;
      }
      else{
         Print("COrderManager::CloseOrder: The order is already closed");
         return false;
      }

   }
   else{
      Print("COrderManager::CloseOrder: There is no ticket at the position "+IntegerToString(nbr));
      return false;
   }
}

//+------------------------------------------------------------------+
//| Close every order of the order book
//| @return true if successful, false otherwise
//+------------------------------------------------------------------+

bool COrderManager::CloseOrders(){
   int listSize = m_orderList.Total();
   COrder *ticket = m_orderList.GetFirstNode();
   
   for(int i = 0; i < listSize; i++){
      if(ticket.GetStatus()==ORDER_STATE_FILLED){ // If the order is executed
         if(!this.Close(ticket)){
            Print("COrderManager::CloseOrders: Impossible to close the order");
            return false;
         }
         else
            Print("COrderManager::CloseOrders: Order "+IntegerToString(ticket.GetID())+" closed");
      }
   
      ticket = m_orderList.GetNextNode();
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Synchronise OrderManager with the market status
//| @return true if successfull, false otherwise
//+------------------------------------------------------------------+

bool COrderManager::Synchronise(){
   COrder *ticket;
   double ask, bid;
   int listSize, index;
   
   listSize = m_orderList.Total();
   ticket = m_orderList.GetFirstNode();

   // For each ticket
   for(int i = 0; i < listSize; i++){
      // Recuperation of the market price
      ask = m_market.GetAsk(ticket.GetSymbol());
      bid = m_market.GetBid(ticket.GetSymbol());
      
      // Verification of the recovered prices
      if(ask==0.0||bid==0.0){
         Print("COrderManager::Synchronise: Recuperation of market prices impossible.");
         return false;
      }
      
      if(ticket.GetStatus()==ORDER_STATE_FILLED){
         if(ticket.GetType()==ORDER_TYPE_SELL){
            if((ticket.GetStopLoss()<=bid&&ticket.GetStopLoss()!=0.0)
               ||ticket.GetTakeProfit()>=bid){
               // Close the order
               if(!this.Close(ticket)){
                  Print("COrderManager::Synchronise: Error during closing order "+IntegerToString(ticket.GetID()));
                  return false;
               }
               else
                  Print("COrderManager::Synchronise: Order "+IntegerToString(ticket.GetID())+" closed");
            }
         }
         else if(ticket.GetType()==ORDER_TYPE_BUY){
            if(ticket.GetStopLoss()>=ask
               ||(ticket.GetTakeProfit()<=ask&&ticket.GetTakeProfit()!=0.0)){
               
               // Close the order
               if(!this.Close(ticket)){
                  Print("COrderManager::Synchronise: Error during closing order "+IntegerToString(ticket.GetID()));
                  return false;
               }
               else
                  Print("COrderManager::Synchronise: Order "+IntegerToString(ticket.GetID())+" closed");
            }
         }
         
         ticket = m_orderList.GetNextNode();
      }
      else if(ticket.GetStatus()==ORDER_STATE_PLACED){
         // In development
         ticket = m_orderList.GetNextNode();
      }
      else{
         index = m_orderList.IndexOf(ticket);
         ticket = m_orderList.GetNextNode();
         
         m_orderList.Delete(index);
      }
   }
   
   return true;
}

//+------------------------------------------------------------------+
