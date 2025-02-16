class CoffeesController < ApplicationController
    get '/coffees' do 
        if logged_in?
            @coffees = Coffee.all
            erb :'/coffees/index'
        else
            redirect '/login'
        end
    end

    get '/coffees/new' do 
        if logged_in?
            @roasts = Coffee.roasts
            @roasters = Roaster.all 
            erb :'/coffees/new'
        else
            redirect '/login'
        end
    end

    post '/coffees' do
        # should this require a logged in user?
        if params[:roaster][:name] == ""
            if !params[:coffee][:roast] || !params[:coffee][:roaster_id]
                redirect "/coffees/new"
            end
            @coffee = Coffee.find_or_initialize_by(name: normalize(params[:coffee][:name]), roast: params[:coffee][:roast], roaster_id: params[:coffee][:roaster_id]) 
        else
            roaster = Roaster.find_or_initialize_by(name: normalize(params[:roaster][:name]))
            if roaster.persisted?
                if @coffee = roaster.coffees.find_by(name: normalize(params[:coffee][:name]), roast: params[:coffee][:roast])
                else
                    @coffee = roaster.coffees.build(params[:coffee]) 
                end
            else
                @coffee = roaster.coffees.build(params[:coffee])
            end 
        end

        @coffee.save
        # check whether save was succesful or not before claiming success
        flash[:message] = "You successfully posted a new Coffee!"
        redirect "/coffees/#{@coffee.roaster.slug}/#{@coffee.slug}"
    end

    get '/coffees/:roaster/:slug' do 
        # i'm not familiar with sinatra, but rails has a way to avoid repeating the whole if logged_in? ... else redirect '/login' thing called before_filter...
        if logged_in?
            @roaster = Roaster.find_by_slug(params[:roaster])
            @coffee = @roaster.coffees.find_by_slug(params[:slug])
            
            erb :'/coffees/show'
        else
            redirect '/login'
        end
    end
end