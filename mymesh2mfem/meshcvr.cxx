#include <iostream>
#include <fstream>



#include "mymesh.hpp"

using namespace std;

int main()
{

  OVL::Mesh m("sq1");
  ofstream fs("sq1.mesh");

  m.SaveMFEM(fs);

  return 0;
}
