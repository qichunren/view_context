# frozen_string_literal: true

# @author qichunren
class ViewContext
  attr_reader :main, :secondary

  def initialize(action_view)
    @view = action_view
  end

  def set_main(content = nil, &blk)
    @main = if blk
      @view.capture do
        blk.call
      end
    else
      content
    end
    nil
  end

  def set_secondary(content = nil, &blk)
    @secondary = if blk
      @view.capture do
        blk.call
      end
    else
      content
    end
    nil
  end

  def method_missing(name, *args, &blk)
    m = name.match(/^set_([a-z]\w*)/)
    if m
      iv = m[1]
      if blk
        instance_variable_set("@#{iv}", @view.capture { blk.call })
      else
        instance_variable_set("@#{iv}", args.first)
      end
      self.class.class_eval { attr_reader iv.to_sym }
    else
      super
    end
  end
end
