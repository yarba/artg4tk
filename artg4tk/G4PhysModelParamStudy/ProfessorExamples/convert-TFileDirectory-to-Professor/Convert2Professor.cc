#include <iostream>
#include <fstream>
#include <string>
#include <vector>

#include "TSystem.h"
#include "TFile.h"
#include "TDirectory.h"
#include "TH1D.h"
#include "TClass.h"
#include "TKey.h"
#include "TObjArray.h"
#include "TObjString.h"


int main()
{

   std::vector<std::string> analysis_files;
   analysis_files.push_back("../../analysis/results-root/FTFP_proton3.824GeV-C-ProcL_IAEA.root");
   analysis_files.push_back("../../analysis/results-root/FTFP_proton3.824GeV-Pb-ProcL_IAEA.root");
   analysis_files.push_back("../../analysis/results-root/FTFP_proton5.0GeV-C-ProcL_HARP_ITEP.root");
   analysis_files.push_back("../../analysis/results-root/FTFP_proton5.0GeV-Pb-ProcL_HARP_ITEP.root");
   analysis_files.push_back("../../analysis/results-root/FTFP_proton158.0GeV-C-ProcL_NA49.root");
   
   TFile* data_file = 0;
   std::vector<TFile*> mc_files; // should correspond to the # of universes
   int iuniv = -1;
   std::string univ_name_pattern = "0000";
   
   std::vector< std::pair<std::string,double> > default_params;
   
   // populate default parameters here !!!
   default_params.push_back( std::pair<std::string,double>("NUCDESTR_P1_TGT", 0.00481) );
   // default_params.push_back( std::pair<std::string,double>("NUCDESTR_P2_TGT", 4.0) );
   default_params.push_back( std::pair<std::string,double>("NUCDESTR_P3_TGT", 2.1) );
   
   bool same_univ = false;  
   std::vector<std::string> processed_univ; 
      
   // loop over analysis Root files (TFileDirectory, i.e. output of art-based analysis)
   //
   for ( size_t i=0; i<analysis_files.size(); ++i )
   {

      TFile* afile = TFile::Open( analysis_files[i].c_str() );
      
      // ---> afile->ls();
      
      TList* keys = afile->GetListOfKeys();
      int nkeys = keys->GetEntries();
      for ( int ie=0; ie<nkeys; ++ie )
      {
      
         TObject* obj = keys->At(ie);
	 std::string dir_name = obj->GetName();
	 
	 if ( dir_name.find("Default") != std::string::npos )
	 {
	    // extract data from "Default" dir and continue
	    //
	    std::string full_dir_name = dir_name + "/Data4Professor";
	    if ( !data_file ) 
	    {
               if ( gSystem->AccessPathName( "data" ) )
               {   
                  gSystem->mkdir( "data" );
               }
	       data_file = TFile::Open( "data/data.root", "RECREATE" );
	       // also write out parameters (if they're needed in /data at all...)
	       std::ofstream params_file_dat;
	       params_file_dat.open( "data/params.dat" );
	       std::ofstream params_file_json;
	       params_file_json.open( "data/params.json" );
	       params_file_json << "{ \"params\": { \n";
	       for ( size_t ip=0; ip<default_params.size(); ++ip )
	       {
	          params_file_dat << default_params[ip].first << "  " 
		                  << default_params[ip].second << "\n"; 
		  params_file_json << "    \"" << default_params[ip].first 
		                   << "\": " << default_params[ip].second << "\n";
	       }
	       params_file_dat.close();
	       params_file_json << "  } \n";
	       params_file_json << "}\n";
	       params_file_json.close();
	    }
	    TIter next( afile->GetDirectory( full_dir_name.c_str() )->GetListOfKeys() );
	    TKey* key = (TKey*)next();
	    while ( key )
	    {
               if ( !(TClass::GetClass(key->GetClassName())->InheritsFrom(TH1::Class())) ) 
	       {
	          key = (TKey*)next();
		  continue;
	       }
	       TH1D* h = (TH1D*)key->ReadObj();
	       TH1D* hdata = new TH1D( *h );
	       // hdata->SetDirectory(0);
	       data_file->cd();
	       hdata->Write();
	       key = (TKey*)next();
	    }
	    
	    continue;
	 }
	 
	 // now get "universes"
	 
	 size_t pos = dir_name.find("Univ");
	 
	 if ( pos == std::string::npos ) continue;	 
	 
	 // check if /scan dir is there; if not, create
	 //
	 if ( gSystem->AccessPathName( "scan" ) )
	 {
	    gSystem->mkdir( "scan" );
	 }
	 	 
	 std::string univ_label = dir_name.substr( pos, 8 ); // size("Univ")+size("0000")
	 same_univ = false;	 
	 for ( size_t ipu=0; ipu<processed_univ.size(); ++ipu )
	 {
	    if ( univ_label == processed_univ[ipu] )
	    {
	       same_univ = true;
	       iuniv = ipu;
	       break;
	    }
	 }
	 if ( ! same_univ )
	 {
	    processed_univ.push_back( univ_label );
	    iuniv++;
	 }
	 int nmc = mc_files.size();
	 if ( nmc <= iuniv )
	 {
	    // no dir/file for this universe yet; create
	    //	    
	    std::string count = std::to_string(iuniv); 
	    std::string univ_name = univ_name_pattern;
	    univ_name.replace( univ_name.size()-count.size(), count.size(), count ); 
	    std::string univ_subdir = "scan/" + univ_name; 
	    if ( gSystem->AccessPathName( univ_subdir.c_str() ) )
	    {
	       gSystem->mkdir( univ_subdir.c_str() );
	    }
	    std::string mc_file_name = univ_subdir + "/g4mc.root";
	    mc_files.push_back( TFile::Open( mc_file_name.c_str(), "RECREATE" ) );
            //
	    // extract parameters !!!
	    // do it only ONCE !!!
	    if ( gSystem->AccessPathName( (univ_subdir+"/params.dat").c_str() ) )
	    {
	       std::ofstream params_file_dat;
	       params_file_dat.open( (univ_subdir+"/params.dat").c_str() );
	       std::ofstream params_file_json;
	       params_file_json.open( (univ_subdir+"/params.json").c_str() );
	       params_file_json << "{ \"params\": { \n";
	       TObjArray* objarray = (TObjArray*)afile->Get( (dir_name+"/Geant4ModelConfig").c_str() );
	       for ( int io=0; io<objarray->GetEntries(); ++io )
	       {
                  TObjString* sobj = (TObjString*)objarray->At(io);
	          std::string str = sobj->GetString().Data();
	          size_t idx1 = str.find(":");
	          std::string model = str.substr(0,idx1);
	          size_t idx2 = str.find_first_not_of(" ", idx1+1);
	          size_t idx3 = str.find("=");
	          std::string pname = str.substr(idx2,(idx3-idx2));
	          if ( pname.find("USE") != std::string::npos ) continue; // skip ON/OFF switches
	          std::string sval = str.substr( str.find("=")+1 );
	          double val = std::stod(sval);
		  params_file_dat << pname << " " << val << "\n";
		  params_file_json << "    \"" << pname << "\": " << val << "\n";
	       }
	       params_file_dat.close();
	       params_file_json << "  } \n";
	       params_file_json << "}\n";
	       params_file_json.close();
	    }
	 }	 
	 
	 //
	 std::string full_dir_name = dir_name + "/MC4Professor";
	 TIter next( afile->GetDirectory( full_dir_name.c_str() )->GetListOfKeys() );
	 TKey* key = (TKey*)next();
	 while ( key )
	 {
            if ( !(TClass::GetClass(key->GetClassName())->InheritsFrom(TH1::Class())) ) 
	    {
	          key = (TKey*)next();
		  continue;
	    }
	    TH1D* h = (TH1D*)key->ReadObj();
	    TH1D* hmc = new TH1D( *h );
	    // hmc->SetDirectory(0);
	    mc_files[iuniv]->cd();
	    hmc->Write();
	    key = (TKey*)next();
	 }
	       
      }

      iuniv = -1;
      processed_univ.clear();
      afile->Close();
      
   }

   // data_file->Write(); // NO writing the file itself since histograms are already written out
                          // otherwise histograms will appear there twice
   data_file->Close();
   
   for (size_t i=0; i<mc_files.size(); ++i )
   {
      // mc_files[i]->Write(); // NO writing the file itself since histograms are already written out
                               // otherwise histograms will appear there twice
      mc_files[i]->Close();
   }

   return 0;
   
}
