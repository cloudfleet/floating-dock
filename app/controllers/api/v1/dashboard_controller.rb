class Api::V1::DashboardController < ApiController

  def show
    if current_api_v1_user
      namespaces = [current_api_v1_user.name] + current_api_v1_user.organizations.collect(&:name)

      render json: Hash[*namespaces.map{|ns| [ns, stats(ns)]}.reduce(:+)]
    end
  end

  def stats(namespace)
    repositories = Repository.where(owner_name: namespace)

    {
      build_count: {
        total: repositories.map{|r| r.builds.count}.reduce(:+),
        success: repositories.map{|r| r.builds.where(state: 'success').count}.reduce(:+),
        pending: repositories.map{|r| r.builds.where(end: nil).count}.reduce(:+),
        failure: repositories.map{|r| r.builds.where(state: 'failure').count}.reduce(:+)
      },
      tags_with_failure: repositories.collect(&:repository_tags).flatten.select{|rt| rt.last_build && rt.last_build.state == "failure"},
      pending_builds: repositories.collect(&:builds).flatten.select{|b| b.end == nil}
    }
  end

end
