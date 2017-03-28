module Auth
  class ContainerRegistryAuthenticationService

    attr_accessor :project, :current_user, :params

    AUDIENCE = 'container_registry'.freeze
    ISSUER = 'floating-dock'.freeze

    def initialize(user, params = {})
      @current_user, @params = user, params.dup
    end


    def execute

      unless scope || current_user || repository
        return error('DENIED', status: 403, message: 'access forbidden')
      end

      { token: authorized_token(scope).encoded }
    end

    def self.full_access_token(*names)
      puts Rails.configuration.x.marina.docker_registry_jwt_key
      token = JSONWebToken::RSAToken.new(Rails.configuration.x.marina.docker_registry_jwt_key)
      token.issuer = ISSUER
      token.audience = AUDIENCE
      token.expire_time = token_expire_at

      token[:access] = names.map do |name|
        { type: 'repository', name: name, actions: %w(*) }
      end

      token.encoded
    end

    def self.token_expire_at
      Time.now + 30.minutes
    end

    private

    def authorized_token(*accesses)
      token = JSONWebToken::RSAToken.new(Rails.configuration.x.marina.docker_registry_key)
      token.issuer = ISSUER
      token.audience = params[:service]
      token.subject = current_user.try(:name)
      token.expire_time = self.class.token_expire_at
      token[:access] = accesses.compact
      token
    end

    def scope
      return unless params[:scope]

      @scope ||= process_scope(params[:scope])
    end

    def process_scope(scope)
      type, name, actions = scope.split(':', 3)
      actions = actions.split(',')
      return unless type == 'repository'

      process_repository_access(type, name, actions)
    end

    def process_repository_access(type, name, actions)
      repository = Repository.find_by_full_path(name)
      return unless repository

      actions = actions.select do |action|
        can_access?(repository, action)
      end

      { type: type, name: name, actions: actions } if actions.present?
    end

    def can_access?(repository, requested_action)

      case requested_action
      when 'pull'
        user_can_pull?(repository)
      when 'push'
        user_can_push?(repository)
      else
        false
      end
    end

    def user_can_pull?(repository)
      repository.public? || can?(current_user, :read, repository)
    end

    def user_can_push?(repository)
      can?(current_user, :update, repository)
    end

    def error(code, status:, message: '')
      {
        errors: [{ code: code, message: message }],
        http_status: status
      }
    end

  end
end
