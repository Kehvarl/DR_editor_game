def tick_map_editor args
  # determine the location of the mouse, but
  # aligned to the grid
  grid_aligned_mouse_rect = {
    x: args.inputs.mouse.x.idiv(32) * 32,
    y: args.inputs.mouse.y.idiv(32) * 32,
    w: 32,
    h: 32
  }

  # determine if there's a tile at the grid aligned mouse location
  existing_terrain = args.state.terrain.find { |t| t.intersect_rect? grid_aligned_mouse_rect }

  # if there is, then render a red square to denote that
  # the tile will be deleted
  if existing_terrain
    args.outputs.sprites << {
      x: args.inputs.mouse.x.idiv(32) * 32,
      y: args.inputs.mouse.y.idiv(32) * 32,
      w: 32,
      h: 32,
      path: "sprites/square/red.png",
      a: 128
    }
  else
    # otherwise, render a blue square to denote that
    # a tile will be added
    args.outputs.sprites << {
      x: args.inputs.mouse.x.idiv(32) * 32,
      y: args.inputs.mouse.y.idiv(32) * 32,
      w: 32,
      h: 32,
      path: "sprites/square/blue.png",
      a: 128
    }
  end

  # if the mouse is clicked, then add or remove a tile
  if args.inputs.mouse.click
    if existing_terrain
      args.state.terrain.delete existing_terrain
    else
      args.state.terrain << { **grid_aligned_mouse_rect, path: "sprites/square/blue.png" }
    end

    # once the terrain state has been updated
    # save the terrain data to disk
    write_terrain_data args
  end
end

def read_terrain_data args
  # create the terrain data file if it doesn't exist
  contents = args.gtk.read_file "data/terrain.txt"
  if !contents
    args.gtk.write_file "data/terrain.txt", ""
  end

  # read the terrain data from disk which is a csv
  args.gtk.read_file('data/terrain.txt').split("\n").map do |line|
    x, y, w, h = line.split(',').map(&:to_i)
    { x: x, y: y, w: w, h: h, path: 'sprites/square/blue.png' }
  end
end

def write_terrain_data args
  terrain_csv = args.state.terrain.map { |t| "#{t.x},#{t.y},#{t.w},#{t.h}" }.join "\n"
  args.gtk.write_file 'data/terrain.txt', terrain_csv
end

