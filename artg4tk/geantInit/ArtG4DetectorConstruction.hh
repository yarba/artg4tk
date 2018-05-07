// ArtG4DetectorConstruction

//  ArtG4DetectorConstruction serves as the user-created Detector Construction
//  class in the Artized Art G4 simulation. 
//  In all GEANT simulations, a DetectorConstruction class (derived from
//  G4VUserDetectorConstruction) must be created and passed to the run manager.
//  Then, when the run manager is initialized, it calls DetectorConstruction's
//  Construct() method, which is responsible for constructing the geometry of
//  the simulation and returning the world physical volume. 
//  In this highly modular simulation framework, however, no one class knows
//  about the whole geometry. Rather, individual detectors and geometry 
//  components register with the DetectorHolder service, which matches each
//  component with its desired mother volume and eventually constructs the 
//  whole simulation geometry. All that Construct() needs to do, then, is 
//  retrieve the DetectorHolder's world physical volume and return it.
//  Thus, this simple class will work for any simulation setup, and does not
//  need to be modified for the addition or modification of each geometry
//  component.
//  It is worth noting that the world volume must exist at the time of the
//  ArtG4DetectorConstruction object's construction. 

//  Author: Tasha Arvanitis, Adam Lyon

//  Date: July 2012

#ifndef ARTG4_DETECTOR_CONSTRUCTION_HH
#define ARTG4_DETECTOR_CONSTRUCTION_HH

#include "Geant4/G4VPhysicalVolume.hh"
#include "Geant4/G4VUserDetectorConstruction.hh"

namespace artg4tk {

  class ArtG4DetectorConstruction : public G4VUserDetectorConstruction {
  public:
    // Two constructors - the first gets a service handle to the 
    // DetectorHolder and gets the world volume from there...
    ArtG4DetectorConstruction();
    // ... and the second is passed the world volume as an argument.
    explicit ArtG4DetectorConstruction(G4VPhysicalVolume *);

    // No cleanup is necessary, because GEANT takes care of deleting the world
    // volume when it's finished.
    ~ArtG4DetectorConstruction(){};

    // Construct() is called by GEANT on its own and just returns the world
    G4VPhysicalVolume * Construct();

  private:
    G4VPhysicalVolume * world_;
  };

}

#endif // ARTG4_DETECTOR_CONSTRUCTION_HH
