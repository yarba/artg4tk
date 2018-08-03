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

// #include "boost/math/special_functions/sign.hpp"

namespace artg4tk {

   class AnalyzerNA61 : public ModelParamAnalyzerBase {

   public:
   
      explicit AnalyzerNA61( const fhicl::ParameterSet& );
      virtual ~AnalyzerNA61();
      
      virtual void analyze( const art::Event& event ) override;
      virtual void beginJob()                         override;
      virtual void endJob()                           override;
   
   protected:

      virtual TH1* matchExpSpectrum2MC( const int&, const std::vector<std::string>&, const int& ); 
         
   private:
   
      // FIXME !!! 
      // This will be replaced by the use of parnames/parvalues !!!
      //
      std::vector<std::string> extractThetaBinFromTitle( const std::string& );
      
      void calculateChi2();
            
      double             fMaxMomentum;
      int                fNBinsTmp;
      
      // Number of secondaries; 
      // also, Integral() used for normalization
      //
      TH1D*              fHistoNSec; 
      
      std::vector<double> fThetaBinsProton;
      std::vector<double> fThetaBinsPion;
      std::vector<double> fThetaBinsKaonCh;
      std::vector<double> fThetaBinsK0s;
      std::vector<double> fThetaBinsLambda;

      // local/tmp histos (not in TFileService)
      //     
      std::vector<TH1D*> fHistoProton;
      std::vector<TH1D*> fHistoPiMinus;
      std::vector<TH1D*> fHistoPiPlus; 
      std::vector<TH1D*> fHistoKMinus;
      std::vector<TH1D*> fHistoKPlus;
      std::vector<TH1D*> fHistoK0s;
      std::vector<TH1D*> fHistoLambda;
      

      Chi2Calc*          fChi2Calc;
 
   };  

}

