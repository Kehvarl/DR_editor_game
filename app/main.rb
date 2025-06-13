require 'app/camera.rb'
require 'app/root_scene.rb'

def init args
    args.state.offset = 640
    args.state.root_scene = RootScene.new(args)

end


def tick args
    if Kernel.tick_count == 0
        init args
    end

    args.state.root_scene.tick
end
