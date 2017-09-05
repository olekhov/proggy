
#include "mymesh.hpp"

#include <fstream>

using namespace std;


namespace OVL
{

Mesh::Mesh(std::string bn)
{
  int n,s,e;

  ifstream nf(bn+".n");
  ifstream sf(bn+".s");
  ifstream ef(bn+".e");


  nf >> n; sf >> s; ef >> e;

  for(int i=0;i<n;i++) 
  {
    Node node;
    nf >> node;
    nodes.push_back(node);
  }
  for(int i=0;i<s;i++) 
  {
    Edge edge;
    sf >> edge;
    edges.push_back(edge);
  }
 
  for(int i=0;i<e;i++) 
  {
    Element elem;
    ef >> elem;
    elementss.push_back(elem);
  } 
}

void Mesh::SaveMFEM(std::ostream&s)
{

}

} /* namespace OVL */