artg4tk::AnalyzerNA61::AnalyzerNA61( const fhicl::ParameterSet& p )
  : artg4tk::ModelParamAnalyzerBase(p),
    fChi2Calc(0)
{
        
   fMaxMomentum = p.get<double>("MaxMomentum",50.);
   fNBinsTmp = p.get<int>("NBinsTmp",5000);
   
   fHistoNSec = 0;
   
   fThetaBinsProton.push_back( 0. );
   fThetaBinsProton.push_back( 10. );
   fThetaBinsProton.push_back( 20. );
   fThetaBinsProton.push_back( 40. );
   fThetaBinsProton.push_back( 60. );
   fThetaBinsProton.push_back( 100. );
   fThetaBinsProton.push_back( 140. );
   fThetaBinsProton.push_back( 180. );
   fThetaBinsProton.push_back( 240. );
   fThetaBinsProton.push_back( 300. );
   fThetaBinsProton.push_back( 360. );
   
   fThetaBinsPion.push_back( 0. );
   fThetaBinsPion.push_back( 10. );
   fThetaBinsPion.push_back( 20. );
   fThetaBinsPion.push_back( 40. );
   fThetaBinsPion.push_back( 60. );
   fThetaBinsPion.push_back( 100. );
   fThetaBinsPion.push_back( 140. );
   fThetaBinsPion.push_back( 180. );
   fThetaBinsPion.push_back( 240. );
   fThetaBinsPion.push_back( 300. );
   fThetaBinsPion.push_back( 360. );
   fThetaBinsPion.push_back( 420. );

   fThetaBinsKaonCh.push_back( 0. );
   fThetaBinsKaonCh.push_back( 20. );
   fThetaBinsKaonCh.push_back( 40. );
   fThetaBinsKaonCh.push_back( 60. );
   fThetaBinsKaonCh.push_back( 100. );
   fThetaBinsKaonCh.push_back( 140. );
   fThetaBinsKaonCh.push_back( 180. );
   fThetaBinsKaonCh.push_back( 240. );
   fThetaBinsKaonCh.push_back( 300. );

   fThetaBinsK0s.push_back( 0. );
   fThetaBinsK0s.push_back( 40. );
   fThetaBinsK0s.push_back( 60. );
   fThetaBinsK0s.push_back( 100. );
   fThetaBinsK0s.push_back( 140. );
   fThetaBinsK0s.push_back( 180. );
   fThetaBinsK0s.push_back( 240. );
   fThetaBinsK0s.push_back( 300. );
   
   fThetaBinsLambda.push_back( 0. );
   fThetaBinsLambda.push_back( 40. );
   fThetaBinsLambda.push_back( 60. );
   fThetaBinsLambda.push_back( 100. );
   fThetaBinsLambda.push_back( 140. );
   fThetaBinsLambda.push_back( 180. );
   fThetaBinsLambda.push_back( 240. );
   fThetaBinsLambda.push_back( 300. );

   // except for fHistoNSec, instantiate tmp histos here
   //

   TH1::SetDefaultSumw2();

   for ( size_t i=0; i<fThetaBinsProton.size()-1; ++i )
   {
      std::ostringstream os1;
      os1 << fThetaBinsProton[i];
      std::ostringstream os2;
      os2 << fThetaBinsProton[i+1];
      std::string hname = "tmp_proton_" + os1.str() + "_" + os2.str();
      std::string htitle = os1.str() + "<theta<" + os2.str();
      fHistoProton.push_back( new TH1D( hname.c_str(), htitle.c_str(), fNBinsTmp, 0., fMaxMomentum ) );    
   }
   
   for ( size_t i=0; i<fThetaBinsPion.size()-1; ++i )
   {
      std::ostringstream os1;
      os1 << fThetaBinsPion[i];
      std::ostringstream os2;
      os2 << fThetaBinsPion[i+1];
      std::string hname = "tmp_piminus_" + os1.str() + "_" + os2.str();
      std::string htitle = os1.str() + "<theta<" + os2.str();
      fHistoPiMinus.push_back( new TH1D( hname.c_str(), htitle.c_str(), fNBinsTmp, 0., fMaxMomentum ) );
      hname = "tmp_piplus_" + os1.str() + "_" + os2.str();
      fHistoPiPlus.push_back( new TH1D( hname.c_str(), htitle.c_str(), fNBinsTmp, 0., fMaxMomentum ) );
   }

   for ( size_t i=0; i<fThetaBinsKaonCh.size()-1; ++i )
   {
      std::ostringstream os1;
      os1 << fThetaBinsKaonCh[i];
      std::ostringstream os2;
      os2 << fThetaBinsKaonCh[i+1];
      std::string hname = "tmp_kminus_" + os1.str() + "_" + os2.str();
      std::string htitle = os1.str() + "<theta<" + os2.str();
      fHistoKMinus.push_back( new TH1D( hname.c_str(), htitle.c_str(), fNBinsTmp, 0., fMaxMomentum ) );
      hname = "tmp_kplus_" + os1.str() + "_" + os2.str();
      fHistoKPlus.push_back( new TH1D( hname.c_str(), htitle.c_str(), fNBinsTmp, 0., fMaxMomentum ) );
   }

   for ( size_t i=0; i<fThetaBinsK0s.size()-1; ++i )
   {
      std::ostringstream os1;
      os1 << fThetaBinsK0s[i];
      std::ostringstream os2;
      os2 << fThetaBinsK0s[i+1];
      std::string hname = "tmp_k0s_" + os1.str() + "_" + os2.str();
      std::string htitle = os1.str() + "<theta<" + os2.str();
      fHistoK0s.push_back( new TH1D( hname.c_str(), htitle.c_str(), fNBinsTmp, 0., fMaxMomentum ) );
   }

   for ( size_t i=0; i<fThetaBinsLambda.size()-1; ++i )
   {
      std::ostringstream os1;
      os1 << fThetaBinsLambda[i];
      std::ostringstream os2;
      os2 << fThetaBinsLambda[i+1];
      std::string hname = "tmp_lambda_" + os1.str() + "_" + os2.str();
      std::string htitle = os1.str() + "<theta<" + os2.str();
      fHistoLambda.push_back( new TH1D( hname.c_str(), htitle.c_str(), fNBinsTmp, 0., fMaxMomentum ) );
   }

   if ( fIncludeExpData ) 
   {
      fChi2Calc = new Chi2Calc();
   }
}

