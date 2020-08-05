#include <iostream>
#include <iomanip>
#include <string>
#include <fstream>
#include <vector>
using namespace std;

#include <cstdio>  // sprintf

#include "TObject.h"
#include "TRandom3.h"

// forward declaration
std::string makeUniqueLabel(std::string baseLabel, size_t i);

//-----------------------------------------------------------------------
class ModelParam {
public:
  ModelParam() { } // need default constructor
  ModelParam(std::string name, std::string model, double vmin, double vmax)
    : fname(name), fmodel(model), fvmin(vmin), fvmax(vmax),
      fdistrib("flat"), fdv1(0), fdv2(0), fenabled(false) { ; }
  std::string   GetName()        const { return fname; }
  std::string   GetModel()       const { return fmodel; }
  double        GetVMin()        const { return fvmin; }
  double        GetVMax()        const { return fvmax; }
  std::string   GetDistrib()     const { return fdistrib; }
  double        GetValue()       const { return fvalue; }
  bool          IsEnabled()      const { return fenabled; }
  bool          IsFixed()        const { return ffixed; }
  ModelParam&   SetDistrib(std::string dname, double v1, double v2);
  ModelParam&   SetEnabled(bool enable=true);
  ModelParam&   SetFixed(bool fix=true);
  ModelParam&   SetRandomValue();
  ModelParam&   SetStepValue(int i, int n);
  std::ostream& WriteConfig(std::ostream& s);
private:
  std::string   fname;      // parameter name
  std::string   fmodel;     // physic model associated with
  double        fvmin;      // min allowed value
  double        fvmax;      // max allowed value
  std::string   fdistrib;   // for now only "flat","binary" distributions
                            // "step" for non-random
  double        fdv1, fdv2; // parameters for distributions (guass, etc)
  double        fvalue;     // chosen value
  bool          fenabled;   // enabled ?
  bool          ffixed;     // value maybe different from default but it's fixed
};
ModelParam& ModelParam::SetDistrib(std::string dname, double v1, double v2)
{
  fdistrib = dname;
  fdv1     = v1;
  fdv2     = v2;
  fenabled = true;
  if ( dname != "flat"   &&
       dname != "binary" &&
       dname != "step"      ) {
    std::cerr << "Sorry, ModelParam::SetDistrib only supports 'flat' "
              << "'binary' & 'step' at the current time"
              << std::endl;
    fenabled = false;
  }
  return *this;
}
ModelParam& ModelParam::SetEnabled(bool enable) {
  fenabled = enable;
  return *this;
}
ModelParam& ModelParam::SetFixed(bool fix) {
  ffixed = fix;
  return *this;
}
ModelParam& ModelParam::SetRandomValue()
{
  if ( fdistrib == "flat") {
    fvalue = gRandom->Uniform(fvmin,fvmax);
  } else if ( fdistrib == "binary" ) {
    fvalue = ( (gRandom->Uniform(0,1)<0.5) ? 0 : 1 );
  } else {
    std::cerr << "Sorry, ModelParam::GetRandomValue only supports 'flat' "
              << "and 'binary' at the current time"
              << std::endl << "   unhandled '" << fdistrib << "' distribution "
              << "treated as 'flat'"
              << std::endl;
    fvalue = gRandom->Uniform(fvmin,fvmax);
  }
  return *this;
}
ModelParam& ModelParam::SetStepValue(int i, int n)
{
  // want frac to be [0:1] for i=0...(n-1)
  double frac = (double)(i)/(double)(n-1);
  fvalue = fvmin + (fvmax-fvmin)*frac;
  return *this;
}
std::ostream& ModelParam::WriteConfig(std::ostream& s)
{
  s << "#  " << std::setw(10) << fmodel << "  "
    << std::setw(20) << fname << " "
    << std::setw(12) << fvmin << " "
    << std::setw(12) << fvmax << " "
    << std::setw(10) << fdistrib;
  if ( fdistrib != "flat" && fdistrib != "binary" ) {
    s << " (params " << fdv1 << "," << fdv2 << ")";
  }
  s << std::endl;
  return s;
}

