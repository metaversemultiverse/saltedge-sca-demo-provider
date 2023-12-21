class ProviderInstantActionController < BaseController
  # http://localhost:8080/instant_action
  get '/instant_action' do
    action = if get_or_create_action(get_action_cookie('action_id')).closed?
      create_action
    else
      get_or_create_action(get_action_cookie('action_id'))
    end

    @action_id = action.id.to_s

    save_action_cookie('action_id', action.id, response) if get_action_cookie('action_id') != @action_id

    @qr_link  = create_qr_code(create_app_link(@action_id))
    @app_link = create_app_link(@action_id)
    erb :instant_action
  end

  get '/instant_action/status' do
    action = Action.find_by(id: params['action_id'])
    status = action&.status || 'No action found'
    { status: status }.to_json
  end

  private

  def create_app_link(action_id)
    provider_id = SettingsHelper.provider_id.to_s

    "authenticator://saltedge.com/action?api_version=2&action_id=#{action_id}&provider_id=#{provider_id}"
  end

  def get_or_create_action(action_id)
    if Action.find_by(id: action_id).present?
      Action.find_by(id: action_id)
    else
      create_action
    end
  end

  def create_action
    Action.create!(
      code: SecureRandom.uuid,
      status: Action::PENDING,
      description_type: 'text'
    )
  end
end
