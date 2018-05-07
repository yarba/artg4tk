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
// CalorimeterSD.cc: Class representing a sensitive Detector for a Calorimeter
// Author: Hans Wenzel (Fermilab)
//=============================================================================
#include "artg4tk/pluginDetectors/gdml/CalorimeterSD.hh"
#include "Geant4/G4HCofThisEvent.hh"
#include "Geant4/G4Step.hh"
#include "Geant4/G4ThreeVector.hh"
#include "Geant4/G4SDManager.hh"
#include "Geant4/G4ios.hh"
#include "Geant4/G4VVisManager.hh"

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......

artg4tk::CalorimeterSD::CalorimeterSD(G4String name)
: G4VSensitiveDetector(name) {
    G4String HCname = name + "_HC";
    collectionName.insert(HCname);
    G4cout << collectionName.size() << "   artg4tk::CalorimeterSD name:  " << name << " collection Name: " << HCname << G4endl;
    HCID = -1;
}

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......

artg4tk::CalorimeterSD::~CalorimeterSD() {

}

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......

void artg4tk::CalorimeterSD::Initialize(G4HCofThisEvent* HCE) {

  calorimeterCollection.clear();
    if (HCID < 0) {
        G4cout << "artg4tk::CalorimeterSD::Initialize:  " << SensitiveDetectorName << "   " << collectionName[0] << G4endl;
        HCID = G4SDManager::GetSDMpointer()->GetCollectionID(collectionName[0]);
    }
}

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......

G4bool artg4tk::CalorimeterSD::ProcessHits(G4Step* aStep, G4TouchableHistory*) {
    G4double edep = aStep->GetTotalEnergyDeposit() / CLHEP::MeV;
    if (edep == 0.) return false;
    const G4double time = aStep->GetPreStepPoint()->GetGlobalTime() / CLHEP::ns;
    const G4VTouchable* touch = aStep->GetPreStepPoint()->GetTouchable();
    const G4ThreeVector cellpos = touch->GetTranslation();
    int ID = aStep->GetPreStepPoint()->GetPhysicalVolume()->GetCopyNo();
    //std::cout<<"ID:  "<<ID<<"  Edep:  "<< edep<<std::endl;
    G4Track* theTrack = aStep->GetTrack();
    G4String particleType = theTrack->GetDefinition()->GetParticleName();
    // 
    //  check if this cell has been hit before
    //

    for (unsigned int j = 0; j < calorimeterCollection.size(); j++) {
        CalorimeterHit aPreviousHit = calorimeterCollection[j];
        if (ID == aPreviousHit.GetID()) {
            aPreviousHit.SetEdep(aStep->GetTotalEnergyDeposit() + aPreviousHit.GetEdep());
            if ((particleType == "e+") || (particleType == "gamma") || (particleType == "e-")) {
                aPreviousHit.Setem_Edep(edep + aPreviousHit.GetEdepEM());
            } else {
                aPreviousHit.Setnonem_Edep(edep + aPreviousHit.GetEdepnonEM());
            }
            return true;
        }
    }
    //
    // otherwise create a new hit:
    //
    CalorimeterHit newHit;
    if ((particleType == "e+") || (particleType == "gamma") || (particleType == "e-")) {
      newHit= CalorimeterHit(ID,edep,edep,0.0,cellpos.x(),cellpos.y(),cellpos.z(),time);
    } else {
      newHit= CalorimeterHit(ID,edep,0.0,edep,cellpos.x(),cellpos.y(),cellpos.z(),time);
    }
    calorimeterCollection.push_back(newHit);
    return true;
}

//....oooOO0OOooo........oooOO0OOooo........oooOO0OOooo........oooOO0OOooo......