/*
//// artg4tk/G4PhysModelParamStudy/G4Components/ModelConfigMapper.cc

//// Bertini
RadiusScaleByRatio    <ratio>
RadiusScale           <value>
XSecScaleByRatio      <ratio>
XSecScale             <value>
FermiScaleByRatio     <ratio>
FermiScale            <value>
TrailingRadiusByRatio <ratio>
TrailingRadius        <value>
GammaQDScaleByRatio   <ratio>
GammaQDScale          <value>

UsePreCompound   0/1
DoCoalescence    0/1

 // running the ModelConfigMapper tells me that
 ***** Default settings for Geant4 model bertini
 * /process/had/cascade/alphaRadiusScale 0.7
 * /process/had/cascade/cluster2DPmax 0.09
 * /process/had/cascade/cluster3DPmax 0.108
 * /process/had/cascade/cluster4DPmax 0.115
 * /process/had/cascade/crossSectionScale 1
 * /process/had/cascade/doCoalescence 1
 * /process/had/cascade/fermiScale 0.685187
 * /process/had/cascade/gammaQuasiDeutScale 1
 * /process/had/cascade/nuclearRadiusScale 2.81967
 * /process/had/cascade/piNAbsorption 0
 * /process/had/cascade/shadowningRadius 0
 * /process/had/cascade/smallNucleusRadius 2.83721
 * /process/had/cascade/use3BodyMom 0
 * /process/had/cascade/usePhaseSpace 0
 * /process/had/cascade/usePreCompound 0
 * /process/had/cascade/useTwoParamNuclearRadius 0
 * /process/had/cascade/verbose 0

Julia suggests:
    RadiusScale     1.0 - 3.5
    XSecScale       0.1 - 2.0
    FermiScale      0.5 - 1.0
    TrailingRadius  0.0 - 5.0

*/

// here's a choice of Bertini model parameters with "sensible" ranges

ModelParam    bertiniRadiusScale("RadiusScale",   "Bertini", 1.0, 3.5 );
ModelParam      bertiniXSecScale("XSecScale",     "Bertini", 0.1, 3.0 );
ModelParam     bertiniFermiScale("FermiScale",    "Bertini", 0.5, 1.0 );
ModelParam bertiniTrailingRadius("TrailingRadius","Bertini", 0.0, 5.0 );

// ** FTF parameters **
//
// ** selected FTF parameters of nuclear destruction for pion/meson **
//
ModelParam  ftfMesonNucDestrP1Tgt( "MESON_NUCDESTR_P1_TGT", "FTFP", 0., 0.01 );
ModelParam  ftfMesonNucDestrP1TgtADEP( "USE_MESON_NUCDESTR_P1_ADEP_TGT", "FTFP", 1, 1 );
//
ModelParam  ftfMesonNucDestrP2Tgt( "MESON_NUCDESTR_P2_TGT", "FTFP", 2., 16. );
ModelParam  ftfMesonNucDestrP3Tgt( "MESON_NUCDESTR_P3_TGT", "FTFP", 0., 4. );
//
ModelParam  ftfMesonPtNucDestrP1( "MESON_PT2_NUCDESTR_P1", "FTFP", 0., 0.25 );
ModelParam  ftfMesonPtNucDestrP2( "MESON_PT2_NUCDESTR_P2", "FTFP", 0., 0.25 );
//
// skip PT2's P3 and P4
//
// R2 is a bit tricky since it's in the units of (CLHEP::fermi)**2
// where fermi = 1.e-15*meter, meter=1000.*millimeter, and millimiter=1
// so it should be on the order of 1.e-30 * 1.e6 = 1.e-24 (mm)
// Default is 1.5*(CLHEP::fermi)**2 = 1.5e-24
//
// --> remove this one for now --> ModelParam  ftfMesonNucDestrR2( "MESON_NUCDESTR_R2", "FTFP", 0.5e-24, 2.0e-24 ); 
//
// EXCI_E is in the units of CLHEP::MeV which is set to 1. in the CLHEP/Units
//
ModelParam  ftfMesonExciEWndNucln( "MESON_EXCI_E_PER_WNDNUCLN", "FTFP", 0., 100. );

