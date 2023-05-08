//+------------------------------------------------------------------+
//|                                                 MQL4Migrator.mqh |
//|                                          Copyright 2023, Awptic. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Awptic."
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//--- Declaration of constants
#define OP_BUY 0           //Buy 
#define OP_SELL 1          //Sell 
#define OP_BUYLIMIT 2      //Pending order of BUY LIMIT type 
#define OP_SELLLIMIT 3     //Pending order of SELL LIMIT type 
#define OP_BUYSTOP 4       //Pending order of BUY STOP type 
#define OP_SELLSTOP 5      //Pending order of SELL STOP type 
//---
#define MODE_OPEN 0
#define MODE_CLOSE 3
#define MODE_VOLUME 4 
#define MODE_REAL_VOLUME 5
#define MODE_TRADES 0
#define MODE_HISTORY 1
#define SELECT_BY_POS 0
#define SELECT_BY_TICKET 1
//---
#define DOUBLE_VALUE 0
#define FLOAT_VALUE 1
#define LONG_VALUE INT_VALUE
//---
#define CHART_BAR 0
#define CHART_CANDLE 1
//---
#define MODE_ASCEND 0
#define MODE_DESCEND 1
//---
#define MODE_LOW 1
#define MODE_HIGH 2
#define MODE_TIME 5
#define MODE_BID 9
#define MODE_ASK 10
#define MODE_POINT 11
#define MODE_DIGITS 12
#define MODE_SPREAD 13
#define MODE_STOPLEVEL 14
#define MODE_LOTSIZE 15
#define MODE_TICKVALUE 16
#define MODE_TICKSIZE 17
#define MODE_SWAPLONG 18
#define MODE_SWAPSHORT 19
#define MODE_STARTING 20
#define MODE_EXPIRATION 21
#define MODE_TRADEALLOWED 22
#define MODE_MINLOT 23
#define MODE_LOTSTEP 24
#define MODE_MAXLOT 25
#define MODE_SWAPTYPE 26
#define MODE_PROFITCALCMODE 27
#define MODE_MARGINCALCMODE 28
#define MODE_MARGININIT 29
#define MODE_MARGINMAINTENANCE 30
#define MODE_MARGINHEDGED 31
#define MODE_MARGINREQUIRED 32
#define MODE_FREEZELEVEL 33
//---
#define EMPTY -1
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES TFMigrate(int tf) {
    switch(tf) {
        case 0: return(PERIOD_CURRENT);
        case 1: return(PERIOD_M1);
        case 5: return(PERIOD_M5);
        case 15: return(PERIOD_M15);
        case 30: return(PERIOD_M30);
        case 60: return(PERIOD_H1);
        case 240: return(PERIOD_H4);
        case 1440: return(PERIOD_D1);
        case 10080: return(PERIOD_W1);
        case 43200: return(PERIOD_MN1);
        
        case 2: return(PERIOD_M2);
        case 3: return(PERIOD_M3);
        case 4: return(PERIOD_M4);      
        case 6: return(PERIOD_M6);
        case 10: return(PERIOD_M10);
        case 12: return(PERIOD_M12);
        case 16385: return(PERIOD_H1);
        case 16386: return(PERIOD_H2);
        case 16387: return(PERIOD_H3);
        case 16388: return(PERIOD_H4);
        case 16390: return(PERIOD_H6);
        case 16392: return(PERIOD_H8);
        case 16396: return(PERIOD_H12);
        case 16408: return(PERIOD_D1);
        case 32769: return(PERIOD_W1);
        case 49153: return(PERIOD_MN1);      
        default: return(PERIOD_CURRENT);
    }
}

double Ask() {
    MqlTick last_tick;
    SymbolInfoTick(_Symbol, last_tick);
    return last_tick.ask;
}

int Bars() {
    return Bars(_Symbol, _Period);
}

double Bid() {
    MqlTick last_tick;
    SymbolInfoTick(_Symbol, last_tick);
    return last_tick.bid;
}

