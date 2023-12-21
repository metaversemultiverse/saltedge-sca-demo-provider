class ConfirmAuthorizationsWorker < BaseWorker
  sidekiq_options queue: 'sca-demo-sender', retry: false

  def perform(params)
    action_id          = params['action_id']
    authorization_code = params['authorization_code']
    is_confirm         = params['is_confirm']

    action = Action.find_by(id: action_id) || Action.find_by(code: action_id)
    return unless action

    authorizations = action.parsed_authorizations.each(&:symbolize_keys!)

    authorizations_to_update = authorizations.select do |a|
      a[:authorization_code] == authorization_code
    end

    authorizations_to_update.each { |a| a[:status] = is_confirm ? Action::CONFIRMED : Action::DENIED }

    action.update!(authorizations: authorizations.to_json)

    if authorizations.all? { |a| a[:status] != Action::PENDING }
      action.update!(status: is_confirm ? Action::CONFIRMED : Action::DENIED)
    end
  end
end
