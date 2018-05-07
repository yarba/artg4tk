// PhysicsListServiceBase
#ifndef PHYSICS_LIST_SERVICE_BASE_HH
#define PHYSICS_LIST_SERVICE_BASE_HH

#include "art/Framework/Services/Registry/ServiceHandle.h"
#include "artg4tk/services/PhysicsListHolder_service.hh"

#include <memory>
#include "Geant4/G4VUserPhysicsList.hh"

namespace artg4tk {

  class PhysicsListServiceBase {
    
    public:
    
    // The constructor does the registration
    PhysicsListServiceBase() {
      art::ServiceHandle<PhysicsListHolderService> ph;
      ph->registerPhysicsListService( this );
    }
    
    
    // Make the physics list
    virtual G4VUserPhysicsList* makePhysicsList() = 0;
    
    // Call initialize if you need to.
    // This gets called AFTER the physics list is given to Geant.
    // If you don't override it, then nothing will happen when called
    virtual void initializePhysicsList() {};
  };
    
}//namespace artg4tk

#endif
