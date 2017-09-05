#pragma once

#include <list>
#include <utils>
#include <tuple>

#include <iostream>
#include <string>


#include "nodes.hpp"
#include "edge.hpp"
#include "element.h"

namespace OVL
{
  class Mesh
  {
    public:
      std::list<Node> nodes;
      std::list<Edge> edges;
      std::list<Element> elements;

      Mesh(std::string bn);

      void SaveMFEM(std::ostream&s);

  };
}
