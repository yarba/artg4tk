#include "artg4tk/G4PhysModelParamStudy/AnalysisBase/ModelParamAnalyzerBase.hh"

#include "art/Framework/Core/ModuleMacros.h"

#include "art/Framework/Principal/Event.h"

// Run/Eevent data products
#include "artg4tk/DataProducts/G4DetectorHits/ArtG4tkVtx.hh"        // Event data product

#include "artg4tk/G4PhysModelParamStudy/StatAnalysisTools/Chi2Calc.hh"
#include "artg4tk/G4PhysModelParamStudy/AnalysisProducts/RecordChi2.hh"

// Root-specific headers
#include "TH1D.h"
#include "TProfile.h"

#include "CLHEP/Units/SystemOfUnits.h"

#include "art/Framework/Services/Optional/TFileService.h"

#include <vector>
#include <iostream>
#include <cmath>
#include <memory>

namespace artg4tk {

   class AnalyzerSASM6E : public ModelParamAnalyzerBase {

   public:
   
      explicit AnalyzerSASM6E( const fhicl::ParameterSet& );
      virtual ~AnalyzerSASM6E();
      
      virtual void analyze( const art::Event& event ) override;
      virtual void beginJob()                         override;
      virtual void endJob()                           override;
   
   protected:

      virtual TH1* matchExpSpectrum2MC( const int&, const std::vector<std::string>&, const int& ); 
         
   private:

      std::string extractPTBinFromTitle( const std::string& );
      double      computeDPZ( double, double, int );
      
      void calculateChi2();

      int     fNBins;
      double* fBins;
      int     fNBinsPt;
      double* fBinsPt;
      double  fDeltaPt;
   
      TH1D*              fHistoNSec;
      std::vector<TH1D*> fHistoSecPiPlus;
      std::vector<TH1D*> fHistoSecPiMinus;
      std::vector<TH1D*> fHistoSecKPlus;
      std::vector<TH1D*> fHistoSecKMinus;
      std::vector<TH1D*> fHistoSecProton;
      std::vector<TH1D*> fHistoSecAntiProton;

      Chi2Calc*          fChi2Calc;
 

   };  

}

artg4tk::AnalyzerSASM6E::AnalyzerSASM6E( const fhicl::ParameterSet& p )
  : artg4tk::ModelParamAnalyzerBase(p),
    fNBins(7), fBins(0), fNBinsPt(3), fBinsPt(0), fDeltaPt(0.1),
    fChi2Calc(0)
{
   if ( fIncludeExpData ) 
   {
      fChi2Calc = new Chi2Calc();
   }
}

artg4tk::AnalyzerSASM6E::~AnalyzerSASM6E()
{
   // delete tmp histos here
   
/*
   for ( size_t i=0; i<fHistoSecPiPlus.size(); ++i )
   {
      delete fHistoSecPiPlus[i];
   }

   for ( size_t i=0; i<fHistoSecPiMinus.size(); ++i )
   {
      delete fHistoSecPiMinus[i];
   }
*/
   if ( fBins ) delete [] fBins;
   if ( fBinsPt ) delete [] fBinsPt;
   if ( fChi2Calc ) delete fChi2Calc;
      
}

void artg4tk::AnalyzerSASM6E::beginJob()
{

   TH1::SetDefaultSumw2();
      
   art::ServiceHandle<art::TFileService> tfs;
   fHistoNSec = tfs->make<TH1D>( "NSec", "Number of secondary per inelastic interaction", 100, 0., 100 );

   std::string hname = "";

   fBins = new double[fNBins+1];
   fBins[0] = 25.;
   for ( int i=1; i<7; ++i )
   {
      fBins[i] = fBins[0] + 10.*((double)i);
   }
   fBins[7] = 91.; // (this will make center of bin at 88, i.e. 85-91) 
   
   
   fBinsPt = new double[fNBinsPt];
   fBinsPt[0] = 0.18;
   fBinsPt[1] = 0.3;
   fBinsPt[2] = 0.5;
   
   fHistoSecPiPlus.push_back( new TH1D( "tmp_piplus_pt180", "pt=0.18 [GeV/c]", 1000, 0., 100.   ) );
   fHistoSecPiPlus.push_back( new TH1D( "tmp_piplus_pt300", "pt=0.3 [GeV/c]",  1000, 0., 100.  ) );
   fHistoSecPiPlus.push_back( new TH1D( "tmp_piplus_pt500", "pt=0.5 [GeV/c]",  1000, 0., 100.  ) );

   fHistoSecPiMinus.push_back( new TH1D( "tmp_piminus_pt180", "pt=0.18 [GeV/c]", 1000, 0., 100.  ) );
   fHistoSecPiMinus.push_back( new TH1D( "tmp_piminus_pt300", "pt=0.3 [GeV/c]",  1000, 0., 100.  ) );
   fHistoSecPiMinus.push_back( new TH1D( "tmp_piminus_pt500", "pt=0.5 [GeV/c]",  1000, 0., 100.  ) );

   fHistoSecKPlus.push_back( new TH1D( "tmp_kplus_pt180", "pt=0.18 [GeV/c]", 1000, 0., 100.  ) );
   fHistoSecKPlus.push_back( new TH1D( "tmp_kplus_pt300", "pt=0.3 [GeV/c]",  1000, 0., 100.  ) );
   fHistoSecKPlus.push_back( new TH1D( "tmp_kplus_pt500", "pt=0.5 [GeV/c]",  1000, 0., 100.  ) );

   fHistoSecKMinus.push_back( new TH1D( "tmp_kminus_pt180", "pt=0.18 [GeV/c]", 1000, 0., 100.  ) );
   fHistoSecKMinus.push_back( new TH1D( "tmp_kminus_pt300", "pt=0.3 [GeV/c]",  1000, 0., 100.  ) );
   fHistoSecKMinus.push_back( new TH1D( "tmp_kminus_pt500", "pt=0.5 [GeV/c]",  1000, 0., 100.  ) );

   fHistoSecProton.push_back( new TH1D( "tmp_proton_pt180", "pt=0.18 [GeV/c]", 1000, 0., 100.  ) );
   fHistoSecProton.push_back( new TH1D( "tmp_proton_pt300", "pt=0.3 [GeV/c]",  1000, 0., 100.  ) );
   fHistoSecProton.push_back( new TH1D( "tmp_proton_pt500", "pt=0.5 [GeV/c]",  1000, 0., 100.  ) );

   fHistoSecAntiProton.push_back( new TH1D( "tmp_antiproton_pt180", "pt=0.18 [GeV/c]", 1000, 0., 100.  ) );
   fHistoSecAntiProton.push_back( new TH1D( "tmp_antiproton_pt300", "pt=0.3 [GeV/c]",  1000, 0., 100.  ) );
   fHistoSecAntiProton.push_back( new TH1D( "tmp_antiproton_pt500", "pt=0.5 [GeV/c]",  1000, 0., 100.  ) );

   return;

}

