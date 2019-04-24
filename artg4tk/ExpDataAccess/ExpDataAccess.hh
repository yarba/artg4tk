#ifndef ExpDataAccess_H
#define ExpDataAccess_H 1

#include <iostream>
#include <string>

class ExpDataAccess
{

   public:
   
      // ctor & dtor
      //
      ExpDataAccess() : fResponse(""), fInitialized(false) {}
      virtual ~ExpDataAccess() {}
      
      void SetPath( const std::string& path ) { fPath=path; return; }
      
      virtual bool Init() = 0;
      bool IsInitialized() { return fInitialized; } 
      
      virtual std::string& GetDictionary( const std::string& ) = 0;
      
      virtual std::string& GetResponse( const int ) = 0; 
      
   protected:
   
      // protected data members
      //
      std::string fPath;
      std::string fResponse;
      bool fInitialized;
      

};

#endif


