#ifndef ASCIIRecord_H
#define ASCIIRecord_h 1

#include "artg4tk/ExpDataAccess/ExpDataAccess.hh"

class ASCIIRecord : public ExpDataAccess
{

   public:
      
      // ctor & dtor
      //
      ASCIIRecord() : ExpDataAccess() {}
      virtual ~ASCIIRecord() {} 
      
      
      virtual bool Init();
      
      virtual std::string& GetDictionary( const std::string& );
      
      virtual std::string& GetResponse( const int );


};


#endif