void artg4tk::AnalyzerSASM6E::endJob()
{
      
   ModelParamAnalyzerBase::endJob();
   
   if ( !fXSecInit ) return;
   
   double stat = fHistoNSec->GetEntries();
   // double stat  = fHistoNSec->Integral();
   
   if ( stat <= 0 ) return;

   double scale = fXSecOnTarget / ( (double)stat ) ;

   art::ServiceHandle<art::TFileService> tfs;  

   if ( fIncludeExpData )
   {
      bool ok = matchVDBRec2MC( fBTConf.GetBeamPartID(),
                                fBTConf.GetBeamMomentum(),
				fBTConf.GetTargetID() );
      if ( !ok )
      {
         fLogInfo << " ExpData do NOT match any of the MC; NO bechmarking; bail out" ;
	 return;
      }
      
      std::vector< std::pair<int,TH1*> >::iterator itr; 

      // find and mark unmatched MC histos
      // create copies to be written to the Root output file
      // 
      std::vector<int> unmatched;

      // pi+
      //
      unmatched.clear();
      for ( size_t ih=0; ih<fHistoSecPiPlus.size(); ++ih )
      {
         for ( itr=fVDBRecID2MC.begin(); itr!=fVDBRecID2MC.end(); ++itr )
	 {
	    if ( fHistoSecPiPlus[ih] == itr->second ) break;
	 }
	 if ( itr == fVDBRecID2MC.end() ) unmatched.push_back(ih);         
      }
      for ( size_t ium=0; ium<unmatched.size(); ++ium )
      {
	 TH1D* h = fHistoSecPiPlus[unmatched[ium]];
	 TH1D* h1 = tfs->make<TH1D>( *h );
	 h1->Reset();
	 std::string hname = h->GetName();
	 size_t pos = hname.find("tmp_");
	 if ( pos != std::string::npos ) hname.erase( pos, std::string("tmp_").length() );	 
	 h1->SetName( hname.c_str() );
	 h1->SetTitle( h->GetTitle() );	
	 for ( int ix=1; ix<=fHistoSecPiPlus[unmatched[ium]]->GetNbinsX(); ++ix )
         {	    
	    double dpz = computeDPZ( fHistoSecPiPlus[unmatched[ium]]->GetBinCenter(ix),
	                             fHistoSecPiPlus[unmatched[ium]]->GetBinWidth(ix),
				     unmatched[ium] );
	    if ( dpz <= 0. ) continue;
	    double y = fHistoSecPiPlus[unmatched[ium]]->GetBinContent(ix); 
	    double ey = fHistoSecPiPlus[unmatched[ium]]->GetBinError(ix); 
	    h1->SetBinContent( ix, y/dpz );
	    h1->SetBinError( ix, ey/dpz );
         }
	 h1->Scale( scale ); // Note: NO scaling with "width" here 
	                                            // because it had to be E/dp3 - the dpt2 part of it 
						    // is already taken into account as weight (analysis)
		                                    // and the dpz contribution is done just above
      }

      // pi-
      //
      unmatched.clear();
      for ( size_t ih=0; ih<fHistoSecPiMinus.size(); ++ih )
      {
         for ( itr=fVDBRecID2MC.begin(); itr!=fVDBRecID2MC.end(); ++itr )
	 {
	    if ( fHistoSecPiMinus[ih] == itr->second ) break;
	 }
	 if ( itr == fVDBRecID2MC.end() ) unmatched.push_back(ih);         
      }
      for ( size_t ium=0; ium<unmatched.size(); ++ium )
      {
	 TH1D* h = fHistoSecPiMinus[unmatched[ium]];
	 TH1D* h1 = tfs->make<TH1D>( *h );
	 h1->Reset();
	 std::string hname = h->GetName();
	 size_t pos = hname.find("tmp_");
	 if ( pos != std::string::npos ) hname.erase( pos, std::string("tmp_").length() );	 
	 h1->SetName( hname.c_str() );
	 h1->SetTitle( h->GetTitle() );	
	 for ( int ix=1; ix<=fHistoSecPiMinus[unmatched[ium]]->GetNbinsX(); ++ix )
         {
	    double dpz = computeDPZ( fHistoSecPiMinus[unmatched[ium]]->GetBinCenter(ix),
	                             fHistoSecPiMinus[unmatched[ium]]->GetBinWidth(ix),
				     unmatched[ium] );
	    if ( dpz <= 0. ) continue;
	    double y = fHistoSecPiMinus[unmatched[ium]]->GetBinContent(ix); 
	    double ey = fHistoSecPiMinus[unmatched[ium]]->GetBinError(ix); 
	    h1->SetBinContent( ix, y/dpz );
	    h1->SetBinError( ix, ey/dpz );
         }
	 h1->Scale( scale ); // Note: NO scaling with "width" here 
	                                            // because it had to be E/dp3 - the dpt2 part of it 
						    // is already taken into account as weight (analysis)
		                                    // and the dpz contribution is done just above
      }

      // K+
      //
      unmatched.clear();
      for ( size_t ih=0; ih<fHistoSecKPlus.size(); ++ih )
      {
         for ( itr=fVDBRecID2MC.begin(); itr!=fVDBRecID2MC.end(); ++itr )
	 {
	    if ( fHistoSecKPlus[ih] == itr->second ) break;
	 }
	 if ( itr == fVDBRecID2MC.end() ) unmatched.push_back(ih);         
      }
      for ( size_t ium=0; ium<unmatched.size(); ++ium )
      {
	 TH1D* h = fHistoSecKPlus[unmatched[ium]];
	 TH1D* h1 = tfs->make<TH1D>( *h );
	 h1->Reset();
	 std::string hname = h->GetName();
	 size_t pos = hname.find("tmp_");
	 if ( pos != std::string::npos ) hname.erase( pos, std::string("tmp_").length() );
	 h1->SetName( hname.c_str() );
	 h1->SetTitle( h->GetTitle() );	
	 for ( int ix=1; ix<=fHistoSecKPlus[unmatched[ium]]->GetNbinsX(); ++ix )
         {
	    double dpz = computeDPZ( fHistoSecKPlus[unmatched[ium]]->GetBinCenter(ix),
	                             fHistoSecKPlus[unmatched[ium]]->GetBinWidth(ix),
				     unmatched[ium] );
	    if ( dpz <= 0. ) continue;
	    double y = fHistoSecKPlus[unmatched[ium]]->GetBinContent(ix); 
	    double ey = fHistoSecKPlus[unmatched[ium]]->GetBinError(ix); 
	    h1->SetBinContent( ix, y/dpz );
	    h1->SetBinError( ix, ey/dpz );
         }
	 h1->Scale( scale ); // Note: NO scaling with "width" here 
	                                            // because it had to be E/dp3 - the dpt2 part of it 
						    // is already taken into account as weight (analysis)
		                                    // and the dpz contribution is done just above
      }

      // K-
      //
      unmatched.clear();
      for ( size_t ih=0; ih<fHistoSecKMinus.size(); ++ih )
      {
         for ( itr=fVDBRecID2MC.begin(); itr!=fVDBRecID2MC.end(); ++itr )
	 {
	    if ( fHistoSecKMinus[ih] == itr->second ) break;
	 }
	 if ( itr == fVDBRecID2MC.end() ) unmatched.push_back(ih);         
      }
      for ( size_t ium=0; ium<unmatched.size(); ++ium )
      {
	 TH1D* h = fHistoSecKMinus[unmatched[ium]];
	 TH1D* h1 = tfs->make<TH1D>( *h );
	 h1->Reset();
	 std::string hname = h->GetName();
	 size_t pos = hname.find("tmp_");
	 if ( pos != std::string::npos ) hname.erase( pos, std::string("tmp_").length() );	 
	 h1->SetName( hname.c_str() );
	 h1->SetTitle( h->GetTitle() );	
	 for ( int ix=1; ix<=fHistoSecPiMinus[unmatched[ium]]->GetNbinsX(); ++ix )
         {
	    double dpz = computeDPZ( fHistoSecKMinus[unmatched[ium]]->GetBinCenter(ix),
	                             fHistoSecKMinus[unmatched[ium]]->GetBinWidth(ix),
				     unmatched[ium] );
	    if ( dpz <= 0. ) continue;
	    double y = fHistoSecKMinus[unmatched[ium]]->GetBinContent(ix); 
	    double ey = fHistoSecKMinus[unmatched[ium]]->GetBinError(ix); 
	    h1->SetBinContent( ix, y/dpz );
	    h1->SetBinError( ix, ey/dpz );
         }
	 h1->Scale( scale ); // Note: NO scaling with "width" here 
	                                            // because it had to be E/dp3 - the dpt2 part of it 
						    // is already taken into account as weight (analysis)
		                                    // and the dpz contribution is done just above
      }

      // proton
      //
      unmatched.clear();
      for ( size_t ih=0; ih<fHistoSecProton.size(); ++ih )
      {
         for ( itr=fVDBRecID2MC.begin(); itr!=fVDBRecID2MC.end(); ++itr )
	 {
	    if ( fHistoSecProton[ih] == itr->second ) break;
	 }
	 if ( itr == fVDBRecID2MC.end() ) unmatched.push_back(ih);         
      }
      for ( size_t ium=0; ium<unmatched.size(); ++ium )
      {
	 TH1D* h = fHistoSecProton[unmatched[ium]];
	 TH1D* h1 = tfs->make<TH1D>( *h );
	 h1->Reset();
	 std::string hname = h->GetName();
	 size_t pos = hname.find("tmp_");
	 if ( pos != std::string::npos ) hname.erase( pos, std::string("tmp_").length() );	 
	 h1->SetName( hname.c_str() );
	 h1->SetTitle( h->GetTitle() );	
	 for ( int ix=1; ix<=fHistoSecProton[unmatched[ium]]->GetNbinsX(); ++ix )
         {
	    double dpz = computeDPZ( fHistoSecProton[unmatched[ium]]->GetBinCenter(ix),
	                             fHistoSecProton[unmatched[ium]]->GetBinWidth(ix),
				     unmatched[ium] );
	    if ( dpz <= 0. ) continue;
	    double y = fHistoSecProton[unmatched[ium]]->GetBinContent(ix); 
	    double ey = fHistoSecProton[unmatched[ium]]->GetBinError(ix); 
	    h1->SetBinContent( ix, y/dpz );
	    h1->SetBinError( ix, ey/dpz );
         }
	 h1->Scale( scale ); // Note: NO scaling with "width" here 
	                                            // because it had to be E/dp3 - the dpt2 part of it 
						    // is already taken into account as weight (analysis)
		                                    // and the dpz contribution is done just above
      }

      // antiproton
      //
      unmatched.clear();
      for ( size_t ih=0; ih<fHistoSecAntiProton.size(); ++ih )
      {
         for ( itr=fVDBRecID2MC.begin(); itr!=fVDBRecID2MC.end(); ++itr )
	 {
	    if ( fHistoSecAntiProton[ih] == itr->second ) break;
	 }
	 if ( itr == fVDBRecID2MC.end() ) unmatched.push_back(ih);         
      }
      for ( size_t ium=0; ium<unmatched.size(); ++ium )
      {
	 TH1D* h = fHistoSecAntiProton[unmatched[ium]];
	 TH1D* h1 = tfs->make<TH1D>( *h );
	 h1->Reset();
	 std::string hname = h->GetName();
	 size_t pos = hname.find("tmp_");
	 if ( pos != std::string::npos ) hname.erase( pos, std::string("tmp_").length() );	 
	 h1->SetName( hname.c_str() );
	 h1->SetTitle( h->GetTitle() );	
	 for ( int ix=1; ix<=fHistoSecAntiProton[unmatched[ium]]->GetNbinsX(); ++ix )
         {
	    double dpz = computeDPZ( fHistoSecAntiProton[unmatched[ium]]->GetBinCenter(ix),
	                             fHistoSecAntiProton[unmatched[ium]]->GetBinWidth(ix),
				     unmatched[ium] );
	    if ( dpz <= 0. ) continue;
	    double y = fHistoSecAntiProton[unmatched[ium]]->GetBinContent(ix); 
	    double ey = fHistoSecAntiProton[unmatched[ium]]->GetBinError(ix); 
	    h1->SetBinContent( ix, y/dpz );
	    h1->SetBinError( ix, ey/dpz );
         }
	 h1->Scale( scale ); // Note: NO scaling with "width" here 
	                                            // because it had to be E/dp3 - the dpt2 part of it 
						    // is already taken into account as weight (analysis)
		                                    // and the dpz contribution is done just above
      }
      
      rebinMC2Data( "tmp_" );

      std::map<int,std::string>::iterator itr1;
      
      for ( itr=fVDBRecID2MC.begin(); itr!=fVDBRecID2MC.end(); ++itr )
      {
	 if ( ! itr->second ) continue; // // NULL histo for this exp.data record (some might be skipped)
	 for ( int ix=1; ix<=(itr->second)->GetNbinsX(); ++ix )
	 {
	       double bc = (itr->second)->GetBinCenter(ix);
	       double bw = (itr->second)->GetBinWidth(ix);
	       double pmin = bc - bw/2.;
	       double pmax = bc + bw/2.;
	       //
	       // GET PT FROM JSON RECORD 
	       //
	       itr1 = fJSONRecords.find( itr->first );
               assert( itr != fJSONRecords.end() );
               fJSON2Data->ParseMetaData( itr1->second );
	       std::vector<std::string> parval = fJSON2Data->GetMetaData().fParValues;
	       assert( parval.size() == 1 );
	       double pt = std::stod( parval[0] );
	       double ptmin = pt - fDeltaPt/2.;
	       double ptmax = pt + fDeltaPt/2.;
	       //
	       double pzmin = std::sqrt( pmin*pmin - ptmax*ptmax );
	       double pzmax = std::sqrt( pmax*pmax - ptmin*ptmin );
	       double dpz = std::fabs( pzmax - pzmin );
	       double y = (itr->second)->GetBinContent(ix);
	       double ey = (itr->second)->GetBinError(ix);
	       (itr->second)->SetBinContent( ix, y/dpz );
	       (itr->second)->SetBinError( ix, ey/dpz );
	 }
	 (itr->second)->Scale( scale );
      }

      calculateChi2();
      overlayDataMC();
      Store4Professor("SASM6E");
      
   }
   else // no exp.data included in the analysis 
   {

      // pi+
      //
      for ( size_t i=0; i<fHistoSecPiPlus.size(); ++i )
      {
	 std::string hname = fHistoSecPiPlus[i]->GetName();
	 size_t pos = hname.find("tmp_");
	 hname.erase( pos, std::string("tmp_").length() );
	 TH1D* h = tfs->make<TH1D>( *(fHistoSecPiPlus[i]) );
	 h->Reset();
	 h->SetName( hname.c_str() );
	 h->SetTitle( fHistoSecPiPlus[i]->GetTitle() );
	 for ( int ix=1; ix<fHistoSecPiPlus[i]->GetNbinsX(); ++ix )
         {
	    double dpz = computeDPZ( fHistoSecPiPlus[i]->GetBinCenter(ix),
	                             fHistoSecPiPlus[i]->GetBinWidth(ix),
				     i );
	    if ( dpz <= 0. ) continue;
	    double y = fHistoSecPiPlus[i]->GetBinContent(ix); 
	    double ey = fHistoSecPiPlus[i]->GetBinError(ix); 
	    h->SetBinContent( ix, y/dpz );
	    h->SetBinError( ix, ey/dpz );
         }
	 h->Scale( scale ); // Note: NO scaling with "width" here 
	                                           // because it had to be E/dP3 - part of it is already 
						   // taken into account as weight
		                                   // and the dpz contribution is done above
      }

      // pi-
      //
      for ( size_t i=0; i<fHistoSecPiMinus.size(); ++i )
      {
	 std::string hname = fHistoSecPiMinus[i]->GetName();
	 size_t pos = hname.find("tmp_");
	 hname.erase( pos, std::string("tmp_").length() );
	 TH1D* h = tfs->make<TH1D>( *(fHistoSecPiMinus[i]) );
	 h->Reset();
	 h->SetName( hname.c_str() );
	 h->SetTitle( fHistoSecPiMinus[i]->GetTitle() );
	 for ( int ix=1; ix<fHistoSecPiMinus[i]->GetNbinsX(); ++ix )
         {
	    double dpz = computeDPZ( fHistoSecPiMinus[i]->GetBinCenter(ix),
	                             fHistoSecPiMinus[i]->GetBinWidth(ix),
				     i );
	    if ( dpz <= 0. ) continue;
	    double y = fHistoSecPiMinus[i]->GetBinContent(ix); 
	    double ey = fHistoSecPiMinus[i]->GetBinError(ix); 
	    h->SetBinContent( ix, y/dpz );
	    h->SetBinError( ix, ey/dpz );
         }
	 h->Scale( scale ); // Note: NO scaling with "width" here 
	                                           // because it had to be E/dP3 - part of it is already 
						   // taken into account as weight
		                                   // and the dpz contribution is done above
      }
  
      // K+
      //
      for ( size_t i=0; i<fHistoSecKPlus.size(); ++i )
      {
	 std::string hname = fHistoSecKPlus[i]->GetName();
	 size_t pos = hname.find("tmp_");
	 hname.erase( pos, std::string("tmp_").length() );
	 TH1D* h = tfs->make<TH1D>( *(fHistoSecKPlus[i]) );
	 h->Reset();
	 h->SetName( hname.c_str() );
	 h->SetTitle( fHistoSecPiPlus[i]->GetTitle() );
	 for ( int ix=1; ix<fHistoSecKPlus[i]->GetNbinsX(); ++ix )
         {
	    double dpz = computeDPZ( fHistoSecKPlus[i]->GetBinCenter(ix),
	                             fHistoSecKPlus[i]->GetBinWidth(ix),
				     i );
	    if ( dpz <= 0. ) continue;
	    double y = fHistoSecKPlus[i]->GetBinContent(ix); 
	    double ey = fHistoSecKPlus[i]->GetBinError(ix); 
	    h->SetBinContent( ix, y/dpz );
	    h->SetBinError( ix, ey/dpz );
         }
	 h->Scale( scale ); // Note: NO scaling with "width" here 
	                                           // because it had to be E/dP3 - part of it is already 
						   // taken into account as weight
		                                   // and the dpz contribution is done above
      }

      // K-
      //
      for ( size_t i=0; i<fHistoSecKMinus.size(); ++i )
      {
	 std::string hname = fHistoSecKMinus[i]->GetName();
	 size_t pos = hname.find("tmp_");
	 hname.erase( pos, std::string("tmp_").length() );
	 TH1D* h = tfs->make<TH1D>( *(fHistoSecKMinus[i]) );
	 h->Reset();
	 h->SetName( hname.c_str() );
	 h->SetTitle( fHistoSecKMinus[i]->GetTitle() );
	 for ( int ix=1; ix<fHistoSecKMinus[i]->GetNbinsX(); ++ix )
         {
	    double dpz = computeDPZ( fHistoSecKMinus[i]->GetBinCenter(ix),
	                             fHistoSecKMinus[i]->GetBinWidth(ix),
				     i );
	    if ( dpz <= 0. ) continue;
	    double y = fHistoSecKMinus[i]->GetBinContent(ix); 
	    double ey = fHistoSecKMinus[i]->GetBinError(ix); 
	    h->SetBinContent( ix, y/dpz );
	    h->SetBinError( ix, ey/dpz );
         }
	 h->Scale( scale ); // Note: NO scaling with "width" here 
	                                           // because it had to be E/dP3 - part of it is already 
						   // taken into account as weight
		                                   // and the dpz contribution is done above
      }

      // proton
      //
      for ( size_t i=0; i<fHistoSecProton.size(); ++i )
      {
	 std::string hname = fHistoSecProton[i]->GetName();
	 size_t pos = hname.find("tmp_");
	 hname.erase( pos, std::string("tmp_").length() );
	 TH1D* h = tfs->make<TH1D>( *(fHistoSecProton[i]) );
	 h->Reset();
	 h->SetName( hname.c_str() );
	 h->SetTitle( fHistoSecProton[i]->GetTitle() );
	 for ( int ix=1; ix<fHistoSecProton[i]->GetNbinsX(); ++ix )
         {
	    double dpz = computeDPZ( fHistoSecProton[i]->GetBinCenter(ix),
	                             fHistoSecProton[i]->GetBinWidth(ix),
				     i );
	    if ( dpz <= 0. ) continue;
	    double y = fHistoSecProton[i]->GetBinContent(ix); 
	    double ey = fHistoSecProton[i]->GetBinError(ix); 
	    h->SetBinContent( ix, y/dpz );
	    h->SetBinError( ix, ey/dpz );
         }
	 h->Scale( scale ); // Note: NO scaling with "width" here 
	                                           // because it had to be E/dP3 - part of it is already 
						   // taken into account as weight
		                                   // and the dpz contribution is done above
      }

      // antiproton
      //
      for ( size_t i=0; i<fHistoSecAntiProton.size(); ++i )
      {
	 std::string hname = fHistoSecAntiProton[i]->GetName();
	 size_t pos = hname.find("tmp_");
	 hname.erase( pos, std::string("tmp_").length() );
	 TH1D* h = tfs->make<TH1D>( *(fHistoSecAntiProton[i]) );
	 h->Reset();
	 h->SetName( hname.c_str() );
	 h->SetTitle( fHistoSecAntiProton[i]->GetTitle() );
	 for ( int ix=1; ix<fHistoSecAntiProton[i]->GetNbinsX(); ++ix )
         {
	    double dpz = computeDPZ( fHistoSecAntiProton[i]->GetBinCenter(ix),
	                             fHistoSecAntiProton[i]->GetBinWidth(ix),
				     i );
	    if ( dpz <= 0. ) continue;
	    double y = fHistoSecAntiProton[i]->GetBinContent(ix); 
	    double ey = fHistoSecAntiProton[i]->GetBinError(ix); 
	    h->SetBinContent( ix, y/dpz );
	    h->SetBinError( ix, ey/dpz );
         }
	 h->Scale( scale ); // Note: NO scaling with "width" here 
	                                           // because it had to be E/dP3 - part of it is already 
						   // taken into account as weight
		                                   // and the dpz contribution is done above
      }

   }

   return;

}

