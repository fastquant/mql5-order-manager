//+------------------------------------------------------------------+
//|                                                    OrderList.mqh |
//|                                     Copyright 2015, Louis Fradin |
//|                                     https://en.louis-fradin.net/ |
//+------------------------------------------------------------------+

#property copyright "Copyright 2015, Louis Fradin"
#property link      "https://en.louis-fradin.net/"
#property version   "1.00"

#include <Controls\ListView.mqh>
#include <Arrays\List.mqh>
#include "../Source/OrderBook.mqh"

//+------------------------------------------------------------------+
//| Prototype
//+------------------------------------------------------------------+

class COrderList : public CListView{
   private:
      COrderBook *m_orderBook;
      int m_total;
      
   public:
      COrderList(COrderBook *orderBook);
      ~COrderList();
      
      void Update();
};

//+------------------------------------------------------------------+
//| Constructor
//+------------------------------------------------------------------+

COrderList::COrderList(COrderBook *orderBook){
   m_orderBook = orderBook;
}

//+------------------------------------------------------------------+
//| Destructor
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
   
   // Synchronise the orderBook
   m_orderBook.Synchronise();
   orderNbr = m_orderBook.GetNbrOfTickets();
   
   // If there is less orders than before
   if(orderNbr<m_total){
      for(int j = m_total-1; j >= orderNbr; j--)
         this.ItemDelete(j);
   }
   
   for(i = 0; i < orderNbr; i++){
      // Get infos
      orderInfos = m_orderBook.GetOrderInfos(i);
      
      // Add to chart
      if(i<m_total)
         this.ItemUpdate(i, orderInfos.FormatTicket(), 10);
      else
         this.ItemAdd(orderInfos.FormatTicket(), 10);
   }
   
   m_total = i;
}

//+------------------------------------------------------------------+