artg4tk::AnalyzerNA61::~AnalyzerNA61()
{
   // do I need any histos delete's here ?!
   // or will TFileService take care of that ?!?!
   
   // delete local/tmp histos
   //
   for ( size_t i=0; i<fHistoProton.size(); ++i )
   {
      delete fHistoProton[i];
   }
   for ( size_t i=0; i<fHistoPiMinus.size(); ++i )
   {
      delete fHistoPiMinus[i];
   }
   for ( size_t i=0; i<fHistoPiPlus.size(); ++i )
   {
      delete fHistoPiPlus[i];
   }
   for ( size_t i=0; i<fHistoKMinus.size(); ++i )
   {
      delete fHistoKMinus[i];
   }
   for ( size_t i=0; i<fHistoKPlus.size(); ++i )
   {
      delete fHistoKPlus[i];
   }
   for ( size_t i=0; i<fHistoK0s.size(); ++i )
   {
      delete fHistoK0s[i];
   }
   for ( size_t i=0; i<fHistoLambda.size(); ++i )
   {
      delete fHistoLambda[i];
   }

   if ( fChi2Calc ) delete fChi2Calc;
      
}

void artg4tk::AnalyzerNA61::beginJob()
{

   TH1::SetDefaultSumw2();
      
   art::ServiceHandle<art::TFileService> tfs;
   fHistoNSec = tfs->make<TH1D>( "NSec", 
                                 "Number of secondary per inelastic interaction", 
				 100, 0., 100 );

   return;

}

