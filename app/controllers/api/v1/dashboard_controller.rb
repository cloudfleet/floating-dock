class Api::V1::DashboardController < ApiController

  def show

    render json: {
      last_own_builds: last_own_builds,
      last_global_successful_builds: Build.includes(repository_tag: :repository).where(state: 'pushed').last(10).map{
        |build|
        {
          repository: {
            name: build.repository.name,
            owner_name: build.repository.owner_name
          },
          tags: [build.repository_tag.name] + build.repository_tag.additional_tags.split(','),
          architecture: build.architecture,
          duration: build.end - build.start,
          pushed: build.end
        }
      }
    }
  end

  def last_own_builds
    if current_api_v1_user
      namespaces = [current_api_v1_user.name] + current_api_v1_user.organizations.collect(&:name)
      Build.joins(repository_tag: :repository)
        .includes(repository_tag: :repository)
        .where(repositories: {owner_name: namespaces})
        .last(10)
        .map {
          |build|
          {
            id: build.id,
            repository: {
              name: build.repository.name,
              owner_name: build.repository.owner_name
            },
            tags: [build.repository_tag.name] + build.repository_tag.additional_tags.split(','),
            architecture: build.architecture,
            state: build.state,
            duration: build.updated_at - build.start,
            last_updated: build.updated_at
          }
        }
    end
  end


end
