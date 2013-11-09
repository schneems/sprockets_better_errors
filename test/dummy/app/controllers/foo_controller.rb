class FooController < ApplicationController
  def index
  end

  def show
    render "foo/#{params[:id]}"
  end
end