void artg4tk::AnalyzerNA61::endJob()
{
      
   ModelParamAnalyzerBase::endJob();
   
   if ( !fXSecInit ) return;
   
   if ( fHistoNSec->GetEntries() <= 0 ) return;

   art::ServiceHandle<art::TFileService> tfs;  

   double stat = fHistoNSec->Integral();   
   fHistoNSec->Scale( (1./stat), "width" );

   TH1::SetDefaultSumw2();

   double scale = 1.;
   
   if ( fIncludeExpData )
   {
      
      scale = fXSecOnTarget / stat; // delta_theta is already taken into account in analyze(...)
      
      // the local/tmp histos scale with XSec and stat but NOT with bin width yet
      for ( size_t i=0; i<fHistoProton.size(); ++i )
      {
	 fHistoProton[i]->Scale( scale );
      }
      for ( size_t i=0; i<fHistoPiMinus.size(); ++i )
      {
	 fHistoPiMinus[i]->Scale( scale );
      }
      for ( size_t i=0; i<fHistoPiPlus.size(); ++i )
      {
	 fHistoPiPlus[i]->Scale( scale );
      }
      for ( size_t i=0; i<fHistoKMinus.size(); ++i )
      {
	 fHistoKMinus[i]->Scale( scale );
      }
      for ( size_t i=0; i<fHistoKPlus.size(); ++i )
      {
	 fHistoKPlus[i]->Scale( scale );
      }
      for ( size_t i=0; i<fHistoK0s.size(); ++i )
      {
	 fHistoK0s[i]->Scale( scale );
      }
      for ( size_t i=0; i<fHistoLambda.size(); ++i )
      {
	 fHistoLambda[i]->Scale( scale );
      }

      // now match to exp.data
      bool ok = matchVDBRec2MC( fBTConf.GetBeamPartID(),
                                fBTConf.GetBeamMomentum(),
				fBTConf.GetTargetID() );
      if ( !ok )
      {
         fLogInfo << " ExpData do NOT match any of the MC; NO bechmarking; bail out" ;
	 return;
      }
      
      // now find and mark unmatched MC histos (if any)
      // create copies to be written to the Root output file

      std::vector< std::pair<int,TH1*> >::iterator itr;
      size_t ih = 0;
      
      for ( ; ih<fHistoProton.size(); ++ih )
      {
         for ( itr=fVDBRecID2MC.begin(); itr!=fVDBRecID2MC.end(); ++itr )
	 {
	    if ( fHistoProton[ih] == itr->second ) break;
	 }
	 if ( itr == fVDBRecID2MC.end() ) 
	 {
	    // unmatched histo
	    TH1D* h1 = copyHisto2TFS( fHistoProton[ih], "tmp_" );
	    h1->Scale( 1., "width" );
	 }
      }
      ih = 0; 
      for ( ; ih<fHistoPiMinus.size(); ++ih )
      {
         for ( itr=fVDBRecID2MC.begin(); itr!=fVDBRecID2MC.end(); ++itr )
	 {
	    if ( fHistoPiMinus[ih] == itr->second ) break;
	 }
	 if ( itr == fVDBRecID2MC.end() ) 
	 {
	    // unmatched histo
	    TH1D* h1 = copyHisto2TFS( fHistoPiMinus[ih], "tmp_" );
	    h1->Scale( 1., "width" );
	 }
      }
      ih = 0; 
      for ( ; ih<fHistoPiPlus.size(); ++ih )
      {
         for ( itr=fVDBRecID2MC.begin(); itr!=fVDBRecID2MC.end(); ++itr )
	 {
	    if ( fHistoPiPlus[ih] == itr->second ) break;
	 }
	 if ( itr == fVDBRecID2MC.end() ) 
	 {
	    // unmatched histo
	    TH1D* h1 = copyHisto2TFS( fHistoPiPlus[ih], "tmp_" );
	    h1->Scale( 1., "width" );
	 }
      }
      ih = 0; 
      for ( ; ih<fHistoKMinus.size(); ++ih )
      {
         for ( itr=fVDBRecID2MC.begin(); itr!=fVDBRecID2MC.end(); ++itr )
	 {
	    if ( fHistoKMinus[ih] == itr->second ) break;
	 }
	 if ( itr == fVDBRecID2MC.end() ) 
	 {
	    // unmatched histo
	    TH1D* h1 = copyHisto2TFS( fHistoKMinus[ih], "tmp_" );
	    h1->Scale( 1., "width" );
	 }
      }
      ih = 0; 
      for ( ; ih<fHistoKPlus.size(); ++ih )
      {
         for ( itr=fVDBRecID2MC.begin(); itr!=fVDBRecID2MC.end(); ++itr )
	 {
	    if ( fHistoKPlus[ih] == itr->second ) break;
	 }
	 if ( itr == fVDBRecID2MC.end() ) 
	 {
	    // unmatched histo
	    TH1D* h1 = copyHisto2TFS( fHistoKPlus[ih], "tmp_" );
	    h1->Scale( 1., "width" );
	 }
      }
      ih = 0; 
      for ( ; ih<fHistoK0s.size(); ++ih )
      {
         for ( itr=fVDBRecID2MC.begin(); itr!=fVDBRecID2MC.end(); ++itr )
	 {
	    if ( fHistoK0s[ih] == itr->second ) break;
	 }
	 if ( itr == fVDBRecID2MC.end() ) 
	 {
	    // unmatched histo
	    TH1D* h1 = copyHisto2TFS( fHistoK0s[ih], "tmp_" );
	    h1->Scale( 1., "width" );
	 }
      }
      ih = 0; 
      for ( ; ih<fHistoLambda.size(); ++ih )
      {
         for ( itr=fVDBRecID2MC.begin(); itr!=fVDBRecID2MC.end(); ++itr )
	 {
	    if ( fHistoLambda[ih] == itr->second ) break;
	 }
	 if ( itr == fVDBRecID2MC.end() ) 
	 {
	    // unmatched histo
	    TH1D* h1 = copyHisto2TFS( fHistoLambda[ih], "tmp_" );
	    h1->Scale( 1., "width" );
	 }
      }

      // now those MC's that are matched to exp.data
      //
      rebinMC2Data( "tmp_" );
      
      // and finally scale each histo to the momentum bin size
      // NOTE: scaling to XSec, stat, and theta-bin is done earlier
      //
      for ( itr=fVDBRecID2MC.begin(); itr!=fVDBRecID2MC.end(); ++itr )
      {
         (itr->second)->Scale( 1., "width" );
      }

      // ---> FIXME !!! Add this later !!!   calculateChi2();
      overlayDataMC();
      Store4Professor( "NA61" );

   }
   else
   {

      scale = fXSecOnTarget / stat; // delta_theta is already taken into account in analyze(...)

      // no matching vs data
      for ( size_t i=0; i<fHistoProton.size(); ++i )
      {
         TH1D* h = copyHisto2TFS( fHistoProton[i], "tmp_" );
	 h->Scale( scale, "width" );
      }
      for ( size_t i=0; i<fHistoPiMinus.size(); ++i )
      {
         TH1D* h = copyHisto2TFS( fHistoPiMinus[i], "tmp_" );
	 h->Scale( scale, "width" );
      }
      for ( size_t i=0; i<fHistoPiPlus.size(); ++i )
      {
         TH1D* h = copyHisto2TFS( fHistoPiPlus[i], "tmp_" );
	 h->Scale( scale, "width" );
      }
      for ( size_t i=0; i<fHistoKMinus.size(); ++i )
      {
         TH1D* h = copyHisto2TFS( fHistoKMinus[i], "tmp_" );
	 h->Scale( scale, "width" );
      }
      for ( size_t i=0; i<fHistoKPlus.size(); ++i )
      {
         TH1D* h = copyHisto2TFS( fHistoKPlus[i], "tmp_" );
	 h->Scale( scale, "width" );
      }
      for ( size_t i=0; i<fHistoK0s.size(); ++i )
      {
         TH1D* h = copyHisto2TFS( fHistoK0s[i], "tmp_" );
	 h->Scale( scale, "width" );
      }
      for ( size_t i=0; i<fHistoLambda.size(); ++i )
      {
         TH1D* h = copyHisto2TFS( fHistoLambda[i], "tmp_" );
	 h->Scale( scale, "width" );
      }
   }

   return;

}

