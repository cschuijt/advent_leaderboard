class YearsController < ApplicationController
  def index
    @years = Year.all
  end

  def show
    @year = Year.find_by!(number: params[:year])
  end
end
