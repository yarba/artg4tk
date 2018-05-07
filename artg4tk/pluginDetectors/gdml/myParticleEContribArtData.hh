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
// Author: Hans Wenzel (Fermilab)
// myParticleEContribArtData.hh
//=============================================================================// 

#ifndef MYPARTICLEECONTRIBARTDATA_HH
#define MYPARTICLEECONTRIBARTDATA_HH
#include <string>
#include <map>

namespace artg4tk {
// allows to store the contribution by each particle to the event
// The string stores Particle name, and the double the percentage of  
// the total deposited energy.     
  typedef std::map< std::string,double> myParticleEContribArtData;  
}

#endif