void BarInfo(double& array[], int mode, int start, int count) {
    ArrayRemove(array, 0, WHOLE_ARRAY);
    ArrayResize(array, count - start);
    ArraySetAsSeries(array, true);
    switch (mode) {
        case 0 : // Open
            CopyOpen(_Symbol, _Period, start, count, array);
            break;
        case 1 : // Close
            CopyClose(_Symbol, _Period, start, count, array);
            break;
        case 2 : // High
            CopyHigh(_Symbol, _Period, start, count, array);
            break;
        case 3 : // Low
            CopyLow(_Symbol, _Period, start, count, array);
            break;
    }
}

void Open(double& array[], int start = NULL, int count = NULL) {
    if (start == NULL) start = 0;
    if (count == NULL) count = Bars();
    BarInfo(array, 0, start, count);
}

void Close(double& array[], int start = NULL, int count = NULL) {
    if (start == NULL) start = 0;
    if (count == NULL) count = Bars();
    BarInfo(array, 1, start, count);
}

void High(double& array[], int start = NULL, int count = NULL) {
    if (start == NULL) start = 0;
    if (count == NULL) count = Bars();
    BarInfo(array, 2, start, count);
}

void Low(double& array[], int start = NULL, int count = NULL) {
    if (start == NULL) start = 0;
    if (count == NULL) count = Bars();
    BarInfo(array, 3, start, count);
}

void Volume(long& array[], int start = NULL, int count = NULL) {
    if (start == NULL) start = 0;
    if (count == NULL) count = Bars();
    ArrayRemove(array, 0, WHOLE_ARRAY);
    ArrayResize(array, count);
    ArraySetAsSeries(array, true);
    CopyTickVolume(_Symbol, _Period, start, count, array);
}

void Time(datetime& array[], int start = NULL, int count = NULL) {
    if (start == NULL) start = 0;
    if (count == NULL) count = Bars();
    ArrayRemove(array, 0, WHOLE_ARRAY);
    ArrayResize(array, count);
    ArraySetAsSeries(array, true);
    CopyTime(_Symbol, _Period, start, count, array);
}

double CopyBufferMQL4(int handle,int index,int shift) {
    double buf[];
    switch(index)
        {
        case 0: if(CopyBuffer(handle,0,shift,1,buf)>0)
            return(buf[0]); break;
        case 1: if(CopyBuffer(handle,1,shift,1,buf)>0)
            return(buf[0]); break;
        case 2: if(CopyBuffer(handle,2,shift,1,buf)>0)
            return(buf[0]); break;
        case 3: if(CopyBuffer(handle,3,shift,1,buf)>0)
            return(buf[0]); break;
        case 4: if(CopyBuffer(handle,4,shift,1,buf)>0)
            return(buf[0]); break;
        default: break;
        }
    return(EMPTY_VALUE);
}

ENUM_MA_METHOD MethodMigrate(int method) {
    switch(method) {
      case 0: return(MODE_SMA);
      case 1: return(MODE_EMA);
      case 2: return(MODE_SMMA);
      case 3: return(MODE_LWMA);
      default: return(MODE_SMA);
    }
}
ENUM_APPLIED_PRICE PriceMigrate(int price){
    switch(price) {
        case 1: return(PRICE_CLOSE);
        case 2: return(PRICE_OPEN);
        case 3: return(PRICE_HIGH);
        case 4: return(PRICE_LOW);
        case 5: return(PRICE_MEDIAN);
        case 6: return(PRICE_TYPICAL);
        case 7: return(PRICE_WEIGHTED);
        default: return(PRICE_CLOSE);
    }
}
ENUM_STO_PRICE StoFieldMigrate(int field) {
    switch(field) {
        case 0: return(STO_LOWHIGH);
        case 1: return(STO_CLOSECLOSE);
        default: return(STO_LOWHIGH);
    }
}
//+------------------------------------------------------------------+
enum ALLIGATOR_MODE  { MODE_GATORJAW=1,   MODE_GATORTEETH, MODE_GATORLIPS };
enum ADX_MODE        { MODE_MAIN,         MODE_PLUSDI, MODE_MINUSDI };
enum UP_LOW_MODE     { MODE_BASE,         MODE_UPPER,      MODE_LOWER };
enum ICHIMOKU_MODE   { MODE_TENKANSEN=1,  MODE_KIJUNSEN, MODE_SENKOUSPANA, MODE_SENKOUSPANB, MODE_CHINKOUSPAN };
enum MAIN_SIGNAL_MODE{ MODE_MAIN,         MODE_SIGNAL };

