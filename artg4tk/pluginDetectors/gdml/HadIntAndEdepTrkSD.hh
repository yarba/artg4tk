//
//               __        __ __  __  __  
//   ____ ______/ /_____ _/ // / / /_/ /__
//  / __ `/ ___/ __/ __ `/ // /_/ __/ //_/
// / /_/ / /  / /_/ /_/ /__  __/ /_/ ,<   
// \__,_/_/   \__/\__, /  /_/  \__/_/|_|  
//               /____/                  
//
// artg4tk: art based Geant 4 Toolkit
// 
//=============================================================================
// InteractionSD.cc: sensitive detector that analysis the first interaction
// (based in test23 of the Geant 4 test suite)
// Author: Hans Wenzel (Fermilab)
//=============================================================================
#ifndef HadIntAndTrackerSD_h
#define HadIntAndTrackerSD_h 1

#include "Geant4/G4VSensitiveDetector.hh"
#include "artg4tk/DataProducts/G4DetectorHits/ArtG4tkVtx.hh"
#include "artg4tk/pluginDetectors/gdml/TrackerHit.hh"

class G4Step;
class G4HCofThisEvent;

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......
namespace artg4tk {

class HadIntAndEdepTrkSD : public G4VSensitiveDetector 
{

public:

   // ctor & dtor
   HadIntAndEdepTrkSD(G4String);
   ~HadIntAndEdepTrkSD();

   virtual void   Initialize( G4HCofThisEvent* );
   virtual G4bool ProcessHits( G4Step*, G4TouchableHistory* );
   virtual void   clear() { fFirstInter.Clear(); fEdepTrkHits.clear(); return; }
   
   // specific to this SD
   //
   const ArtG4tkVtx& Get1stInteraction() const { return fFirstInter; }
   const TrackerHitCollection& GetEdepTrkHits() const { return fEdepTrkHits; }

private:

    void ProcessHadInt( G4Step* );
    void ProcessEdep( G4Step* );

    ArtG4tkVtx                    fFirstInter;
    TrackerHitCollection fEdepTrkHits;

};
}
//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......

#endif

