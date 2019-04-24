#ifndef DoSSiERConnect_H
#define DoSSiERConnect_H 1

#include "artg4tk/ExpDataAccess/ExpDataAccess.hh"

#include <curl/curl.h> 
// #include "/usr/local/Anaconda3-5.0.1/include/curl/curl.h"
 
class DoSSiERConnect : public ExpDataAccess
{

   public:
   
      // ctor & dtor
      //
      DoSSiERConnect() : ExpDataAccess(), fCurl(0) {}
      virtual ~DoSSiERConnect();
   
      virtual bool Init();
      
      virtual std::string& GetDictionary( const std::string& );

      virtual std::string& GetResponse( const int );
      
   private:
   
      // private member function(s)
      //
      static size_t  Write2String( void*, size_t, size_t, void* );
        
      // private data members
      //
      CURL*       fCurl;
           
};

#endif