double iAC (string symbol, int timeframe, int shift) {
    ENUM_TIMEFRAMES tf=TFMigrate(timeframe);
    int handle=iAC(symbol,tf);
    if(handle<0)
        {
        Print("The iAC object is not created: Error",GetLastError());
        return(-1);
        }
    else
        return(CopyBufferMQL4(handle,0,shift));
}

double iAD(string symbol, int timeframe, int shift) {
    ENUM_TIMEFRAMES tf=TFMigrate(timeframe);
    int handle=(int)iAD(symbol,tf,VOLUME_TICK);
    if(handle<0)
        {
        Print("The iAD object is not created: Error",GetLastError());
        return(-1);
        }
    else
        return(CopyBufferMQL4(handle,0,shift));
}

double iAlligator(string symbol,
                  int timeframe,
                  int jaw_period,
                  int jaw_shift,
                  int teeth_period,
                  int teeth_shift,
                  int lips_period,
                  int lips_shift,
                  int ma_method,
                  int applied_price,
                  int mode,
                  int shift)
{
    ENUM_TIMEFRAMES tf=TFMigrate(timeframe);
    ENUM_MA_METHOD method=MethodMigrate(ma_method);
    ENUM_APPLIED_PRICE price=PriceMigrate(applied_price);
    int handle=iAlligator(symbol,tf,jaw_period,jaw_shift,
                            teeth_period,teeth_shift,
                            lips_period,lips_shift,
                            method,price);
    if(handle<0)
        {
        Print("The iAlligator object is not created: Error",GetLastError());
        return(-1);
        }
    else
        return(CopyBufferMQL4(handle,mode-1,shift));
}

double iADX(string symbol,
            int timeframe,
            int period,
            int applied_price,
            int mode,
            int shift)
{
    ENUM_TIMEFRAMES tf=TFMigrate(timeframe);
    int handle=iADX(symbol,tf,period);
    if(handle<0)
        {
        Print("The iADX object is not created: Error",GetLastError());
        return(-1);
        }
    else
        return(CopyBufferMQL4(handle,mode,shift));   
}

double iATR(string symbol,
            int timeframe,
            int period,
            int shift)
{
    ENUM_TIMEFRAMES tf=TFMigrate(timeframe);
    int handle=iATR(symbol,tf,period);
    if(handle<0)
        {
        Print("The iATR object is not created: Error",GetLastError());
        return(-1);
        }
    else
        return(CopyBufferMQL4(handle,0,shift));
}

double iMA(string symbol,
           int timeframe,
           int period,
           int ma_shift,
           int ma_method,
           int applied_price,
           int shift)
{
    ENUM_TIMEFRAMES tf=TFMigrate(timeframe);
    ENUM_MA_METHOD method=MethodMigrate(ma_method);
    ENUM_APPLIED_PRICE price=PriceMigrate(applied_price);
    int handle=iMA(symbol,tf,period,ma_shift,
                    method,price);
    if(handle<0)
        {
        Print("The iMA object is not created: Error",GetLastError());
        return(-1);
        }
    else
        return(CopyBufferMQL4(handle,0,shift));
}

