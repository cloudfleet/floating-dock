class Api::V1::SearchController < ApiController
  def query_all
    render json: PgSearch.multisearch(params[:q]).map(&:searchable)
  end
end