// ** selected FTF parameters of nuclear destruction for baryon/proton **
//
ModelParam  ftfBaryonNucDestrP1Tgt( "BARYON_NUCDESTR_P1_TGT", "FTFP", 0., 0.01 );
ModelParam  ftfBaryonNucDestrP1TgtADEP( "USE_BARYON_NUCDESTR_P1_ADEP_TGT", "FTFP", 1, 1 );
//
ModelParam  ftfBaryonNucDestrP2Tgt( "BARYON_NUCDESTR_P2_TGT", "FTFP", 2., 16. );
ModelParam  ftfBaryonNucDestrP3Tgt( "BARYON_NUCDESTR_P3_TGT", "FTFP", 0., 4. );
//
ModelParam  ftfBaryonPtNucDestrP1( "BARYON_PT2_NUCDESTR_P1", "FTFP", 0., 0.25 );
ModelParam  ftfBaryonPtNucDestrP2( "BARYON_PT2_NUCDESTR_P2", "FTFP", 0., 0.25 );
//
// skip PT2's P3 and P4
//
// EXCI_E is in the units of CLHEP::MeV which is set to 1. in the CLHEP/Units
//
ModelParam  ftfBaryonExciEWndNucln( "BARYON_EXCI_E_PER_WNDNUCLN", "FTFP", 0., 100. );

// ** selected FTF parameters of quarck exchange w/o or with exitation, for baryon/proton **
//
ModelParam  ftfBaryonProc0A1( "BARYON_PROC0_A1", "FTFP", -20., 20. );
ModelParam  ftfBaryonProc0B1( "BARYON_PROC0_B1", "FTFP",   0., 5. );
ModelParam  ftfBaryonProc0A2( "BARYON_PROC0_A2", "FTFP", -50., 50. );
ModelParam  ftfBaryonProc0B2( "BARYON_PROC0_B1", "FTFP",   0.,  5. );
ModelParam  ftfBaryonProc1A1( "BARYON_PROC1_A1", "FTFP", -40., 40. );
ModelParam  ftfBaryonProc1B1( "BARYON_PROC1_B1", "FTFP",   0.,  5. );
ModelParam  ftfBaryonProc1A2( "BARYON_PROC1_A2", "FTFP",-100.,100. );
ModelParam  ftfBaryonProc1B2( "BARYON_PROC1_B1", "FTFP",   0.,  5. );

ModelParam blah("xyz","no-such-hadron-model", 0.0, 999.9 );

//-----------------------------------------------------------------------
class UnivGenerator {
public:
  UnivGenerator(std::string model = "Bertini")
    : fmodel(model) { }
  // ModelParam's that are Add()'ed aren't owned by the UnivGenerator
  void          Add(ModelParam* mp);
  std::ostream& WriteConfigRangeInfo(std::ostream& s);

  std::ostream& WriteNewUniverse(std::ostream& s, std::string label,
                                 bool isProcLevel=true);

  std::ostream& WriteRandomUniverses(std::ostream& s, size_t nuniv,
                                     bool isProcLevel=true);

  std::ostream& WriteScanUniverses(std::ostream& s, size_t nuniv,
                                   bool isProcLevel=true);

  /*
  std::ostream& WriteGridUniverses(std::ostream& s, size_t nuniv,
                                   bool isProcLevel=true);
  */


private:


