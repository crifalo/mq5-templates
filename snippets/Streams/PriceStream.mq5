// PriceStream v1.1

#ifndef PriceStream_IMP
#define PriceStream_IMP

#include <ABaseStream.mq5>
class PriceStream : public ABaseStream
{
   ENUM_APPLIED_PRICE _price;
   double _pipSize;
public:
   PriceStream(string symbol, const ENUM_TIMEFRAMES timeframe, const ENUM_APPLIED_PRICE price)
      :ABaseStream(symbol, timeframe)
   {
      _price = price;

      double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
      int digit = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS); 
      int mult = digit == 3 || digit == 5 ? 10 : 1;
      _pipSize = point * mult;
   }

   virtual bool GetValues(const int period, const int count, double &val[])
   {
      int bars = iBars(_symbol, _timeframe);
      int oldIndex = bars - period - 1;
      for (int i = 0; i < count; ++i)
      {
         switch (_price)
         {
            case PRICE_CLOSE:
               val[i] = iClose(_symbol, _timeframe, oldIndex + i);
               break;
            case PRICE_OPEN:
               val[i] = iOpen(_symbol, _timeframe, oldIndex + i);
               break;
            case PRICE_HIGH:
               val[i] = iHigh(_symbol, _timeframe, oldIndex + i);
               break;
            case PRICE_LOW:
               val[i] = iLow(_symbol, _timeframe, oldIndex + i);
               break;
            case PRICE_MEDIAN:
               val[i] = (iHigh(_symbol, _timeframe, oldIndex + i) + iLow(_symbol, _timeframe, oldIndex + i)) / 2.0;
               break;
            case PRICE_TYPICAL:
               val[i] = (iHigh(_symbol, _timeframe, oldIndex + i) + iLow(_symbol, _timeframe, oldIndex + i) + iClose(_symbol, _timeframe, oldIndex + i)) / 3.0;
               break;
            case PRICE_WEIGHTED:
               val[i] = (iHigh(_symbol, _timeframe, oldIndex + i) + iLow(_symbol, _timeframe, oldIndex + i) + iClose(_symbol, _timeframe, oldIndex + i) * 2) / 4.0;
               break;
         }
         val[i] += _shift * _pipSize;
      }
      return true;
   }
};

#endif