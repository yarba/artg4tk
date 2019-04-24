
#include "artg4tk/ExpDataAccess/DoSSiERConnect.hh"
#include <sstream>
#include <cassert>

DoSSiERConnect::~DoSSiERConnect()
{

  if (fCurl) curl_easy_cleanup(fCurl); 

}

bool DoSSiERConnect::Init()
{

   // Don't do it more than once
   //
   if ( fInitialized ) return fInitialized;
   
   // make sure path (HTTP) is valid
   //
   assert( fPath != "" );
      
   fCurl = curl_easy_init();
   if ( !fCurl ) 
   {
      fInitialized = false; // just in case...
      return fInitialized;
   }
      
   curl_easy_setopt( fCurl, CURLOPT_WRITEFUNCTION, &Write2String );
//   curl_easy_setopt( fCurl, CURLOPT_WRITEFUNCTION, Write2String ); // By address or by value ???
   curl_easy_setopt( fCurl, CURLOPT_WRITEDATA,     &fResponse);

    //
    // to disable "secure" access (e.g. via port 8181) set to false both (!!!) CURLOPT_SSL_VERIFYPEER and CURLOPT_SSL_VERIFYHOST
    // NOTE: the "PROXY" ones will NOT do anything (i.e. CURLOPT_PROXY_SSL_VERIFYPEER & CURLOPT_PROXY_SSL_VERIFYHOST don't matter)
    // available starting curl v7.52.0
    // 
    // Interactive use on tev.fnal.gov: 
    // /usr/local/Anaconda3-5.0.1/bin/curl -k "http://g4devel.fnal.gov:8181/DoSSiER/WebAPI/get?format=json&record=2" (with quotation)     //
    // curl_easy_setopt( fCurl, CURLOPT_SSL_VERIFYPEER, 0L);
    // curl_easy_setopt( fCurl, CURLOPT_SSL_VERIFYHOST, 0L );

   // fPath = "http://g4validation.fnal.gov:8080/DoSSiER/WebAPI";
   // fPath = "https://g4devel.fnal.gov:8181/DoSSiER/WebAPI"; 
   
   // now test the connection
   //
   curl_easy_setopt( fCurl, CURLOPT_URL, fPath.c_str() );
   CURLcode status = curl_easy_perform( fCurl );    
   if ( status != 0 )
   {
      std::cout << " VDBConnect::Init(): BAD CURLcode status = " << status << std::endl;
      fInitialized = false;
      return fInitialized;
   }
   
   fInitialized = true;
   
   return fInitialized;

}

std::string& DoSSiERConnect::GetDictionary( const std::string& type )
{

   fResponse.clear();
   
   std::string url = fPath + "/dictionary?name=" + type;

   curl_easy_setopt( fCurl, CURLOPT_URL, url.c_str() );
   
   CURLcode status = curl_easy_perform( fCurl ); 
   if ( status != 0 )
   {
      std::cout << " BAD CURLcode status = " << status << std::endl;
   }
      
   return fResponse;

}

std::string& DoSSiERConnect::GetResponse( const int id )
{

   std::ostringstream os;
   os << id;
    
   std::string url = fPath + "/get?format=json&record=" + os.str();
   
   // reset (clear out) fResponse
   // otherwise each call will *append* the string record to fResponse... 
   //
   fResponse.clear(); // or one can do: fResponse = "";

   // The URL should be (re)set for each specific record
   // Other options can be set just once (see Init())
   //
   curl_easy_setopt( fCurl, CURLOPT_URL, url.c_str() );
   
   // Now just do it !
   //
   CURLcode status = curl_easy_perform( fCurl ); 
   if ( status != 0 )
   {
      std::cout << " BAD CURLcode status = " << status << std::endl;
   }
   
   // The fResponse variable should now contain the contents of the HTTP response
   
   return fResponse;
    
}

size_t DoSSiERConnect::Write2String( void* ptr, size_t size, size_t count, void* stream )
{

   ((std::string*)stream)->append((char*)ptr, 0, size*count);
   
   return size*count;

}
