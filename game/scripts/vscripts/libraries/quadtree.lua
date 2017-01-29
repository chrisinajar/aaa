function CreateQuadTree (sizex, sizey)
  local QuadTree = {
    root = CreateEmptyNode(0, sizex, 0, sizey, 1),
    sizex = sizex,
    sizey = sizey
  }

  function QuadTree:AddBox (x1, x2, y1, y2, data)
    -- check coordinate order
    if x1 > x2 then
      local tmp = x1
      x1 = x2
      x2 = x1
    end
    if y1 > y2 then
      local tmp = y1
      y1 = y2
      y2 = y1
    end

    local box = CreateContainer(x1, x2, y1, y2, data)
    QuadTree.root = InsertBoxToNode(QuadTree.root, box)

    function InsertBoxToNode(node, box)
      if node.isLeaf then
        return InsertBoxToLeaf(node, box)
      end

      local midx = ((x2 - x1) / 2) + x1
      local midy = ((y2 - y1) / 2) + y1

      local isOnLeft = box.x1 < midx
      local isOnBottom = box.y1 < midy
      local isOnRight = box.x2 > midx
      local isOnTop = box.y2 > midy

      if isOnLeft and isOnBottom then
        node.nodes[1] = InsertBoxToNode(node.nodes[1], box)
      end
      if isOnRight and isOnBottom then
        node.nodes[2] = InsertBoxToNode(node.nodes[2], box)
      end
      if isOnLeft and isOnTop then
        node.nodes[3] = InsertBoxToNode(node.nodes[3], box)
      end
      if isOnRight and isOnTop then
        node.nodes[4] = InsertBoxToNode(node.nodes[4], box)
      end

      return node
    end

    function InsertBoxToLeaf(node, box)
      if #node.containers > (node.depth * 2) then
        DebugPrint ( '[ZoneControl] splitting node into sub-node' )
        local oldNode = node
        -- turn a leaf into a node
        node = CreateEmptyNode(box.x1, box.x2, box.y1, box.y2, box.depth)
        InsertBoxToNode(node, box)

        for i,container in ipairs(node.containers) do
          InsertBoxToNode(node, container)
        end
        return node
      end
    end
  end

  function CreateEmptyNode (x1, x2, y1, y2, depth)
    -- this is where all the splitting and depth calculation happens
    -- we put the data into the leaves, then just carry it over if the twig grows
    local midx = ((x2 - x1) / 2) + x1
    local midy = ((y2 - y1) / 2) + y1

    return {
      isLeaf = false,
      depth = depth,
      nodes = [
        CreateEmptyLeaf(x1, midx, y1, midy, depth + 1), -- bottom left
        CreateEmptyLeaf(midx, x2, y1, midy, depth + 1), -- bottom right
        CreateEmptyLeaf(x1, midx, midy, y2, depth + 1), -- top left
        CreateEmptyLeaf(midx, x2, midy, y2, depth + 1)  -- top right
      ],
      x1 = x1,
      x2 = x2,
      y1 = y1,
      y2 = y2
    }
  end

  function CreateEmptyLeaf (x1, x2, y1, y2, depth)
    return {
      isLeaf = true,
      depth = depth,
      containers = [],
      x1 = x1,
      x2 = x2,
      y1 = y1,
      y2 = y2
    }
  end

  function CreateContainer(x1, x2, y1, y2, data)
    return {
      x1 = x1,
      x2 = x2,
      y1 = y1,
      y2 = y2,
      data = data
    }
  end

  return QuadTree
end