void artg4tk::AnalyzerSASM6E::analyze( const art::Event& e )
{

   art::Handle<ArtG4tkVtx> firstint;
   e.getByLabel( fProdLabel, firstint );
   if ( !firstint.isValid() )
   {
      fLogInfo << " handle to 1st hadronic interaction is NOT valid"; // << std::endl;
      return;
   }
      
   if ( !fXSecInit ) initXSecOnTarget( firstint->GetMaterialName(), firstint->GetIncoming() );

   if ( !ensureBeamTgtConfig( e ) ) return;

   int nsec = firstint->GetNumOutcoming();
      
   if ( nsec > 0 ) fHistoNSec->Fill( (double)nsec );

   // const ArtG4tkParticle& primary = firstint->GetIncoming();

   for ( int ip=0; ip<nsec; ++ip )
   {
   
      const ArtG4tkParticle& sec = firstint->GetOutcoming( ip );

      std::string pname = sec.GetName();

      if (    pname == "pi+"    || pname == "pi-" 
           || pname == "proton" || pname == "anti_proton"
	   || pname == "kaon+"  || pname == "kaon-" )
      {
	
         CLHEP::HepLorentzVector mom4 = sec.GetMomentum() / CLHEP::GeV;
         CLHEP::Hep3Vector mom = mom4.vect();
	 double pt = mom.perp();
	
	 int id = -1;
	
/*
	 if ( fabs( pt - 0.18 ) < fDeltaPt/2. )
	 {
	    id = 0;
	 }
	 else if ( fabs( pt - 0.3 ) < fDeltaPt/2. )
	 {
	    id = 1;
	 }
	 else if ( fabs( pt - 0.5 ) < fDeltaPt/2. )
	 {
	    id = 2;
	 }
*/
	 for ( int i=0; i<fNBinsPt; ++i )
	 {
	    if ( fabs(pt-fBinsPt[i]) < fDeltaPt/2. )
	    {
	       id = i;
	       break;
	    } 
	 }
	 
	 if ( id == -1 ) continue;
	 
         double plab  = mom.mag();
	 
/*
	 if ( plab < fBins[0] ) continue;
	 if ( plab > fBins[fNBins] ) continue;
*/	 
	 if ( plab > 100. ) continue; // can't be less than 0., of course
	 
/*
	 int ib = -1;
	 for ( int j=0; j<fNBins; ++j )
	 {
	    if ( plab > fBins[j] && plab <= fBins[j+1] )
	    {
	       ib = j;
	       break;
	    }
	 }
	 if ( ib == -1 ) continue; // nothing found
*/
         double etot = mom4.e();

	 // calculate the dp3 
	 //
	 // double ptmin = pt - fDeltaPt/2.;
	 // double ptmax = pt + fDeltaPt/2.;
	 double ptmin = fBinsPt[id] - fDeltaPt/2.;
	 double ptmax = fBinsPt[id] + fDeltaPt/2.;
	 double dpt2 = ptmax*ptmax - ptmin*ptmin;
	 
	 // dpz will be calculated at the time of rebinning, in endJob() !!!
	 //
/*
	 double pzmin = std::sqrt( fBins[ib]*fBins[ib] - ptmax*ptmax );
	 double pzmax = std::sqrt( fBins[ib+1]*fBins[ib+1] - ptmin*ptmin );
	 double dpz = std::fabs( pzmax - pzmin );
	 double dp3 = CLHEP::pi * dpz * dpt2 ;
	 
	 double wt = etot / dp3; 
*/

	 double wt = etot / ( CLHEP::pi * dpt2 );
	 
	 if ( pname == "pi+" )
	 {
	   if ( id >= 0 && id < 3 ) fHistoSecPiPlus[id]->Fill( plab, wt );
	 }
	 if ( pname == "pi-" )
	 {
	   if ( id >=0 && id < 3 ) fHistoSecPiMinus[id]->Fill( plab, wt );
	 }
	 if ( pname == "proton" )
	 {	   
	   if ( id >=0 && id < 3 ) fHistoSecProton[id]->Fill( plab, wt );
	 }
	 if ( pname == "anti_proton" )
	 {	   
	   if ( id >=0 && id < 3 ) fHistoSecAntiProton[id]->Fill( plab, wt );
	 }
	 if ( pname == "kaon+" )
	 {	   
	   if ( id >=0 && id < 3 ) fHistoSecKPlus[id]->Fill( plab, wt );
	 }
	 if ( pname == "kaon-" )
	 {	   
	   if ( id >=0 && id < 3 ) fHistoSecKMinus[id]->Fill( plab, wt );
	 }

      }

   }

   return;

}

