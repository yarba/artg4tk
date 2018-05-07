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
// CheckGenParticle_module.cc: Analysis module to analyze the GenParticles 
// in the Event 
// Author: Hans Wenzel (Fermilab)
//=============================================================================
// artg4tk includes:
#include "artg4tk/Analysis/CheckGenParticle_module.hh"
// framework includes:
#include "art/Framework/Core/EDAnalyzer.h"
#include "art/Framework/Core/ModuleMacros.h"
#include "art/Framework/Principal/Event.h"

//using namespace std;

artg4tk::CheckGenParticle::CheckGenParticle(fhicl::ParameterSet const& p) :
art::EDAnalyzer(p),
_myName(p.get<std::string>("name", "CheckGenParticle")),
_hnParts(0),
_directory(0),
_file(0) {
}

void artg4tk::CheckGenParticle::beginRun(const art::Run& thisRun) {
    std::cout << "******************************Run: " << thisRun.id() << ": looking at Run Header" << std::endl;
}

void artg4tk::CheckGenParticle::beginJob() {

    art::ServiceHandle<art::TFileService> tfs;
    _directory = gDirectory;
    std::cout << "******************************We are in the directory named: " << gDirectory->GetName() << std::endl;
    _file = gDirectory->GetFile();
    _hnParts = tfs->make<TH1F>("hnParts", "Number of generated Particles", 100, 0., 2000.);
} // end beginJob

void artg4tk::CheckGenParticle::analyze(const art::Event& event) {
    std::cout << "******************************event " << event.id().event() << ": looking at GenParticles" << std::endl;
    typedef std::vector< art::Handle<GenParticleCollection> > HandleVector;
    HandleVector allGens;
    event.getManyByType(allGens);

    cout << "GenParticles*********************Size: " << allGens.size() << endl;
    for (HandleVector::const_iterator i = allGens.begin(); i != allGens.end(); ++i) {
        const GenParticleCollection & gens(**i);
        cout << " ********************************CheckGenParticle:  collection size:  " << gens.size() << endl;
        _hnParts->Fill(gens.size());
        for (GenParticleCollection::const_iterator j = gens.begin(); j != gens.end(); ++j) {
            const GenParticle & genpart = *j;
            cout << "Part id:  " << genpart.pdgId() << endl;
            CLHEP::HepLorentzVector const& mom = genpart.momentum();
            cout << "Part Energy:  " << mom.e() << endl;
            cout << "invariant mass:  " << mom.invariantMass() << endl;
            cout << "momentum:  " << mom.pz() << endl;
            cout <<genpart<<endl;
        }
    }

} // end analyze

void artg4tk::CheckGenParticle::endJob() {
    cout << " ********************************CheckGenParticle: I am done " << endl;
}

using artg4tk::CheckGenParticle;

DEFINE_ART_MODULE(CheckGenParticle)
