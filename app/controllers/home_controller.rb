class HomeController < ApplicationController
    def index
        @promotions = Promotion.all
    end

end