double iMAOnArray(double& array[],
                  int total,
                  int period,
                  int ma_shift,
                  int ma_method,
                  int shift)
{
    double buf[],arr[];
    if(total==0) total=ArraySize(array);
    if(total>0 && total<=period) return(0);
    if(shift>total-period-ma_shift) return(0);
    switch(ma_method)
        {
        case MODE_SMA :
            {
            total=ArrayCopy(arr,array,0,shift+ma_shift,period);
            if(ArrayResize(buf,total)<0) return(0);
            double sum=0;
            int    i,pos=total-1;
            for(i=1;i<period;i++,pos--)
                sum+=arr[pos];
            while(pos>=0)
            {
                sum+=arr[pos];
                buf[pos]=sum/period;
                sum-=arr[pos+period-1];
                pos--;
            }
            return(buf[0]);
            }
        case MODE_EMA :
            {
            if(ArrayResize(buf,total)<0) return(0);
            double pr=2.0/(period+1);
            int    pos=total-2;
            while(pos>=0)
            {
                if(pos==total-2) buf[pos+1]=array[pos+1];
                buf[pos]=array[pos]*pr+buf[pos+1]*(1-pr);
                pos--;
            }
            return(buf[shift+ma_shift]);
            }
        case MODE_SMMA :
            {
            if(ArrayResize(buf,total)<0) return(0);
            double sum=0;
            int    i,k,pos;
            pos=total-period;
            while(pos>=0)
            {
                if(pos==total-period)
                {
                for(i=0,k=pos;i<period;i++,k++)
                    {
                    sum+=array[k];
                    buf[k]=0;
                    }
                }
                else sum=buf[pos+1]*(period-1)+array[pos];
                buf[pos]=sum/period;
                pos--;
            }
            return(buf[shift+ma_shift]);
            }
        case MODE_LWMA :
            {
            if(ArrayResize(buf,total)<0) return(0);
            double sum=0.0,lsum=0.0;
            double price;
            int    i,weight=0,pos=total-1;
            for(i=1;i<=period;i++,pos--)
            {
                price=array[pos];
                sum+=price*i;
                lsum+=price;
                weight+=i;
            }
            pos++;
            i=pos+period;
            while(pos>=0)
            {
                buf[pos]=sum/weight;
                if(pos==0) break;
                pos--;
                i--;
                price=array[pos];
                sum=sum-lsum+price*period;
                lsum-=array[i];
                lsum+=price;
            }
            return(buf[shift+ma_shift]);
            }
        default: return(0);
        }
    return(0);
}

int iBars(string symbol,
          int timeframe)
{
    ENUM_TIMEFRAMES tf=TFMigrate(timeframe);
    return(Bars(symbol,tf));
}

int iBarShift(string symbol,
                int tf,
                datetime time,
                bool exact=false)
{
    if(time<0) return(-1);
    ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
    datetime Arr[],time1;
    CopyTime(symbol,timeframe,0,1,Arr);
    time1=Arr[0];
    if(CopyTime(symbol,timeframe,time,time1,Arr)>0)
        {
        if(ArraySize(Arr)>2) return(ArraySize(Arr)-1);
        if(time<time1) return(1);
        else return(0);
        }
    else return(-1);
}

double iClose(string symbol,int tf,int index)
{
   if(index < 0) return(-1);
   double Arr[];
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   if(CopyClose(symbol,timeframe, index, 1, Arr)>0) 
        return(Arr[0]);
   else return(-1);
}

double iHigh(string symbol,int tf,int index)

{
   if(index < 0) return(-1);
   double Arr[];
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   if(CopyHigh(symbol,timeframe, index, 1, Arr)>0) 
        return(Arr[0]);
   else return(-1);
}

