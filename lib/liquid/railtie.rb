module Liquid

  class Railtie < Rails::Railtie

    require 'liquid'
    require 'extras/liquid_view'

    config.after_initialize do
      ActionView::Template.register_template_handler :liquid, LiquidView
    end

  end

end

