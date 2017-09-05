#include "nodes.hpp"

namespace OVL
{
  std::ostream& operator << (std::ostream& s, Node& n)
  {
    s << n.x <<" " << n.y << " " << n.mark;
    return s;
  }
  std::istream& operator >> (std::istream& s, Node& n)
  {
    s>>n.x>>n.y>>n.mark;
    return s;
  }
}
