class ReviewController < ApplicationController
    before_action :authenticate_user!

    def index
        if params[:query] == ''
            flash.now[:error] = "Whoops, you didn't submit anything!  Try again?"
        elsif params[:query].present?
                unless Trade.tagged_with(params[:query]).exists?
                    flash.now[:error] = "Hmmm, those tags don't seem to exist!  Try again?"
                    render 'index'
                else
                    @scope = Trade.scope_age
                    @sum = 0 #used for cumulative chart
                    @trades = current_user.trades.tagged_with(params[:query])
                    # @daterange = @trades.created_between(:startdate, :enddate)
                    @chart = current_user.trades.all
                    @tags = params[:query]
                    @pipresult = @trades.sum :result
                    @average = @trades.average(:result).round(1)
                    @winrate = ((@trades.where('result > 0').count.to_f / @trades.count.to_f) * 100).round(1)
                    @largestwin = @trades.maximum :result
                    @largestloss = @trades.minimum :result
                end
        else
            @trades = current_user.trades.all
        end
    end
end

