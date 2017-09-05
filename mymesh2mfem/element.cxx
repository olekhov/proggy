#include "element.hpp"

namespace OVL
{
  std::ostream& operator << (std::ostream& s, Element& e)
  {
    s << e.n1 << " " << e.n2 << " " << e.n3 << " ";
    s << e.e1 << " " << e.e2 << " " << e.e3 << " ";
    s << e.s1 << " " << e.s2 << " " << e.s3 << " ";
    s << e.mark << " " << e.A << " ";
    for(int i=0;i<3;i++) s << e.f1[i] << " ";
    for(int i=0;i<3;i++) s << e.f2[i] << " ";
    for(int i=0;i<3;i++) s << e.f3[i] << " ";
    s << std::endl;
    return s;
  }
  std::istream& operator >> (std::istream& s, Element& e)
  {
    s>> e.n1 >> e.n2 >> e.n3;
    s>> e.e1 >> e.e2 >> e.e3;
    s>> e.s1 >> e.s2 >> e.s3;
    s>> e.mark >> e.A;
    for(int i=0;i<3;i++) s >> e.f1[i] ;
    for(int i=0;i<3;i++) s >> e.f2[i] ;
    for(int i=0;i<3;i++) s >> e.f3[i] ;

    return s;
  }
}
