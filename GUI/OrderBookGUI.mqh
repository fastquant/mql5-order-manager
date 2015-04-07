//+------------------------------------------------------------------+
//|                                                 OrderBookGUI.mqh |
//|                                     Copyright 2015, Louis Fradin |
//|                                      http://en.louis-fradin.net/ |
//+------------------------------------------------------------------+

#property copyright "Copyright 2015, Louis Fradin"
#property link      "http://en.louis-fradin.net/"

#include "../Source/OrderBook.mqh"
#include <Controls\Dialog.mqh>
#include <Controls\Label.mqh>
#include "OrderList.mqh"
#include <Arrays\List.mqh>

//+------------------------------------------------------------------+
//| Prototype
//+------------------------------------------------------------------+

class COrderBookGUI : public CAppDialog{
   private:
      int m_x1;
      int m_x2;
      int m_y1;
      int m_y2;
   
      COrderBook *m_orderBook;
      
      CLabel *m_ordersLabel;
      COrderList *m_orders;
      
      virtual bool Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
      
      bool CreateOrdersVisualization();
      
   public:
      COrderBookGUI(COrderBook *orderBook);
      ~COrderBookGUI();
      
      bool Create(string name);
      void Update();
      void Destroy(const int reason=0);
};

//+------------------------------------------------------------------+
//| Create the vizualisation of orders
//| @return true if successful, false otherwise
//+------------------------------------------------------------------+

bool COrderBookGUI::CreateOrdersVisualization(){
   
   //Coordinates
   int x1=10;
   int y1=30;
   int x2=m_x2-28;
   int y2=m_y2-48;
   
   // Label text
   string label = " Symbol | Type | Status | Price | Vol | SL | TP";

   // Create
   if(!m_ordersLabel.Create(m_chart_id,m_name+"Label1", m_subwin, 25, 40, m_x2-28, 50))
      return false;
   if(!m_orders.Create(m_chart_id,m_name+"ListView1",m_subwin,x1,y1,x2,y2))
      return(false);
   if(!Add(m_orders))
      return(false);
   
   // Write label
   if(!m_ordersLabel.Text(label))
      return false;
   
   // Success
   return true;
}

//+------------------------------------------------------------------+
//| Constructor
//| @param orderBook The orderBook to control with this GUI
//+------------------------------------------------------------------+

COrderBookGUI::COrderBookGUI(COrderBook *orderBook){
   m_orderBook = orderBook;
   m_orders = new COrderList(m_orderBook);
   m_ordersLabel = new CLabel();
}

//+------------------------------------------------------------------+
//| Destructor
//+------------------------------------------------------------------+

COrderBookGUI::~COrderBookGUI(){
   delete m_orders;
}

//+------------------------------------------------------------------+
//| Create Override
//| @return true if successful, false otherwise
//+------------------------------------------------------------------+

bool COrderBookGUI::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2){
   // Coordinates
   m_x1 = x1;
   m_x2 = x2;
   m_y1 = y1;
   m_y2 = y2;
   
   // Calling the method of the parent class
   if(!CAppDialog::Create(0,name,0, m_x1, m_y1, m_x2, m_y2))
      return(false);
   
   // Creating Orders Visualization
   if(!CreateOrdersVisualization())
      return(false);
   
   return true;
}

bool COrderBookGUI::Create(string name){
   return this.Create(0,name,0, 10, 10, 700, 300);
}

//+------------------------------------------------------------------+
//| Update the GUI
//+------------------------------------------------------------------+

void COrderBookGUI::Update(){
   m_orders.Update();
   ChartRedraw();
}

//+------------------------------------------------------------------+
//| Close all orders before destroy the object
//| @param reason The code number of the reason
//+------------------------------------------------------------------+

void COrderBookGUI::Destroy(const int reason=0){
   m_orderBook.CloseOrders();
   CAppDialog::Destroy(reason);
}

//+------------------------------------------------------------------+
