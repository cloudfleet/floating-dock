class Api::V1::DashboardController < ApiController

  def show

    render json: {
      last_own_builds: last_own_builds,
      last_global_successful_builds: Build.where(state: 'pushed').last(10)
    }
  end

  def last_own_builds
    if current_api_v1_user
      namespaces = [current_api_v1_user.name] + current_api_v1_user.organizations.collect(&:name)
      Build.joins(repository_tag: :repository).where(repositories: {owner_name: namespaces}).last(10)
    end
  end

  def stats(namespace)
    repositories = Repository.where(owner_name: namespace)

    {
      build_count: {
        total: repositories.map{|r| r.builds.count}.reduce(:+).to_i,
        success: repositories.map{|r| r.builds.where(state: 'pushed').count}.reduce(:+).to_i,
        pending: repositories.map{|r| r.builds.where(end: nil).count}.reduce(:+).to_i,
        failure: repositories.map{|r| r.builds.where(state: 'failed').count}.reduce(:+).to_i
      },
      tags_with_failure: repositories.collect(&:repository_tags).flatten.select{|rt| rt.last_build && rt.last_build.state == "failed"},
      pending_builds: repositories.collect(&:builds).flatten.select{|b| b.end == nil}
    }
  end

end
