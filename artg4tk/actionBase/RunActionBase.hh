// This file is the header for the @RunActionBase@ class.

// A base class for Geant user run actions

// There is no implementation file, as it is intended only as a base class.

// When you create a run action object, you have the option to overload the
// following methods:

// @BeginOfRun@ - This method, which takes a pointer to a constant @G4Run@ 
// object, is called once at the beginning of each run. Putting code in this
// method of an action object is equivalent to putting it in the 
// @BeginOfRun@ method of the simulation's run action class.

// @EndOfRun@ - This method, which takes a pointer to a constant @G4Run@ 
// object, is called once at the end of each run. Putting code in this method
// of an action object is equivalent to putting it in the @EndOfRun@ method
// of the simulation's run action class.


// Include guard
#ifndef RUN_ACTION_BASE_HH
#define RUN_ACTION_BASE_HH

#include <string>
#include <iostream>

#include "artg4tk/actionBase/ActionBase.hh"

#include "art/Framework/Services/Registry/ServiceHandle.h"
#include "artg4tk/services/ActionHolder_service.hh"
#include "art/Framework/Principal/Run.h"


// Declarations of types we use as input parameters
class G4Run;

// Everything goes in the Art G4 namespace
namespace artg4tk {

  class RunActionBase : public ActionBase {
  public:
    // Constructor. The derived class must call this constructor. It takes a 
    // single string for the name of the action object.
    RunActionBase(std::string myName)
      : ActionBase( myName )
    {
      art::ServiceHandle<artg4tk::ActionHolderService> actionHolder;
      actionHolder->registerAction(this);
    }


    // Destructor
    virtual ~RunActionBase();


    // h3. The interesting methods. 
    
    // All of these are defined to do nothing by default. Users can override 
    // them if desired, and if they're not overloaded, they do nothing.

    // Called at the beginning of each run.
    virtual void beginOfRunAction(const G4Run *) {}

    // Called at the end of each run.
    virtual void endOfRunAction(const G4Run *) {}

  };
}


#endif // RUN_ACTION_BASE_HH
