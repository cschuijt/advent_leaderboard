class PagesController < ApplicationController
  def home
    @year = Year.last # Assuming the most recent year was created last...
  end
end
