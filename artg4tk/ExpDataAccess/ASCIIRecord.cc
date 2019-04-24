#include "artg4tk/ExpDataAccess/ASCIIRecord.hh"
#include <sstream>
#include <fstream>
#include <cassert>

bool ASCIIRecord::Init()
{

   assert( fPath != "" );
   
   fInitialized = true;
   
   return fInitialized;

}

std::string& ASCIIRecord::GetDictionary( const std::string& type )
{
   
   fResponse.clear();
   
   std::string fname = fPath + "/" + type + ".json";

   std::ifstream inFile;
   inFile.open(fname.c_str()); //open 

   std::stringstream strStream;

   if (inFile.fail()) 
   {
      std::cout << "Cannot find " << fname.c_str() << std::endl;
      assert(0);
   }
   else 
   {
    strStream << inFile.rdbuf(); //read the file
    inFile.close();
   }

//   return strStream.str();//str holds the content of the file

   fResponse = strStream.str();
   return fResponse;
   
}

std::string& ASCIIRecord::GetResponse( const int id )
{

   fResponse.clear();
   
   std::string fname = fPath + "/dossier-" + std::to_string(id) + ".json";
   
   std::ifstream inFile;
   inFile.open(fname.c_str()); //open 

   std::stringstream strStream;

   if (inFile.fail()) 
   {
      std::cout << "Cannot find " << fname.c_str() << std::endl;
      assert(0);
   }
   else 
   {
    strStream << inFile.rdbuf(); //read the file
    inFile.close();
   }

//   return strStream.str();//str holds the content of the file

   fResponse = strStream.str();
   return fResponse;
    
}