int iHighest(string symbol,
                 int tf,
                 int type,
                 int count=WHOLE_ARRAY,
                 int start=0)
{
   if(start<0) return(-1);
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   if(count<=0) count=Bars(symbol,timeframe);
   if(type<=MODE_OPEN)
     {
      double myArray[];
      Open(myArray, start, count);
      return(ArrayMaximum(myArray,0,count)+start);
     }
   if(type==MODE_LOW)
     {
      double myArray[];
      Low(myArray, start, count);
      return(ArrayMaximum(myArray,0,count)+start);
     }
   if(type==MODE_HIGH)
     {
      double myArray[];
      High(myArray, start, count);
      return(ArrayMaximum(myArray,0,count)+start);
     }
   if(type==MODE_CLOSE)
     {
      double myArray[];
      Close(myArray, start, count);
      return(ArrayMaximum(myArray,0,count)+start);
     }
   if(type==MODE_VOLUME)
     {
      long myArray[];
      Volume(myArray, start, count);
      return(ArrayMaximum(myArray,0,count)+start);
     }
   if(type>=MODE_TIME)
     {
      datetime myArray[];
      Time(myArray, start, count);
      return(ArrayMaximum(myArray,0,count)+start);
      //---
     }
   return(0);
}

double iLow(string symbol,int tf,int index)
{
   if(index < 0) return(-1);
   double Arr[];
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   if(CopyLow(symbol,timeframe, index, 1, Arr)>0)
        return(Arr[0]);
   else return(-1);
}

int iLowest(string symbol,
                int tf,
                int type,
                int count=WHOLE_ARRAY,
                int start=0)
{
    if(start<0) return(-1);
    ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
    if(count<=0) count=Bars(symbol,timeframe);
    if(type<=MODE_OPEN)
     {
      double myArray[];
      Open(myArray, start, count);
      return(ArrayMinimum(myArray,0,count)+start);
     }
   if(type==MODE_LOW)
     {
      double myArray[];
      Low(myArray, start, count);
      return(ArrayMinimum(myArray,0,count)+start);
     }
   if(type==MODE_HIGH)
     {
      double myArray[];
      High(myArray, start, count);
      return(ArrayMinimum(myArray,0,count)+start);
     }
   if(type==MODE_CLOSE)
     {
      double myArray[];
      Close(myArray, start, count);
      return(ArrayMinimum(myArray,0,count)+start);
     }
   if(type==MODE_VOLUME)
     {
      long myArray[];
      Volume(myArray, start, count);
      return(ArrayMinimum(myArray,0,count)+start);
     }
   if(type>=MODE_TIME)
     {
      datetime myArray[];
      Time(myArray, start, count);
      return(ArrayMinimum(myArray,0,count)+start);
      //---
     }
    //---
    return(0);
}

double iOpen(string symbol,int tf,int index)
{   
   if(index < 0) return(-1);
   double Arr[];
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   if(CopyOpen(symbol,timeframe, index, 1, Arr)>0) 
        return(Arr[0]);
   else return(-1);
}

int WindowBarsPerChart() {
    return (int) ChartGetInteger(0, CHART_VISIBLE_BARS, 0);
}

string WindowExpertName() {
    return MQLInfoString(MQL_PROGRAM_NAME);
}

int WindowFind(string name)
{
    int window=-1;
    if((ENUM_PROGRAM_TYPE)MQLInfoInteger(MQL_PROGRAM_TYPE)==PROGRAM_INDICATOR)
        {
            window=ChartWindowFind();
        }
    else
        {
            window=ChartWindowFind(0,name);
            if(window==-1) Print(__FUNCTION__+"(): Error = ",GetLastError());
        }
    return(window);
}

int WindowFirstVisibleBar() {
    return (int)ChartGetInteger(0,CHART_FIRST_VISIBLE_BAR,0);
}

// +----------------------------------------------------------------------------------------
bool ObjectDelete(string name)
{
   return(ObjectDelete(0,name));
}

int ObjectFind(string name)
{
   return(ObjectFind(0,name));
}

