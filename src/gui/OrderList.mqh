//+------------------------------------------------------------------+
//|                                                    OrderList.mqh |
//|                                     Copyright 2015, Louis Fradin |
//|                                     https://en.louis-fradin.net/ |
//+------------------------------------------------------------------+
// Properties
#property copyright "Copyright 2015, Louis Fradin"
#property link      "https://en.louis-fradin.net/"
#property version   "1.00"
// Includes
#include <Controls\ListView.mqh>
#include <Arrays\List.mqh>
#include "../OrderManager.mqh"
//+------------------------------------------------------------------+
//| Class prototype
//+------------------------------------------------------------------+
class COrderList : public CListView{
   private:
      COrderManager *m_OrderManager;
      int m_total;
   public:
      COrderList(COrderManager *OrderManager);
      ~COrderList();
      void Update();
};
//+------------------------------------------------------------------+
//| Class Constructor
//+------------------------------------------------------------------+
COrderList::COrderList(COrderManager *OrderManager){
   m_OrderManager = OrderManager;
}
//+------------------------------------------------------------------+
//| Class Destructor
//+------------------------------------------------------------------+
COrderList::~COrderList(){
}
//+------------------------------------------------------------------+
//| Update the list
//+------------------------------------------------------------------+
void COrderList::Update(){
   COrderInfos* orderInfos;
   int i;
   int orderNbr;
   // Synchronise the OrderManager
   m_OrderManager.Synchronise();
   orderNbr = m_OrderManager.GetNbrOfTickets();
   // If there is less orders than before
   if(orderNbr<m_total){
      for(int j = m_total-1; j >= orderNbr; j--)
         this.ItemDelete(j);
   }
   for(i = 0; i < orderNbr; i++){
      // Get infos
      orderInfos = m_OrderManager.GetOrderInfos(i);
      
      // Add to chart
      if(i<m_total)
         this.ItemUpdate(i, orderInfos.FormatTicket(), 10);
      else
         this.ItemAdd(orderInfos.FormatTicket(), 10);
   }
   m_total = i;
}
//+------------------------------------------------------------------+