  std::string              fmodel; // model (cross check)
  std::vector<ModelParam*> fvparams;
};
void UnivGenerator::Add(ModelParam* mp)
{
  if ( mp->GetModel() != fmodel ) {
    std::cerr << "Sorry, can't add a ModelParam [" << mp->GetName()
              << "," << mp->GetModel() << "]"
              << std::endl
              << "           to a UnivGenerator [" << fmodel << "]"
              << std::endl;
    return;
  }
  fvparams.push_back(mp);
}
std::ostream& UnivGenerator::WriteConfigRangeInfo(std::ostream& s)
{
  size_t nparams = fvparams.size();
  s << std::endl;
  if ( nparams == 0 ) {
    s << "# config for default " << fmodel << " universe" << std::endl;
  } else {
    s << "# parameters for block of " << fmodel << " universes" << std::endl;
    for (size_t i=0; i<nparams; ++i) {
      ModelParam* mp = fvparams[i];
      mp->WriteConfig(s);
    }
  }
  return s;
}
std::ostream& UnivGenerator::WriteNewUniverse(std::ostream& s,
                                              std::string label,
                                              bool isProcLevel)
{
  s << std::endl;

  if ( isProcLevel ) {
    size_t nparams = fvparams.size();

    s << fmodel << label << " : { " << std::endl
      << "    module_type:  ProcLevelMPVaryProducer " << std::endl
      << "    errorOnFailureToPut: false " << std::endl
      << "    Verbosity: 0" << std::endl
      << "    HadronicModel: {" << std::endl
      << "        DefaultPhysics: "
      << ((nparams==0)?"true":"false") << std::endl
      << "        ModelParameters: {" << std::endl;
    for (size_t i=0; i<nparams; ++i) {
      ModelParam* mp = fvparams[i];
      if ( ! mp->IsEnabled() ) continue;
      s << "            " << std::setiosflags(std::ios_base::left)
        << std::setw(20)
        << mp->GetName()  << std::resetiosflags(std::ios_base::left) << " : "
        << mp->GetValue() << std::endl;
    }
    s << "        } # end-of-ModelParameters" << std::endl
      << "    } # end-of-HadronicModel" << std::endl
      << "} # end-of-" << fmodel << label << std::endl;

  } else {
    // not isProcLevel
    std::cerr << "Sorry, UnivGenerator::WriteNewUniverse currently only "
              << "knows about ProcLevel configs" << std::endl;
    s << "# Sorry, UnivGenerator::WriteNewUniverse currently only " << std::endl
      << "# knows about ProcLevel configs " << std::endl
      << "#    skip " << fmodel << label << std::endl;

  }
  return s;
}

std::ostream& UnivGenerator::WriteRandomUniverses(std::ostream& s,
                                                  size_t nuniv,
                                                  bool isProcLevel)
{
  std::string baseLabel = "RandomUniv";
  std::string uniqLabel;
  for (size_t iu=1; iu<(nuniv+1); ++iu) {
    uniqLabel = makeUniqueLabel(baseLabel,iu);
    std::cout << "generate " << fmodel << uniqLabel << "\r" << std::flush;

    size_t nparams = fvparams.size();
    for (size_t i=0; i<nparams; ++i) {
      ModelParam* mp = fvparams[i];
      if ( ! mp->IsEnabled() ) {
        cout << "mp " << mp->GetName() << " not enabled "
             << "dist " << mp->GetDistrib() << endl;
        continue;
      }
      mp->SetRandomValue();
    }

    WriteNewUniverse(s,uniqLabel,isProcLevel);
  }
  return s;
}

