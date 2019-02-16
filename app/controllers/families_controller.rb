class FamiliesController < ApplicationController
  def create
    # puts pp(params.as_json)
    # puts pp(person_params.as_json)
    @person = Person.new(person_params)
    if @person.save(person_params)
      redirect_to person_path(@person)
    else
      render :new
    end
  end

  def edit
    @person = Person.includes(:children).find(params[:id])
    puts "Children: #{@person.children.inspect}"
  end

  def new
    @person = Person.new
  end

  def update
    # puts pp(person_params.as_json)
    @person = Person.find(params[:id])
    if @person.update(person_params)
      redirect_to person_path(@person)
    else
      render :edit
    end
  end
end
