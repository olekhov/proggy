
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
    elements.push_back(elem);
  } 
}

void Mesh::SaveMFEM(std::ostream&s)
{
  s << "MFEM mesh v1.0" << endl;
  s << "dimension" << endl << 2 << endl;

  s << "elements" << endl << elements.size() << endl;
  for( list<Element>::iterator it=elements.begin(); it != elements.end(); ++it)
  {
    s << it->mark << " 2 " << it->n1 << " " << it->n2 << " " << it->n3 << endl;
  }

  int bs=0;
  for(list<Edge>::iterator it=edges.begin(); it!=edges.end(); ++it)
    if(it->mark!=0) bs++;

  s << "boundary" << endl << bs << endl;
  for(list<Edge>::iterator it=edges.begin(); it!=edges.end(); ++it)
  {
    s << it->mark << " 1 " << it->a << " " << it->b << endl;
  }

  s << "vertices" << endl << nodes.size() << endl << 2 << endl;
  for(list<Node>::iterator it=nodes.begin(); it!=nodes.end(); ++it)
  {
    s << it->x << " " << it->y << endl;
  }
}

} /* namespace OVL */
