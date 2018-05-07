#ifndef Chi2Calc_H
#define Chi2Calc_H 1

//#include <iostream>
//#include <string>

#include "TMatrixD.h"
#include "TMatrixDBase.h"

class TH1;
class TGraphErrors;

class Chi2Calc
{

   public:
   
      // ctor & dtor
      //
      Chi2Calc() : fChi2(0.) {}
      ~Chi2Calc() {}
      
      double Chi2DataMC( const TH1*, const TH1*, int&, const double mcscale=1. );
      double Chi2DataMC( const TGraphErrors*, const TH1*, int&, const double mcscale=1. );
      double Chi2DataMC( const TH1*, const TH1*, int&, TMatrixD&, const double mcscale=1. );
      double Chi2DataMC( const TGraphErrors*, const TH1*, int&, TMatrixD&, const double mcscale=1. );
      
      const std::vector< std::pair<int,double> >& GetChi2MCBin() const { return fChi2MCBin; }
               
   private:
   
      // data members
      //
      double fChi2;
      std::vector< std::pair<int,double> > fChi2MCBin;

};

#endif