void artg4tk::AnalyzerNA61::analyze( const art::Event& e )
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

   for ( int ip=0; ip<nsec; ++ip )
   {

      const ArtG4tkParticle& sec = firstint->GetOutcoming( ip );
      
      std::string pname = sec.GetName();
      
      double pmom = sec.GetMomentum().vect().mag();      
      pmom /= CLHEP::GeV;
      double theta = sec.GetMomentum().vect().theta();
      theta /= CLHEP::mrad;
      
      if ( pname == "proton" )
      {
	 for ( size_t i=0; i<fThetaBinsProton.size()-1; ++i )
	 {
	    if ( theta >= fThetaBinsProton[i] && theta < fThetaBinsProton[i+1] )
	    {
	       double dthe = fThetaBinsProton[i+1] - fThetaBinsProton[i];
	       dthe *= CLHEP::mrad;
	       fHistoProton[i]->Fill( pmom, 1./dthe );
	       break;
	    }
	 }
      }
      else if ( pname == "pi-" )
      {
	 for ( size_t i=0; i<fThetaBinsPion.size()-1; ++i )
	 {
	    if ( theta >= fThetaBinsPion[i] && theta < fThetaBinsPion[i+1] )
	    {
	       double dthe = fThetaBinsPion[i+1] - fThetaBinsPion[i];
	       dthe *= CLHEP::mrad;
	       fHistoPiMinus[i]->Fill( pmom, 1./dthe );
	       break;
	    }
	 }
      }
      else if ( pname == "pi+" )
      {
	 for ( size_t i=0; i<fThetaBinsPion.size()-1; ++i )
	 {
	    if ( theta >= fThetaBinsPion[i] && theta < fThetaBinsPion[i+1] )
	    {
	       double dthe = fThetaBinsPion[i+1] - fThetaBinsPion[i];
	       dthe *= CLHEP::mrad;
	       fHistoPiPlus[i]->Fill( pmom, 1./dthe );
	       break;
	    }
	 }
      }
      else if ( pname == "kaon-" )
      {
	 for ( size_t i=0; i<fThetaBinsKaonCh.size()-1; ++i )
	 {
	    if ( theta >= fThetaBinsKaonCh[i] && theta < fThetaBinsKaonCh[i+1] )
	    {
	       double dthe = fThetaBinsKaonCh[i+1] - fThetaBinsKaonCh[i];
	       dthe *= CLHEP::mrad;
	       fHistoKMinus[i]->Fill( pmom, 1./dthe );
	       break;
	    }
	 }
      }
      else if ( pname == "kaon+" )
      {
	 for ( size_t i=0; i<fThetaBinsKaonCh.size()-1; ++i )
	 {
	    if ( theta >= fThetaBinsKaonCh[i] && theta < fThetaBinsKaonCh[i+1] )
	    {
	       double dthe = fThetaBinsKaonCh[i+1] - fThetaBinsKaonCh[i];
	       dthe *= CLHEP::mrad;
	       fHistoKPlus[i]->Fill( pmom, 1./dthe );
	       break;
	    }
	 }
      }
      else if ( pname == "kaon0S" )
      {
	 for ( size_t i=0; i<fThetaBinsK0s.size()-1; ++i )
	 {
	    if ( theta >= fThetaBinsK0s[i] && theta < fThetaBinsK0s[i+1] )
	    {
	       double dthe = fThetaBinsK0s[i+1] - fThetaBinsK0s[i];
	       dthe *= CLHEP::mrad;
	       fHistoK0s[i]->Fill( pmom, 1./dthe );
	       break;
	    }
	 }
      }
      else if ( pname == "lambda" )
      {
	 for ( size_t i=0; i<fThetaBinsLambda.size()-1; ++i )
	 {
	    if ( theta >= fThetaBinsLambda[i] && theta < fThetaBinsLambda[i+1] )
	    {
	       double dthe = fThetaBinsLambda[i+1] - fThetaBinsLambda[i];
	       dthe *= CLHEP::mrad;
	       fHistoLambda[i]->Fill( pmom, 1./dthe );
	       break;
	    }
	 }
      }
            
   }

   return;

}