TH1* artg4tk::AnalyzerSASM6E::matchExpSpectrum2MC( const int& secid, 
                                                 const std::vector<std::string>& cond,
						 const int& observable )
{

   std::string ptbin = extractPTBinFromTitle( cond[0] );
   
   if ( secid == 211 )
   {
      for ( size_t i=0; i<fHistoSecPiPlus.size(); ++i )
      {
         std::string htitle = fHistoSecPiPlus[i]->GetTitle();
	 if ( htitle == ptbin )
	 {
	    return fHistoSecPiPlus[i];
	 }
      }
   }
   else if ( secid == -211 )
   {
      for ( size_t i=0; i<fHistoSecPiMinus.size(); ++i )
      {
         std::string htitle = fHistoSecPiMinus[i]->GetTitle();
	 if ( htitle == ptbin )
	 {
	    return fHistoSecPiMinus[i];
	 }
      }
   }
   else if ( secid == 321 )
   {
      for ( size_t i=0; i<fHistoSecKPlus.size(); ++i )
      {
         std::string htitle = fHistoSecKPlus[i]->GetTitle();
	 if ( htitle == ptbin )
	 {
	    return fHistoSecKPlus[i];
	 }
      }
   }
   else if ( secid == -321)
   {
      for ( size_t i=0; i<fHistoSecKMinus.size(); ++i )
      {
         std::string htitle = fHistoSecKMinus[i]->GetTitle();
	 if ( htitle == ptbin )
	 {
	    return fHistoSecKMinus[i];
	 }
      }
   }
   else if ( secid == 2212 )
   {
      for ( size_t i=0; i<fHistoSecProton.size(); ++i )
      {
         std::string htitle = fHistoSecProton[i]->GetTitle();
	 if ( htitle == ptbin )
	 {
	    return fHistoSecProton[i];
	 }
      }
   }
   else if ( secid == -2212 )
   {
      for ( size_t i=0; i<fHistoSecAntiProton.size(); ++i )
      {
         std::string htitle = fHistoSecAntiProton[i]->GetTitle();
	 if ( htitle == ptbin )
	 {
	    return fHistoSecAntiProton[i];
	 }
      }
   }
   
   
   return NULL;

}

