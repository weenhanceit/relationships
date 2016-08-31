class PeopleController < ApplicationController
  def index
    @people = Person.all
  end

  def new
    @person = Person.new
  end

  def edit
    @person = Person.find(params[:id])
  end
end