TH1* artg4tk::AnalyzerNA61::matchExpSpectrum2MC( const int& secid, 
                                                 const std::vector<std::string>& input,
						 const int& /* observable */ )
{

   // FIXME !!!
   // This will be redone once parnames/parvalues are finished !
   //
   std::vector<std::string> cond = extractThetaBinFromTitle( input[0] );

   if ( secid == 2212 ) // proton
   {
      for ( size_t i=0; i<fHistoProton.size(); ++i )
      {
         std::string htitle = fHistoProton[i]->GetTitle();
	 bool match = true;
	 for ( size_t j=0; j<cond.size(); ++j )
	 {
	    if ( htitle.find( cond[j] ) == std::string::npos )
	    {
	       match = false;
	       break;
	    }
	 }
	 if ( match )
	 {
	    return fHistoProton[i];
	 }	 
      }
   }
   else if ( secid == -211 ) // pi-
   {
      for ( size_t i=0; i<fHistoPiMinus.size(); ++i )
      {
         std::string htitle = fHistoPiMinus[i]->GetTitle();
	 bool match = true;
	 for ( size_t j=0; j<cond.size(); ++j )
	 {
	    if ( htitle.find( cond[j] ) == std::string::npos )
	    {
	       match = false;
	       break;
	    }
	 }
	 if ( match )
	 {
	    return fHistoPiMinus[i];
	 }	 
      }
   }
   else if ( secid == 211 ) // pi+
   {
      for ( size_t i=0; i<fHistoPiPlus.size(); ++i )
      {
         std::string htitle = fHistoPiPlus[i]->GetTitle();
	 bool match = true;
	 for ( size_t j=0; j<cond.size(); ++j )
	 {
	    if ( htitle.find( cond[j] ) == std::string::npos )
	    {
	       match = false;
	       break;
	    }
	 }
	 if ( match )
	 {
	    return fHistoPiPlus[i];
	 }	 
      }
   }
   else if ( secid == -321 ) // K-
   {
      for ( size_t i=0; i<fHistoKMinus.size(); ++i )
      {
         std::string htitle = fHistoKMinus[i]->GetTitle();
	 bool match = true;
	 for ( size_t j=0; j<cond.size(); ++j )
	 {
	    if ( htitle.find( cond[j] ) == std::string::npos )
	    {
	       match = false;
	       break;
	    }
	 }
	 if ( match )
	 {
	    return fHistoKMinus[i];
	 }	 
      }
   }
   else if ( secid == 321 ) // K+
   {
      for ( size_t i=0; i<fHistoKPlus.size(); ++i )
      {
         std::string htitle = fHistoKPlus[i]->GetTitle();
	 bool match = true;
	 for ( size_t j=0; j<cond.size(); ++j )
	 {
	    if ( htitle.find( cond[j] ) == std::string::npos )
	    {
	       match = false;
	       break;
	    }
	 }
	 if ( match )
	 {
	    return fHistoKPlus[i];
	 }	 
      }
   }
   else if ( secid == 310 ) // K0s
   {
      for ( size_t i=0; i<fHistoK0s.size(); ++i )
      {
         std::string htitle = fHistoK0s[i]->GetTitle();
	 bool match = true;
	 for ( size_t j=0; j<cond.size(); ++j )
	 {
	    if ( htitle.find( cond[j] ) == std::string::npos )
	    {
	       match = false;
	       break;
	    }
	 }
	 if ( match )
	 {
	    return fHistoK0s[i];
	 }	 
      }
   }
   else if ( secid == 3122 ) // Lambda
   {
      for ( size_t i=0; i<fHistoLambda.size(); ++i )
      {
         std::string htitle = fHistoLambda[i]->GetTitle();
	 bool match = true;
	 for ( size_t j=0; j<cond.size(); ++j )
	 {
	    if ( htitle.find( cond[j] ) == std::string::npos )
	    {
	       match = false;
	       break;
	    }
	 }
	 if ( match )
	 {
	    return fHistoLambda[i];
	 }	 
      }
   }

   return NULL;

}

std::vector<std::string> artg4tk::AnalyzerNA61::extractThetaBinFromTitle( const std::string& title )
{

   size_t pos1 = title.find("<theta<");
   size_t pos2 = title.find_last_of( " ", pos1 );
   std::string th1 = title.substr( pos2+1, pos1-pos2-1 );

   pos2 = title.find_first_of( " ", pos1 );
   std::string tmp = title.substr( pos1, pos2-pos1 );
   pos2 = tmp.find_last_of("<");
   std::string th2 = tmp.substr(pos2+1);

   std::vector<std::string> ret;
   ret.push_back( th1 );
   ret.push_back( th2 );
   
   return ret;

}

void artg4tk::AnalyzerNA61::calculateChi2()
{

   return;

}

using artg4tk::AnalyzerNA61;
DEFINE_ART_MODULE(AnalyzerNA61)