double ObjectGet(string name,
                     int index)
{
   switch(index)
     {
      case OBJPROP_TIME:
         return((double)ObjectGetInteger(0,name,OBJPROP_TIME));
      case OBJPROP_PRICE:
         return(ObjectGetDouble(0,name,OBJPROP_PRICE));
      case OBJPROP_COLOR:
         return((double)ObjectGetInteger(0,name,OBJPROP_COLOR));
      case OBJPROP_STYLE:
         return((double)ObjectGetInteger(0,name,OBJPROP_STYLE));
      case OBJPROP_WIDTH:
         return((double)ObjectGetInteger(0,name,OBJPROP_WIDTH));
      case OBJPROP_BACK:
         return((double)ObjectGetInteger(0,name,OBJPROP_WIDTH));
      case OBJPROP_RAY:
         return((double)ObjectGetInteger(0,name,OBJPROP_RAY_RIGHT));
      case OBJPROP_ELLIPSE:
         return((double)ObjectGetInteger(0,name,OBJPROP_ELLIPSE));
      case OBJPROP_SCALE:
         return(ObjectGetDouble(0,name,OBJPROP_SCALE));
      case OBJPROP_ANGLE:
         return(ObjectGetDouble(0,name,OBJPROP_ANGLE));
      case OBJPROP_ARROWCODE:
         return((double)ObjectGetInteger(0,name,OBJPROP_ARROWCODE));
      case OBJPROP_TIMEFRAMES:
         return((double)ObjectGetInteger(0,name,OBJPROP_TIMEFRAMES));
      case OBJPROP_DEVIATION:
         return(ObjectGetDouble(0,name,OBJPROP_DEVIATION));
      case OBJPROP_FONTSIZE:
         return((double)ObjectGetInteger(0,name,OBJPROP_FONTSIZE));
      case OBJPROP_CORNER:
         return((double)ObjectGetInteger(0,name,OBJPROP_CORNER));
      case OBJPROP_XDISTANCE:
         return((double)ObjectGetInteger(0,name,OBJPROP_XDISTANCE));
      case OBJPROP_YDISTANCE:
         return((double)ObjectGetInteger(0,name,OBJPROP_YDISTANCE));
      case OBJPROP_LEVELS:
         return((double)ObjectGetInteger(0,name,OBJPROP_LEVELS));
      case OBJPROP_LEVELCOLOR:
         return((double)ObjectGetInteger(0,name,OBJPROP_LEVELCOLOR));
      case OBJPROP_LEVELSTYLE:
         return((double)ObjectGetInteger(0,name,OBJPROP_LEVELSTYLE));
      case OBJPROP_LEVELWIDTH:
         return((double)ObjectGetInteger(0,name,OBJPROP_LEVELWIDTH));
     }
     
     return 0;
}

string ObjectName(int index)
{
   return(ObjectName(0,index));
}

bool ObjectMove(string name,
                    int point,
                    datetime time1,
                    double price1)
{
   return(ObjectMove(0,name,point,time1,price1));
}

int ObjectsTotal(int type=EMPTY,
                     int window=-1)
{
   return(ObjectsTotal(0,window,type));
}

int ObjectType(string name)
{
   return((int)ObjectGetInteger(0,name,OBJPROP_TYPE));
}