std::ostream& UnivGenerator::WriteScanUniverses(std::ostream& s,
                                                size_t nuniv,
                                                bool isProcLevel)
{
  std::string basebaseLabel = "StepUniv";
  std::string baseLabel;
  std::string uniqLabel;
  ModelParam* mp;
  size_t nparams = fvparams.size();

  // loop over each parameter ... scan over it's range w/ "nuniv" settings
  for (size_t iparam=0; iparam<nparams; ++iparam) {

    // turn everything off
    for (size_t j=0; j<nparams; ++j) {
      mp = fvparams[j];
      mp->SetEnabled(false);
    }
    // turn on only this parameter as we scan over it
    mp = fvparams[iparam]; // this is what we're scanning over
    mp->SetEnabled(true);
    baseLabel = mp->GetName() + basebaseLabel;
    /*
    std::cout << " ...." << fmodel << " ... " << iparam << " pname=\""
              << mp->GetName() << "\" baseLabel=\"" << baseLabel << std::endl;
    */

    for (size_t iu=0; iu<nuniv; ++iu) {
      uniqLabel = makeUniqueLabel(baseLabel,iu);
      std::cout << "generate " << fmodel << uniqLabel << "\r" << std::flush;
      mp->SetStepValue(iu,nuniv);
      WriteNewUniverse(s,uniqLabel,isProcLevel);
    }
    std::cout << std::endl;
  }
  return s;
}


//-----------------------------------------------------------------------
// helper function
std::string makeUniqueLabel(std::string baseLabel, size_t i)
{
  char buffer[100];
  // 1 .. 9999 possible universes
  sprintf(buffer,"%04ld",i);
  std::string outLabel = baseLabel;
  outLabel += std::string(buffer);
  return outLabel;
}

