#include "edge.hpp"

namespace OVL
{

std::ostream& operator << (std::ostream& s, Edge& e)
  {
    s << e.a << " " << e.b << " " << e.e1 << " " << e.e2 << " " << e.nx << " " << e.ny << " " << e.mark;
    return s;
  }
  std::istream& operator >> (std::istream& s, Edge& e)
  {
    s>>e.a>>e.b>>e.e1>>e.e2>>e.nx>>e.ny>>e.mark;
    return s;
  }

};