bool ObjectSet(string name,
                   int index,
                   double value)
{
   switch(index)
     {
      case OBJPROP_TIME:
         ObjectSetInteger(0,name,OBJPROP_TIME,(int)value);return(true);
      case OBJPROP_PRICE:
         ObjectSetDouble(0,name,OBJPROP_PRICE,value);return(true);
      case OBJPROP_COLOR:
         ObjectSetInteger(0,name,OBJPROP_COLOR,(int)value);return(true);
      case OBJPROP_STYLE:
         ObjectSetInteger(0,name,OBJPROP_STYLE,(int)value);return(true);
      case OBJPROP_WIDTH:
         ObjectSetInteger(0,name,OBJPROP_WIDTH,(int)value);return(true);
      case OBJPROP_BACK:
         ObjectSetInteger(0,name,OBJPROP_BACK,(int)value);return(true);
      case OBJPROP_RAY:
         ObjectSetInteger(0,name,OBJPROP_RAY_RIGHT,(int)value);return(true);
      case OBJPROP_ELLIPSE:
         ObjectSetInteger(0,name,OBJPROP_ELLIPSE,(int)value);return(true);
      case OBJPROP_SCALE:
         ObjectSetDouble(0,name,OBJPROP_SCALE,value);return(true);
      case OBJPROP_ANGLE:
         ObjectSetDouble(0,name,OBJPROP_ANGLE,value);return(true);
      case OBJPROP_ARROWCODE:
         ObjectSetInteger(0,name,OBJPROP_ARROWCODE,(int)value);return(true);
      case OBJPROP_TIMEFRAMES:
         ObjectSetInteger(0,name,OBJPROP_TIMEFRAMES,(int)value);return(true);
      case OBJPROP_DEVIATION:
         ObjectSetDouble(0,name,OBJPROP_DEVIATION,value);return(true);
      case OBJPROP_FONTSIZE:
         ObjectSetInteger(0,name,OBJPROP_FONTSIZE,(int)value);return(true);
      case OBJPROP_CORNER:
         ObjectSetInteger(0,name,OBJPROP_CORNER,(int)value);return(true);
      case OBJPROP_XDISTANCE:
         ObjectSetInteger(0,name,OBJPROP_XDISTANCE,(int)value);return(true);
      case OBJPROP_YDISTANCE:
         ObjectSetInteger(0,name,OBJPROP_YDISTANCE,(int)value);return(true);
      case OBJPROP_LEVELS:
         ObjectSetInteger(0,name,OBJPROP_LEVELS,(int)value);return(true);
      case OBJPROP_LEVELCOLOR:
         ObjectSetInteger(0,name,OBJPROP_LEVELCOLOR,(int)value);return(true);
      case OBJPROP_LEVELSTYLE:
         ObjectSetInteger(0,name,OBJPROP_LEVELSTYLE,(int)value);return(true);
      case OBJPROP_LEVELWIDTH:
         ObjectSetInteger(0,name,OBJPROP_LEVELWIDTH,(int)value);return(true);

      default: return(false);
     }
   return(false);
}

bool SetIndexBufferMQL4(int index, double& array[]) {
    return SetIndexBuffer(index, array, INDICATOR_DATA);
}

void SetIndexStyle(int index,
                    int type,
                    int style=EMPTY,
                    int width=EMPTY,
                    color clr=CLR_NONE)
{
    if(width>-1)
        PlotIndexSetInteger(index,PLOT_LINE_WIDTH,width);
    if(clr!=CLR_NONE)
        PlotIndexSetInteger(index,PLOT_LINE_COLOR,clr);
    switch(type)
        {
        case 0:
            PlotIndexSetInteger(index,PLOT_DRAW_TYPE,DRAW_LINE);
        case 1:
            PlotIndexSetInteger(index,PLOT_DRAW_TYPE,DRAW_SECTION);
        case 2:
            PlotIndexSetInteger(index,PLOT_DRAW_TYPE,DRAW_HISTOGRAM);
        case 3:
            PlotIndexSetInteger(index,PLOT_DRAW_TYPE,DRAW_ARROW);
        case 4:
            PlotIndexSetInteger(index,PLOT_DRAW_TYPE,DRAW_ZIGZAG);
        case 12:
            PlotIndexSetInteger(index,PLOT_DRAW_TYPE,DRAW_NONE);

        default:
            PlotIndexSetInteger(index,PLOT_DRAW_TYPE,DRAW_LINE);
        }
    switch(style)
        {
        case 0:
            PlotIndexSetInteger(index,PLOT_LINE_STYLE,STYLE_SOLID);
        case 1:
            PlotIndexSetInteger(index,PLOT_LINE_STYLE,STYLE_DASH);
        case 2:
            PlotIndexSetInteger(index,PLOT_LINE_STYLE,STYLE_DOT);
        case 3:
            PlotIndexSetInteger(index,PLOT_LINE_STYLE,STYLE_DASHDOT);
        case 4:
            PlotIndexSetInteger(index,PLOT_LINE_STYLE,STYLE_DASHDOTDOT);

        default: return;
        }
}

void SetIndexLabel(int index,
                   string text)
{
    PlotIndexSetString(index, PLOT_LABEL, text);
}