//-----------------------------------------------------------------------
// main routine
//-----------------------------------------------------------------------
void generate_universes(std::string basename = "paramstep",  // output file basename
                        signed long int nunivIn = -100,  // # of universes to gen
                                                   // beyond the default
                        // +N = random, -N = steps each param
                        std::string hadronModel = "Bertini",
                        bool isProcLevel = true,
                        int seed = 0)                  //
{

  gRandom = new TRandom3(seed);

  std::string filename = basename;   // eg. multiverse170208
  filename += "_";
  filename += hadronModel;
  filename += ".fcl";

  // start file, BEGIN_PROLOG
  std::ofstream fclfile(filename.c_str());
  fclfile << "BEGIN_PROLOG" << std::endl;

  // begin with a default universe
  std::cout << "generate " << hadronModel << "Default" << std::endl;
  UnivGenerator defaultUniv(hadronModel);

  defaultUniv.WriteConfigRangeInfo(fclfile);
  defaultUniv.WriteNewUniverse(fclfile,"Default",isProcLevel);

  UnivGenerator multiUniv(hadronModel);

  if ( hadronModel == "Bertini" ) {
    // now some multi-verse ones
    bertiniRadiusScale.SetEnabled(true);
    multiUniv.Add(&bertiniRadiusScale);

    bertiniXSecScale.SetEnabled(true);
    multiUniv.Add(&bertiniXSecScale);

    bertiniFermiScale.SetEnabled(true);
    multiUniv.Add(&bertiniFermiScale);

    bertiniTrailingRadius.SetEnabled(true);
    multiUniv.Add(&bertiniTrailingRadius);
  }
  else if ( hadronModel == "FTFP" )
  {
/*
     ftfMesonNucDestrP1Tgt.SetEnabled(true); 
     multiUniv.Add( &ftfMesonNucDestrP1Tgt );
     ftfMesonNucDestrP1TgtADEP.SetEnabled(true);  
     multiUniv.Add( &ftfMesonNucDestrP1TgtADEP ); 
     ftfMesonNucDestrP2Tgt.SetEnabled(true);
     multiUniv.Add( &ftfMesonNucDestrP2Tgt ); // ( "MESON_NUCDESTR_P2_TGT", "FTFP", 2., 16. );
     ftfMesonNucDestrP3Tgt.SetEnabled(true);     
     multiUniv.Add( &ftfMesonNucDestrP3Tgt ); // ( "MESON_NUCDESTR_P3_TGT", "FTFP", 0., 4. );
     ftfMesonPtNucDestrP1.SetEnabled(true); 
     multiUniv.Add( &ftfMesonPtNucDestrP1 );
     ftfMesonPtNucDestrP2.SetEnabled(true); 
     multiUniv.Add( &ftfMesonPtNucDestrP2 );
// --> remove for now -->     ftfMesonNucDestrR2.SetEnabled(true); // ( "MESON_NUCDESTR_R2", "FTFP", 0.5e-24, 2.0e-24 );
// --> remove for now -->     multiUniv.Add( &ftfMesonNucDestrR2 ); 
     ftfMesonExciEWndNucln.SetEnabled(true); // ( "MESON_EXCI_E_PER_WNDNUCLN", "FTFP", 0., 100. );
     multiUniv.Add( &ftfMesonExciEWndNucln );
*/
/*
     ftfBaryonNucDestrP1Tgt.SetEnabled(true); 
     multiUniv.Add( &ftfBaryonNucDestrP1Tgt );
     ftfBaryonNucDestrP1TgtADEP.SetEnabled(true);  
     multiUniv.Add( &ftfBaryonNucDestrP1TgtADEP ); 
     ftfBaryonNucDestrP2Tgt.SetEnabled(true);
     multiUniv.Add( &ftfBaryonNucDestrP2Tgt );
     ftfBaryonNucDestrP3Tgt.SetEnabled(true);     
     multiUniv.Add( &ftfBaryonNucDestrP3Tgt ); 
     ftfBaryonPtNucDestrP1.SetEnabled(true); 
     multiUniv.Add( &ftfBaryonPtNucDestrP1 );
     ftfBaryonPtNucDestrP2.SetEnabled(true); 
     multiUniv.Add( &ftfBaryonPtNucDestrP2 );
     ftfBaryonExciEWndNucln.SetEnabled(true); // ( "BARYON_EXCI_E_PER_WNDNUCLN", "FTFP", 0., 100. );
     multiUniv.Add( &ftfBaryonExciEWndNucln );
*/
     ftfBaryonProc0A1.SetEnabled(true);
     multiUniv.Add( &ftfBaryonProc0A1 );
     ftfBaryonProc0B1.SetEnabled(true);
     multiUniv.Add( &ftfBaryonProc0B1 );
     ftfBaryonProc0A2.SetEnabled(true);
     multiUniv.Add( &ftfBaryonProc0A2 );
     ftfBaryonProc0B2.SetEnabled(true);
     multiUniv.Add( &ftfBaryonProc0B2 );
     ftfBaryonProc1A1.SetEnabled(true);
     multiUniv.Add( &ftfBaryonProc1A1 );
     ftfBaryonProc1B1.SetEnabled(true);
     multiUniv.Add( &ftfBaryonProc1B1 );
     ftfBaryonProc1A2.SetEnabled(true);
     multiUniv.Add( &ftfBaryonProc1A2 );
     ftfBaryonProc1B2.SetEnabled(true);
     multiUniv.Add( &ftfBaryonProc1B2 );
  }

  // test user silliness ... cross check
  // multiUniv.Add(&blah);

  multiUniv.WriteConfigRangeInfo(fclfile);

  bool dorandom = (nunivIn>0);
  size_t nuniv = (nunivIn>0) ? nunivIn : -nunivIn;
  /*
  std::cout << nunivIn << " random " << dorandom
            << " nuniv " << nuniv << std::endl;
  */

  if ( dorandom ) {

    multiUniv.WriteRandomUniverses(fclfile,nuniv,isProcLevel);

  } else {

    multiUniv.WriteScanUniverses(fclfile,nuniv,isProcLevel);

  }

  // END_PROLOG, close file
  fclfile << std::endl;
  fclfile << "END_PROLOG" << std::endl;
  fclfile.close();

  std::cout << std::endl;
  std::cout << "done generating universes:  " << filename << std::endl;
}