void artg4tk::AnalyzerSASM6E::calculateChi2()
{

   // this code is (almost) identical in all analyzers
   // need to consolidate somehow...
   
   
   art::ServiceHandle<art::TFileService> tfs;  
   std::vector<RecordChi2*> vrchi2;

   std::vector< std::pair<int,TH1*> >::iterator itr = fVDBRecID2MC.begin();
   
   std::string hname = itr->second->GetName();

   std::string secondary = hname.substr( 0, hname.find_first_of("_") );

   std::string tmpname = secondary + "_RecordChi2";
   std::string tmptitle = secondary + "-RecordChi2";
   // vrchi2.push_back( tfs->makeAndRegister<RecordChi2>( tmpname, tmptitle, RecordChi2() ) );
   vrchi2.push_back( tfs->make<RecordChi2>() );
   vrchi2.back()->SetName( tmpname.c_str() );
   vrchi2.back()->SetTitle( tmptitle.c_str() );
   gDirectory->Append( vrchi2.back() );
  
   std::map<int,double> chi2ind;
   std::vector< std::pair<std::string,double> >chi2integral;

   double chi2sum = 0.;
   int ndfsum = 0;

   for ( ; itr!=fVDBRecID2MC.end(); ++itr )
   {

      if ( !itr->second )
      {
         fLogInfo << " No matching MC histo for record = " << itr->first; // << std::endl;
	 continue; 
      }
      hname = itr->second->GetName();

      if ( hname.find( secondary ) == std::string::npos || hname.find( secondary ) != 0 ) // change of histo name
      {
         chi2integral.push_back( std::pair<std::string,double>( secondary, chi2sum/ndfsum ) );
	 chi2sum = 0.;
	 ndfsum = 0;
	 secondary = hname.substr( 0, hname.find_first_of("_") );
	 tmpname = secondary + "_RecordChi2";
         tmptitle = secondary + "-RecordChi2";
         vrchi2.push_back( tfs->make<RecordChi2>() );
         vrchi2.back()->SetName( tmpname.c_str() );
         vrchi2.back()->SetTitle( tmptitle.c_str() );
         gDirectory->Append( vrchi2.back() );
      }
            
      std::map<int,std::string>::iterator itrda = fJSONRecords.find( itr->first );
      TH1D* hda = 0;
      
      if ( itrda != fJSONRecords.end() ) 
      {
	 hda = fJSON2Data->Convert2Histo(itrda->second,"tmpdata");
      }
      if ( !hda ) continue;

      int ndf = 0;
      double chi2 = fChi2Calc->Chi2DataMC( hda, itr->second, ndf );
      chi2ind.insert( std::pair<int,double>( itr->first, chi2/ndf ) );
      vrchi2.back()->InsertRecord( itr->first, chi2, (double)ndf, 1. );
      std::vector< std::pair<int,double> > chi2mcbin = fChi2Calc->GetChi2MCBin();
      int nrec = vrchi2.back()->GetNRecords();
      for ( size_t ib=0; ib<chi2mcbin.size(); ++ib )
      {
         vrchi2.back()->AddMCBin2Record( nrec-1, chi2mcbin[ib].first, chi2mcbin[ib].second );
      }
      chi2sum += chi2;
      ndfsum += ndf; 

   }

   // last one
   //
   chi2integral.push_back( std::pair<std::string,double>( secondary, chi2sum/ndfsum ) );

   std::cout << " In directory: " << gDirectory->GetName() << std::endl;
   
   std::cout << " ===== chi2/ndf for individial distributions: " << std::endl; 
   std::map<int,double>::iterator i = chi2ind.begin();
   for ( ; i!=chi2ind.end(); ++i )
   {
      std::cout << " DoSSiER ID = " << i->first << " --> chi2/ndf = " << i->second << std::endl;
   }

   std::cout << " ===== Integral chi2/ndf: " << std::endl;
   for ( size_t ii=0; ii<chi2integral.size(); ++ii )
   {
      std::cout << " secondary = " << chi2integral[ii].first << 
                   " --> integral chi2/ndf = " << chi2integral[ii].second << std::endl;
   }

   return;

}

std::string artg4tk::AnalyzerSASM6E::extractPTBinFromTitle( const std::string& title )
{

   std::string ret = "";
   
   size_t pos = title.find("pt");
   ret = title.substr( pos );

   return ret;

}

double artg4tk::AnalyzerSASM6E::computeDPZ( double bc, double bw, int id )
{
   
   double pmin = bc - bw/2.;
   double pmax = bc + bw/2.;
   double ptmin = fBinsPt[id] - fDeltaPt/2.;
   double ptmax = fBinsPt[id] + fDeltaPt/2.;
   double pzmin = std::sqrt( pmin*pmin - ptmax*ptmax );
   double pzmax = std::sqrt( pmax*pmax - ptmin*ptmin );
   
   if ( ptmax > pmin || ptmin > pmax ) return 0.;
   
   double dpz = std::fabs( pzmax - pzmin );

   return dpz;

}


using artg4tk::AnalyzerSASM6E;
DEFINE_ART_MODULE(AnalyzerSASM6E)
