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
// CheckInteractions_module.cc: Analyzer module that demonstrates access to hits 
// and makes some histograms
// 
// Author: Hans Wenzel (Fermilab)
//=============================================================================
#include "artg4tk/Analysis/CheckInteractions_module.hh"
#include "art/Framework/Core/EDAnalyzer.h"
#include "art/Framework/Core/ModuleMacros.h"
#include "art/Framework/Principal/Event.h"
#include<vector>
#include <iostream>
#include <sstream>

artg4tk::CheckInteractions::CheckInteractions(fhicl::ParameterSet const& p) :
art::EDAnalyzer(p),
fNThetaBinsFW(p.get<int>("ThetaBinsFW", 4)),
fThetaMinFW(p.get<double>("ThetaMinFW", 0.05)),
fDeltaThetaFW(p.get<double>("DeltaThetaFW", 0.05)),
fNThetaBinsLA(p.get<int>("ThetaBinsLA", 9)),
fThetaMinLA(p.get<double>("ThetaMinLA", 0.35)),
fDeltaThetaLA(p.get<double>("DeltaThetaLA", 0.2)),
_fHistoNSec(0),
_hEdep(0),
_hnDRHits(0),
_hDREdep(0),
_hNCeren(0) {
}

void artg4tk::CheckInteractions::beginRun(const art::Run& thisRun) {
    thisRun.beginTime();
}

void artg4tk::CheckInteractions::beginJob() {

    art::ServiceHandle<art::TFileService> tfs;
    _fHistoNSec = tfs->make<TH1F>("NSec", "proton + Ta", 100, 0., 100.);
    //_hnHits = tfs->make<TH1F>("hnHits", "Number of CaloArtHits", 100, 0., 20000.);
    _hEdep = tfs->make<TH1F>("hEdep", "total Energy deposition in CaloArtHits", 100, 0., 15.);
    _hnDRHits = tfs->make<TH1F>("hnDRHits", "Number of DRCaloArtHits", 100, 0., 20000.);
    _hDREdep = tfs->make<TH1F>("hDREdep", "total Energy deposition in DRCaloArtHits", 100, 0., 11.);
    _hNCeren = tfs->make<TH1F>("hNCeren", "total number of Cerenkov Photons in DRCaloArtHits", 100, 0., 1000000.);

    string htitle;
    string hname;
    string ht = "proton + Ta";


    double thetaMin = 0.;
    double thetaMax = 0.;
    std::string theta_bin_fw;
    std::string theta_bin_la;

    for (int i = 0; i < fNThetaBinsFW; i++) {
        thetaMin = fThetaMinFW + fDeltaThetaFW*i;
        thetaMax = thetaMin + fDeltaThetaFW;

        std::ostringstream osTitle1;
        std::ostringstream osTitle2;
        std::ostringstream osTitle3;

        osTitle1.clear();
        osTitle1 << thetaMin;
        theta_bin_fw = osTitle1.str() + " < theta < ";
        osTitle2.clear();
        osTitle2 << thetaMax;
        theta_bin_fw += osTitle2.str();
        theta_bin_fw += "(rad)";

        osTitle3.clear();
        osTitle3 << i;

        htitle = ht + " -> X + pi-, " + theta_bin_fw;
        hname = "piminus_fw_" + osTitle3.str();
        TH1D* histo = tfs->make<TH1D>(hname.c_str(), htitle.c_str(), 80, 0., 8.0);
        //        fHistoSecPiMinusFW.push_back(new TH1D(hname.c_str(), htitle.c_str(), 80, 0., 8.0));
        fHistoSecPiMinusFW.push_back(histo);
        //      htitle = ht + " -> X + pi+, " + theta_bin_fw;
        //      hname = "piplus_fw_" + osTitle3.str();
        //      fHistoSecPiPlusFW.push_back(new TH1D(hname.c_str(), htitle.c_str(), 80, 0., 8.0));
    }


} // end beginJob

void artg4tk::CheckInteractions::analyze(const art::Event& event) {
    typedef std::vector< art::Handle<myInteractionArtHitDataCollection> > HandleVector;
    HandleVector allSims;
    event.getManyByType(allSims);

    cout << "CheckInteractions Event:  " << event.event() << "  Nr of Interaction collections: " << allSims.size() << endl;

    for (HandleVector::const_iterator i = allSims.begin(); i != allSims.end(); ++i) {
        const myInteractionArtHitDataCollection & sims(**i);
        cout << "InteractionHit collection size:  " << sims.size() << endl;
        if (sims.size() > 0) {
            _fHistoNSec->Fill(sims.size());
        }
        for (myInteractionArtHitDataCollection::const_iterator j = sims.begin(); j != sims.end(); ++j) {
            const myInteractionArtHitData& hit = *j;
            cout << "Name:  " << hit.pname
                    << " Momentum:  " << hit.pmom
                    << " Theta:  " << hit.theta
                    << endl;

            if (hit.theta < fThetaMinFW) continue;
            if (hit.theta < fThetaMinFW + fDeltaThetaFW * fNThetaBinsFW) {
                int ith = (hit.theta - fThetaMinFW) / fDeltaThetaFW;
                if (hit.pname == "pi-") {
                    fHistoSecPiMinusFW[ith]->Fill(hit.pmom);
                }
            }
        }
    }




} // end analyze

void artg4tk::CheckInteractions::endJob() {
    cout << " ********************************CheckInteractions: now normalizing the histos " << endl;
    double norm = _fHistoNSec->Integral();
    double xbin = _fHistoNSec->GetBinWidth(1);
    double scale = 1. / (xbin * norm);
    _fHistoNSec->Scale(scale);
    //fHistoNSec->Write();
}// end endJob

using artg4tk::CheckInteractions;

DEFINE_ART_MODULE(CheckInteractions)
